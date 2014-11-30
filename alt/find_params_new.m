function [w1, w2] = find_params_new(small_kernel, im_blurred)

%--------------------------------------------------------------------------
% noise level
[R, C, CH] = size(im_blurred);    
ch = 1; if CH > 1  ch = 2; end;
sigma = 1.02 * NoiseLevel(im_blurred(:,:,ch));
%sigma = 0.008; %test7.bmp
%--------------------------------------------------------------------------
% pad image
KR  = floor((size(small_kernel, 1) - 1)/2); KC = floor((size(small_kernel, 2) - 1)/2); 
SNR_pad_size = max(KR,KC); 
pad_size = 2 * SNR_pad_size;
[im_blurred_padded, mask_pad] = imPad(im_blurred, pad_size);    
[R, C, CH] = size(im_blurred_padded);   
%figure; imshow(im_blurred_padded);

%--------------------------------------------------------------------------
% find gaussian param
display_results = false;
w1  = find_gaussian_param(small_kernel, sigma, display_results);
wev = [w1, 20, 0.033, 0.05];
   
%--------------------------------------------------------------------------
im_out      = zeros(R, C, CH);
im_out_temp = zeros(R, C, CH);    
im_out_bi   = zeros(R, C, CH);
B0          = zeros(R, C, CH);

%--------------------------------------------------------------------------
big_kernel       = getBigKernel(R, C, small_kernel);
fft2_kernel      = fft2(big_kernel);
conj_fft2_kernel = conj(fft2_kernel);
A0  = real(conj_fft2_kernel .* fft2_kernel);
A1  = getA1(R,C);
A10 = A0 + wev(1) .* A1;
 
%--------------------------------------------------------------------------
% Gaussian step
for ch = 1:CH % RGB channels
    B0(:,:,ch)  = conj_fft2_kernel .* fft2(im_blurred_padded(:,:,ch));
    im_out_gaussian(:,:,ch)   = real(ifft2(B0(:,:,ch) ./ A10)); 
end;
%figure; imshow(im_out_gaussian);

%--------------------------------------------------------------------------
% Bilateral filter:
sigma_s = wev(2);  sigma_r = wev(3);
%im_out_bi = RF(im_out_gaussian, sigma_s, sigma_r, 1);
im_out_bi = our_RF(im_out_gaussian, sigma_s, sigma_r);
%figure; imshow(im_out_bi);

%--------------------------------------------------------------------------
for ch = 1:CH % RGB channels
    b1(:,:,ch) = get_b1(im_out_bi(:,:,ch));
    fft2_b1(:,:,ch) = fft2(b1(:,:,ch));
end;

w2 = 0;
exp1_min = -4; exp1_max = 0; max1it = 40;
delta1 = (exp1_max - exp1_min) / (max1it-1);

for l1 = 1:max1it
    exponent1 = exp1_min + delta1 * (l1-1);
    exps1(l1) = exponent1; 

    wev(4) = 10 .^ exponent1;
    A12  = A0 + wev(4) .* A1;
    for ch = 1:CH % RGB channels
        B = B0(:,:,ch) + wev(4) .* fft2_b1(:,:,ch);    
        im_out_padded(:,:,ch)  = real(ifft2(B ./ A12)); 
    end;

    obj1 = rec_error(im_out_padded, im_blurred_padded, small_kernel, mask_pad, pad_size);  
    objs1(l1) = obj1;

    if obj1 > sigma
        w2 =  wev(4);
        break;
    end;

%     obj2 = der_error(im_out_padded, im_blurred_padded, small_kernel, mask_pad, pad_size, im_out_bi);
%     objs2(l1) = obj2;
%     
%     if wev(4) .* obj2 > 0.001
%         w2 =  wev(4);
%         break;
%     end;
    
end;


