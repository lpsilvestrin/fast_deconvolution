function deconvolved = fast_deconvolution_1d(img, kernel, weights)
% deconvolve 1d image
% step 1
% finding derivatives
dx = diff(img, 1, 2);
dxx = diff(dx, 1, 2);
dy = diff(img, 1, 1);
dyy = diff(dy, 1, 1);
dxy = diff(dx, 1, 1);
size(dxy)
imshow(uint8(dyy));
d = [dx, dy, dxx, dyy, dxy];