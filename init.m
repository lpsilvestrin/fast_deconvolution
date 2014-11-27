I = imread('Cameraman.bmp');
lp = imread('low_pass.bmp');
lp = lp(:,:,1);
lp = lp/255;
kernel = ifft2(lp);
lp = fftshift(lp);
trans = fft2(I);
blurred = trans.*double(lp);

blurred = ifft2(blurred);
