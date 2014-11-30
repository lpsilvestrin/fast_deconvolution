load 'kernels.mat';

f = imread('cameraman.jpg');

[rows, cols, chans] = size(f);

% Degrading function and its transforms
h = kernel1;
H = fft2(h, rows, cols);
f = imnoise(f, 'gaussian', 0.1, 100);

% Degraded image

G = fft2(f) .* H;
g = ifft2(G);

% lambda array in equation
weights1 = 0.001 * ones(1, 5);

f0 = deconvolve(g, H, weights1, zeros(rows, cols, 5));

%% STEP 2

sigma_s = 60;
sigma_r = 0.4;
f1 = RF(f0, sigma_s, sigma_r);

%% STEP 3
%% compute regularization priors
