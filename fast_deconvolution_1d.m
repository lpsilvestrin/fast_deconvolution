function deconvolved = fast_deconvolution_1d(img, kernel)
% deconvolve 1d image
% step 1
[rows cols] = size(img);
weights1 = [0.001 0.001 0.001 0.001 0.001];
sobelx = [[-1 0 1]; [-2 0 2]; [-1 0 1]];
sobely = [-1 -2 -1; 0 0 0; 1 2 1];
% finding derivatives
dx = (conv2(img, double(sobelx)))(3:rows+2,3:cols+2);
dxx = diff(dx, 1, 2);
dxx = padarray(dxx, [0,1], 0, 'post'); 
dy = diff(img, 1, 1);
dy = padarray(dy, [1,0], 0, 'post'); 
dyy = diff(dy, 1, 1);
dyy = padarray(dyy, [1,0], 0, 'post'); 
dxy = diff(dx, 1, 1);
dxy = padarray(dxy, [1,0], 0, 'post'); 

% calculates Fourier transformations
H = fft2(kernel);
DX = fft2(dx);
DY = fft2(dy);
DXX = fft2(dxx);
DYY = fft2(dyy);
DXY = fft2(dxy);
G = fft2(img);

A = conj(H) .* H;
A = A + weights1(1)*conj(DX) .* DX;
A = A + weights1(2)*conj(DY) .* DY;
A = A + weights1(3)*conj(DXX) .* DXX;
A = A + weights1(4)*conj(DYY) .* DYY;
A = A + weights1(5)*conj(DXY) .* DXY;
B = conj(H) .* G; % B is just H .* G since Ws = 0

f1 = ifft2(B ./ A);
deconvolved = f1;

% step 2: edge-preserving smoothing filtering

% step 3: 
weights2 = [0.05 0.05 0.05 0.05 0.05];
