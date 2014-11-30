load 'kernels.mat'; 

I = imread('tst.JPG');
[rows, cols, chans] = size(I);
k = kernel1;
J = conv2(I, k)(3 : rows + 2, 3 : cols + 2);

k_dim = size(k);
h = sparse(rows*cols, rows*cols);

f = reshape(transpose(I), 1, rows * cols);
g = reshape(transpose(J), 1, rows * cols);

h = sparse(rows * cols, rows * cols);
for i = 1 : (rows - k_dim(1))
    for j = 1 : (cols - k_dim(2))
%        printf('expanding col %d, row %d\n', j, i);
%        printf('printing %d, %d\n', i, j);
        h(i * j, :) = expand_kernel(k, rows, cols, i, j);
%        arr = reshape(transpose(arr), 1, rows * cols);
%        h(i * j, :) = arr;
    end
end

% Degrading function and its transforms

% Degraded image
H = fft2(h);
%g = conv2(double(f), h);
%G = fft2(f) .* H;
%g = ifft2(G);

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
ws = compute_priors(f1);
f2 = deconvolve(g, H, weights2, ws);