% hFig = figure('Color',[1 1 1]); x = 100; y = 100; w = 900; h = 800; 
% set(hFig, 'Position', [x y w h]);
% set(gca,'fontsize',10);
% 
% title('ALL');
% xlabel('log10(we1)');
% ylabel('error');
% 
% %object = objs1 + (10 .^ exps1) .* objs2;
% object = (10 .^ exps1) .* objs2 + objs2;
% 
% h1 = plot(exps1, objs1, 'k', 'LineWidth', 2);
% %axis([-6, 0, 0, 0.25]);
% hold on;
% h2 = plot(exps1, objs2/5, 'b', 'LineWidth', 2);
% h3 = plot(exps1, sigma, '--m', 'LineWidth', 2);
% h4 = plot(exps1, object, 'r', 'LineWidth', 2);
% h = legend([h1, h2, h4],{'|hf - g|_2','derivs / 5', 'lambda derivs'});
% rect = [0.7, 0.7, .10, .10];
% set(h, 'Position', rect);
% 
% hold off;

%figure; imshow(im_out_padded);

function obj1 = rec_error(im_out_padded, im_blurred_padded, small_kernel, mask_pad, pad_size)   
    [R, C, CH] = size(im_out_padded);    

    ch = 1;
    if CH > 1 
        ch = 2; 
    end;
    
    hf = conv2(im_out_padded(:,:,ch), small_kernel, 'same');
    t1 = hf - im_blurred_padded(:,:,ch);
    t1 = imUnpad(t1, mask_pad(:,:,ch), pad_size);
      
    t1 = t1 .* t1;
    obj1 = sum(t1(:));

    [R, C, CH] = size(t1);    
    obj1 = obj1 / (R * C); 
    obj1 = sqrt(obj1);

        
function obj2 = der_error(im_out_padded, im_blurred_padded, small_kernel, mask_pad, pad_size, im_out_bi)   
    [R, C, CH] = size(im_out_padded);    

    ch = 1; if CH > 1 ch = 2; end;
    
    hf = conv2(im_out_padded(:,:,ch), small_kernel, 'same');
    t1 = hf - im_blurred_padded(:,:,ch);
    t1 = imUnpad(t1, mask_pad(:,:,ch), pad_size);
      
    t1 = t1 .* t1;
    obj1 = sum(t1(:));

    [R, C, CH] = size(t1);    
    obj1 = obj1 / (R * C); 
    obj1 = sqrt(obj1);
    
    dx   = [-0.5, 0, 0.5];
    dy   = [-0.5; 0; 0.5];
    dxx  = [-1 / 1.4142, 2 / 1.4142, -1 / 1.4142];
    dyy  = [-1 / 1.4142; 2 / 1.4142; -1 / 1.4142]; 
    dxy  = [-1.4142, 1.4142, 0; 1.4142, -1.4142, 0 ; 0, 0, 0];

    im_out = imUnpad(im_out_padded(:,:,ch), mask_pad(:,:,ch), pad_size);
    im_bi  = imUnpad(im_out_bi(:,:,ch), mask_pad(:,:,ch), pad_size);

% use_dx
    w  = conv2(im_bi, dx, 'same');       
    wx1  = sparse(w);
    w  = wx1 - conv2(im_out, dx, 'same');       
    obj = w .* w;

    w  = conv2(im_bi, dy, 'same');
    wy1  = sparse(w);
    w  = wy1 - conv2(im_out, dy, 'same');       
    obj = obj + w .* w;

% use_dxx
    w  = conv2(im_bi, dxx, 'same');
    wxx1  = sparse(w);
    w  = wxx1 - conv2(im_out, dxx, 'same');       
    obj = obj + w .* w;

    w  = conv2(im_bi, dyy, 'same');
    wyy1  = sparse(w);
    w  = wyy1 - conv2(im_out, dyy, 'same');       
    obj = obj + w .* w;

% use_dxy
    w  = conv2(im_bi, dxy, 'same');
    wxy1  = sparse(w);
    w  = wxy1 - conv2(im_out, dxy, 'same');              
    obj = obj + w .* w;

    obj2 = sum(obj(:));
    obj2 = obj2 / (R * C); 
    obj2 = sqrt(obj2);

function dw = sparse(x)
lambda = 0.065;

dw =  x .* ( 1 - (1 ./ (1 + ((x / lambda) .^ 4)) ) );
    
    xl = lambda ./ x;
    xl = xl .* xl;
    xl = xl .* xl; % = (lambda ./ x) .^ 4
    xl = 1 + xl;
    
    dw =  x ./ xl;
            