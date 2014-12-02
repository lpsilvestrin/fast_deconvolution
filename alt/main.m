load 'kernels.mat';

f = imread('cameraman.jpg');
[f_rows, f_cols, chans] = size(f);

h = kernel1;
pad_amount = 2 * length(h);

%padding for degrading function
[f_padded, mask] = padding(f, pad_amount);

% generate gn degraded without pad 
g0 = zeros(size(f_padded));
for c = 1 : chans
    g0(:, :, c) = conv2(double(f_padded(:, :, c)), h, 'same');
end;
% clear borders
for c = 1 : chans
    g0(:,:,c) = g0(:,:,c) ./ mask;
endfor;
% remove degrading function's padding
g = g0(pad_amount : f_rows + pad_amount,
        pad_amount : f_cols + pad_amount,
        :);

gn = imnoise(g, 'gaussian', 0, 0.1);
%gn = g + randn(rows, cols, chans) * 0.3;
%%%%%%%%% gn generated %%%%%%%%

% actually padding for deconvolution process
[gn, mask] = padding(gn, pad_amount);
[rows, cols, chans] = size(gn);

% Degrading function and its transforms
h_big = getBigKernel(rows, cols, h);
H = fft2(h_big);

% Degraded image

weight1 = 0.001;

A0 = real(conj(H) .* H);
A1 = getA1(rows, cols);
A10 = A0 + weight1 .* A1;
f0 = zeros(rows, cols, chans);
B0 = zeros(rows, cols, chans);
for c = 1 : chans
    B0(:,:,c) = conj(H) .* fft2(gn(:,:,c));
    f0(:,:,c) = real(ifft2(B0(:,:,c) ./ A10));
endfor;

%f0 = deconvolve(gn, H, weights1, fft2(zeros(rows, cols, 5)));

%% STEP 2

sigma_s = 60;
sigma_r = 0.04;
f1 = our_RF(im2double(uint8(real(f0))), sigma_s, sigma_r);
f1 = im2uint8(f1);

%% STEPS 3 and 4
weight2 = 0.05;
A12  = A0 + weight2 .* A1;
f2 = zeros(rows, cols, chans);
for c = 1 : chans 
    %% compute regularization priors
    reg_terms = comp_reg_terms(f1(:, :, c));
    %% and adds them
    B = B0(:, :, c) + weight2 .* fft2(reg_terms);    
    f2(:,:,c)  = real(ifft2(B ./ A12)); 
end;

%% Remove padding
for i=1:chans
	f2b(:,:,i) = f2(:,:,i) ./ mask;
end

f3 = f2b(pad_amount : f_rows + pad_amount ,
        pad_amount : f_cols + pad_amount,
        :);


imwrite(uint8(real(g)), 'g.jpg');
imwrite(uint8(real(gn)), 'gn.jpg');
imwrite(uint8(real(f0)), 'f0.jpg');
imwrite(uint8(real(f1)), 'f1.jpg');
imwrite(uint8(real(f2)), 'f2.jpg');
imwrite(uint8(real(f3)), 'f3.jpg');
