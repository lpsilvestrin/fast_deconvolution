load 'kernels.mat';

f = imread('cameraman.jpg');

[rows, cols, chans] = size(f);


% Generate matrix containing all needed derivatives from the image
function derivs = fillDerivs(dx, dy)
    [rows, cols] = size(dx); %assuming same size for both dx and dy
    derivs = zeros(rows, cols, 5);
    derivs(:, :, 1) = fft2(double(dx), rows, cols);            % dx
    derivs(:, :, 2) = fft2(double(dy), rows, cols);            % dy
    derivs(:, :, 3) = fft2(double(conv2(dx, dx)), rows, cols); % dxx
    derivs(:, :, 4) = fft2(double(conv2(dy, dy)), rows, cols); % dyy
    derivs(:, :, 5) = fft2(double(conv2(dx, dy)), rows, cols); % dxy

% derivative of image
sobelV = fspecial('sobel');
sobelH = transpose(sobelV);
derivs(sobelH, sobelV);

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

