function deconvolved = fast_deconvolution_1d(img, kernel, weights)
% deconvolve 1d image
% step 1
% finding derivatives
dx = diff(img, 1, 2);
dxx = diff(dx, 1, 2);
dy = diff(img, 1, 1);
dyy = diff(dy, 1, 1);
dxy = diff(dx, 1, 1);

% calculates Fourier transformations
H = fft2(kernel);
DX = fft2(dx);
DY = fft2(dy);
DXX = fft2(dxx);
DYY = fft2(dyy);
DXY = fft2(dxy);
G = fft2(img);

% calculates complex conjugates
HC = conj(H);
DXC = conj(DX);
DYC = conj(DY);
DXXC = conj(DXX);
DYYC = conj(DYY);
DXYC = conj(DXY);

A = HC .* H;
A = A + weights(1)*DXC .* DX;
A = A + weights(2)*DYC .* DY;
A = A + weights(3)*DXXC .* DXX;
A = A + weights(4)*DYYC .* DYY;
A = A + weights(5)*DXYC .* DXY;
B = HC .* G; % B is just HC .* G since Ws = 0

