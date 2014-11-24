function deconvolved = fast_deconvolution_1d(img, kernel, weights)
% deconvolve 1d image
% step 1
% finding derivatives
sobelx = [[-1, 0, 1], [-2, 0, 2], [-1, 0, 1]];
sobely = [[1 2 1] [0 0 0] [-1 -2 -1]];
dx = conv2(double(img), double(sobelx));
dxx = conv2(dx, sobelx);
dy = conv2(img, sobely);
dyy = conv2(dy, sobely);
dxy = conv2(dx, sobely);
imshow(dx);
d = [dx, dy, dxx, dyy, dxy];