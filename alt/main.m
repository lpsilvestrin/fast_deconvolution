load 'kernels.mat';

I = imread('cameraman.jpg');
k = kernel1;
J = conv2(I, k);

[rows, cols, chans] = size(I);
h = sparse(rows*cols, rows*cols);

f = reshape(transpose(I), 1, rows * cols);
g = reshape(transpose(J)), 1, rows * cols);

% Degrading function and its transforms

% Degraded image

%g = conv2(double(f), h);
G = fft2(f) .* H;
g = ifft2(G);

% lambda array in equation
weights1 = 0.001 * ones(1, 5);

f0 = deconvolve(g, H, weights1, zeros(rows, cols, 5));

%% STEP 2

sigma_s = 60;
sigma_r = 0.4;
f1 = NC(f0, sigma_s, sigma_r);

%% STEP 3
%% compute regularization priors
weights2 = 0.05 * ones(1, 5);
ws = compute_priors(f0);
f2 = deconvolve(f1, H, weights2, ws);
