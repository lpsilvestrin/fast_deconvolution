load 'kernels.mat';

f = imread('reef.jpg');
h = kernel1;
pad_amount = 2 * length(h);
f = padding(f, pad_amount);

[rows, cols, chans] = size(f);

% Degrading function and its transforms
h_big = getBigKernel(rows, cols, h);
H = fft2(h_big);

% Degraded image

for c = 1 : chans
    g(:, :, c) = conv2(double(f(:, :, c)), h, 'same');
endfor;
G = fft2(g);
gn = imnoise(g, 'gaussian', 0.04, 10);

% lambda array in equation
weights1 = 0.001 * ones(1, 5);

f0 = deconvolve(gn, H, weights1, fft2(zeros(rows, cols, 5)));

%% STEP 2

sigma_s = 60;
sigma_r = 0.04;
f1 = our_RF(im2double(uint8(real(f0))), sigma_s, sigma_r);
f1 = im2uint8(f1);

%% STEP 3
%% compute regularization priors
%ws = compute_priors(f1);
f2 = deconvolve(f1, H, 0.1 * ones(1, 5), fft2(zeros(rows, cols, 5)));

%% Remove padding
f3 = f2(pad_amount : rows - pad_amount,
        pad_amount : cols - pad_amount,
        :);

imwrite(uint8(real(gn)), 'gn.jpg');
imwrite(uint8(real(f0)), 'f0.jpg');
imwrite(uint8(real(f1)), 'f1.jpg');
imwrite(uint8(real(f2)), 'f2.jpg');
imwrite(uint8(real(f3)), 'f3.jpg');
