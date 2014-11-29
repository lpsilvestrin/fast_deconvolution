load 'kernels.mat';

f = imread('cameraman.jpg');

[rows, cols, chans] = size(f);

% derivative of image
sobelV = fspecial('sobel');
sobelH = transpose(sobelV);
derivs = fillDerivs(sobelH, sobelV, rows, cols);

% Degrading function and its transforms
h = kernel1;
H = fft2(h, rows, cols);

% Degraded image

g = conv2(double(f), h);
G = fft2(g, rows, cols);

% lambda array in equation
weights1 = 0.001 * ones(1, 5);

A = conj(H) .* H;
for i = 1 : 5
    M = weights1(i) * (conj(derivs(:, :, i)) .* derivs(:, :, i));
    A += M;
end;

w = zeros(rows, cols, 5);
W = fft2(w);

B = conj(H) .* G;
for i = 1 : 5
    M = weights1(i) * (conj(derivs(:, :, i)) .* W(:, :, i));
    B += M;
end;

