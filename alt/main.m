load 'kernels.mat';

f = imread('cameraman.jpg');
[rows, cols, chans] = size(f);

h = kernel1;
pad_amount = 2 * length(h);

f = padding(f, pad_amount);
[rows, cols, chans] = size(f);
% generate gn degraded without pad 
g = zeros(size(f));
for c = 1 : chans
    g(:, :, c) = conv2(double(f(:, :, c)), h, 'same');
end;
gn = imnoise(g, 'gaussian', 0, 1);
%gn = g + randn(rows, cols, chans) * 0.3;
%%%%%%%%% gn generated %%%%%%%%


% Degrading function and its transforms
h_big = getBigKernel(rows, cols, h);
H = fft2(h_big);

% Degraded image

% lambda array in equation
weight1 = 0.001;

A0 = real(conj(H) .* H);
A1 = getA1(rows, cols);
A10 = A0 + weight1 .* A1;
f0 = zeros(rows, cols, chans);
for c = 1 : chans
    B0(:,:,c) = conj(H) .* fft2(gn(:,:,c));
    f0(:,:,c) = real(ifft2(B0(:,:,c) ./ A10));
endfor;

%f0 = deconvolve(gn, H, weights1, fft2(zeros(rows, cols, 5)));

%% STEP 2

sigma_s = 60;
sigma_r = 0.04;
f1 = our_RF(im2double(uint8(real(f0))), sigma_s, sigma_r);
f1 = im2uint8(f1);

%% STEP 3
%% compute regularization priors
%ws = compute_priors(f1);
%f2 = deconvolve(f1, H, 0.1 * ones(1, 5), fft2(zeros(rows, cols, 5)));
weight2 = 0.05;
A12  = A0 + weight2 .* A1;
f2 = zeros(rows, cols, chans);
for c = 1 : chans 
    b1 = get_b1(f1(:, :, c));
    B = B0(:, :, c) + weight2 .* fft2(b1);    
    f2(:,:,c)  = real(ifft2(B ./ A12)); 
end;

%% Remove padding
f3 = f2(pad_amount : rows - pad_amount,
        pad_amount : cols - pad_amount,
        :);

imwrite(uint8(real(gn)), 'gn.jpg');
imwrite(uint8(real(f0)), 'f0.jpg');
imwrite(uint8(real(f1)), 'f1.jpg');
imwrite(uint8(real(f2)), 'f2.jpg');
imwrite(uint8(real(f3)), 'f3.jpg');
