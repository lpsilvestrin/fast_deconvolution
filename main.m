load 'kernels.mat';

f = imread('cameraman.jpg');

[rows, cols, chans] = size(f);

% derivative of image
sobelV = fspecial('sobel');
sobelH = transpose(sobelV);

% Matrix containing all needed derivatives from the image
derivs = zeros(rows, cols, 5);
derivs(:, :, 1) = fft2(double(sobelH), rows, cols);                % dx
derivs(:, :, 2) = fft2(double(sobelV), rows, cols);                % dy
derivs(:, :, 3) = fft2(double(conv2(sobelH, sobelH)), rows, cols); % dxx
derivs(:, :, 4) = fft2(double(conv2(sobelV, sobelV)), rows, cols); % dyy
derivs(:, :, 5) = fft2(double(conv2(sobelH, sobelV)), rows, cols); % dxy

% Degrading function and its transforms
h = kernel1;
H = fft2(h, rows, cols);

% Degraded image

g = conv2(double(f), h);
G = fft2(g, rows, cols);

% lambda array in equation
weights1 = 0.001 * zeros(1, 5);

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

