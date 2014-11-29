load 'kernels.mat';

f = imread('cameraman.jpg');

[rows, cols, chans] = size(f);

% derivative of image
sobelV = fspecial('sobel');
sobelH = transpose(sobelV);
prewittH = fspecial('prewitt');
prewittV = transpose(prewittH);
dx = (conv2(f, sobelH))(3 : rows + 2, 3 : cols + 2);
dy = (conv2(f, sobelV))(3 : rows + 2, 3 : cols + 2);
derivs = fillDerivs(dx, dy, rows, cols);
%derivs = fillDerivs(prewittH, prewittV, rows, cols);

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
    S = weights1(i) * (conj(derivs(:, :, i)) .* derivs(:, :, i));
    A += S;
end;

w = zeros(rows, cols, 5);
W = fft2(w);

B = conj(H) .* G;
for i = 1 : 5
    S = weights1(i) * (conj(derivs(:, :, i)) .* W(:, :, i));
    B += S;
end;

