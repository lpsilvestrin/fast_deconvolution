load 'kernels.mat';

f = imread('cameraman.jpg');

[rows, cols, chans] = size(f);

% Degrading function and its transforms
h = kernel1;
H = fft2(h, rows, cols);

% Degraded image

G = fft2(f) .* H;

% lambda array in equation
weights1 = 0.001 * ones(1, 5);

f0 = deconvolve(G, H, weights1, zeros(rows, cols, 5));

%% STEP 2

sigma_s = 60;
sigma_r = 0.4;
%f1 = NC(f0, sigma_s, sigma_r);
%{
for i = 1 : 5
    S = weights1(i) * (conj(derivs(:, :, i)) .* W(:, :, i));
    B += S;
end;
%}

%% STEP 3
%% compute regularization priors
