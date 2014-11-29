load 'kernels.mat';

f = imread('cameraman.jpg');

[rows, cols, chans] = size(f);


% Degrading function and its transforms
h = kernel1;
H = fft2(h, rows, cols);

% Degraded image

g = conv2(double(f), h);
G = fft2(f) .* H;

% derivative of image
sobelV = fspecial('sobel');
sobelH = transpose(sobelV);
prewittH = fspecial('prewitt');
prewittV = transpose(prewittH);
%dx = (conv2(g, sobelH))(3 : rows + 2, 3 : cols + 2);
%dy = (conv2(g, sobelV))(3 : rows + 2, 3 : cols + 2);
dx = sobelH;
DX = fft2(dx, rows, cols);
dy = sobelV;
DY = fft2(dy, rows, cols);
derivs = fillDerivs(DX, DX, rows, cols);
%derivs = fillDerivs(prewittH, prewittV, rows, cols);

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
%{
for i = 1 : 5
    S = weights1(i) * (conj(derivs(:, :, i)) .* W(:, :, i));
    B += S;
end;
%}

