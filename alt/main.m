load 'kernels.mat';

f = imread('cameraman.bmp');

[rows, cols, chans] = size(f);

% Degrading function and its transforms
h = kernel1;
H = fft2(h, rows, cols);

% Degraded image

G = fft2(f) .* H;
g = ifft2(G);
gn = imnoise(g, 'gaussian', 0.1, 50);

% lambda array in equation
weights1 = 0.001 * ones(1, 5);

f0 = deconvolve(gn, H, weights1, fft2(zeros(rows, cols, 5)));

%% STEP 2

sigma_s = 30;
sigma_r = 0.3;
f1 = RF(im2double(uint8(real(f0))), sigma_s, sigma_r);
%f1 = imsmooth(im2double(uint8(real(f0))), 'Bilateral');
f1 = im2uint8(f1);

%% STEP 3
%% compute regularization priors
ws = compute_priors(f1);
f2 = deconvolve(f1, H, 0.1 * ones(1, 5), real(ws));
