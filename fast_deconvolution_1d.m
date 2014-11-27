function deconvolved = fast_deconvolution_1d(img, kernel, weights)
% deconvolve 1d image
% step 1
% finding derivatives
dx = diff(img, 1, 2);
dx = padarray(dx, [0,1], 0, 'post'); 
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
A = A + weights(1)*conj(DX) .* DX;
A = A + weights(2)*conj(DY) .* DY;
A = A + weights(3)*conj(DXX) .* DXX;
A = A + weights(4)*conj(DYY) .* DYY;
A = A + weights(5)*conj(DXY) .* DXY;
B = conj(H) .* G; % B is just HC .* G since Ws = 0
