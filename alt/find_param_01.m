function we1 = find_param_01(small_kernel, sigma, display_results)

beta = 1;

im_in0 = im2double(imread('./images/in/im_00.png'));
% im_in0 = im2double(imread('./images/in/im_005.png'));
% im_in0 = im_in0(:,:,2);

KR  = floor((size(small_kernel, 1) - 1)/2); 
KC = floor((size(small_kernel, 2) - 1)/2); 
SNR_pad_size = max(KR,KC); 
pad_size = 2 * SNR_pad_size;
%SNR_pad_size = 10;

[im_blurred, im_in, noise] = blurrAndNoiseLinear(im_in0, small_kernel, sigma);
[im_blurred_padded, mask_pad] = imPad(im_blurred, pad_size);    
[R, C, CH] = size(im_blurred_padded);  
    
b1_im_in   = get_b1(im_in);

kernel = getBigKernel(R, C, small_kernel);
fft2_kernel   = fft2(kernel);  conj_fft2_kernel = conj(fft2_kernel);

A0 = conj_fft2_kernel   .* fft2_kernel;
A1 = getA1(R,C);
B0 = conj_fft2_kernel .* fft2(im_blurred_padded);

%--------------------------------------------------------------------------
if display_results
    hFig = figure('Color',[1 1 1]); x = 100; y = 100; w = 900; h = 800;
    set(hFig, 'Position', [x y w h]);
    set(gca,'fontsize',20);
end;

exp_min = -8; exp_max = 2;
nmax = 100;
delta = (exp_max - exp_min) / (nmax-1);
d     = zeros(1,nmax);
param = zeros(1,nmax);

%--------------------------------------------------------------------------
for l = 1:nmax
    exponent = exp_min + delta * (l-1);
    we2 =  10 .^ exponent;
%==========================================================================
    A  = A0 + we2 * A1;
    fft2_im_out = B0 ./ A;
    im_out_padded = real(ifft2(fft2_im_out));
    im_out = imUnpad(im_out_padded, mask_pad, pad_size);
    sigma_s = 20;  sigma_r = 0.2;
    im_out = RF(im_out, sigma_s, sigma_r, 1);
%==========================================================================
    b1_im_out = get_b1(im_out);
    d(l) = errors(b1_im_in, b1_im_out, beta);
%    d(l) = errors(im_in, im_out, beta);

    param(l) = exponent;

    if l == 1
        min_d  = d(1);
        min_we = we2;
        min_im_out = im_out;
    else
        if d(l) < min_d
            min_d   = d(l);
            min_we  = we2;
            min_im_out = im_out;
        end;
    end;
end;

we1 = min_we;


%--------------------------------------------------------------------------
if display_results
    h1 = plot(param, d, 'r', 'LineWidth', 2);
end;

if display_results
    h = legend([h1], {'First iteration'});
    rect = [0.6, 0.7, .10, .10];
    set(h, 'Position', rect);
    xlabel('log10(\lambda)');
    ylabel('\Delta');

%    saveplot(sprintf('./images/out/find_params_%d_beta_%d.png', 1000 * sigma, 10 * beta));
%--------------------------------------------------------------------------
    figure; imshow(im_in); title('im in'     );
    figure; imshow(im_blurred); title('im blurred');
    figure; imshow(mat2gray(kernel)); title('kernel');

    A  = A0 + 0.001 * A1;
    fft2_im_out = B0 ./ A;
    im_out = real(ifft2(fft2_im_out));
    sigma_s = 20;  sigma_r = 0.2;
    im_out = RF(im_out, sigma_s, sigma_r, 1);
    figure; imshow(im_out) ; title('im out 0p001');

    A  = A0 + we1 * A1;
    fft2_im_out = B0 ./ A;
    im_out = real(ifft2(fft2_im_out));
    sigma_s = 20;  sigma_r = 0.2;
    im_out = RF(im_out, sigma_s, sigma_r, 1);
    figure; imshow(min_im_out) ; title('min im out');


%    plot_out(we1, im_in, kernel, im_blurred, min_im_out);
end;


%==========================================================================
function d = errors(im_in, im_out, beta)

[R, C] = size(im_in);
N = (R * C);

d0  = abs(im_in - im_out);

if beta == 1
    d = sum(d0(:)) / N;
else
    d0 = d0 .^ beta;
    d  = ( (sum(d0(:)) / N) .^ (1/beta));
end;

%==========================================================================
% function plot_out(we, im_in, kernel, im_blurred, im_min)
% disp we
% figure; imshow(im_in); title('im in'     );
% figure; imshow(mat2gray(kernel)); title('kernel');
% figure; imshow(im_blurred); title('im blurred');

% for k = 1:it+1
%      subplot(4,4,k+4);imshow(im_min{k});
% end;

%==========================================================================
function saveplot(filename)
% SAVEPLOT - Save current plot to disk in a .png file.

cmd = ['print -dpng ',filename]; % .png graphics format
% For monochrome PostScript format:
%     cmd = ['print -deps ',filename];
% For color PostScript format:
%     cmd = ['print -depsc ',filename];
% Etc. - say 'help print' in either Matlab or Octave
%disp(cmd);
eval(cmd);
