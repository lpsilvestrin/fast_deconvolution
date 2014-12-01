load 'kernels.mat';

f = imread('cameraman.jpg');

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

f0 = deconvolve(gn, H, weights1, zeros(rows, cols));

%% STEP 2

sigma_s = 60;
sigma_r = 0.4;
f1 = RF(im2double(uint8(abs(f0))), sigma_s, sigma_r);
f1 = im2uint8(f1);

%% STEP 3
%% compute regularization priors
ws = compute_priors(f1);
%%ws = find_params_new(h, f1);
%f2 = deconvolve(f1, H, 0.05 * ones(1, 5), ws);
