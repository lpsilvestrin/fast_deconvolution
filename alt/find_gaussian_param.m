function we = find_gaussian_param(small_kernel, sigma, display_results)

noise_thresold = 0.05;
noise_thresold2 = noise_thresold * noise_thresold;

R = 32; C = R;
big_kernel  = getBigKernel(R, C, small_kernel);
im_blurred = 0.5 + randn(R, C) * sigma;
%--------------------------------------------------------------------------
exp1_min = -5; exp1_max = 0; max1it = 200;
delta1 = (exp1_max - exp1_min) / (max1it-1);

fft2_kernel = fft2(big_kernel);
conj_fft2_kernel = conj(fft2_kernel);

B0 = conj_fft2_kernel .* fft2(im_blurred);
A0 = real(conj_fft2_kernel .* fft2_kernel);
A1 = getA1(R,C);

big_dx = zeros(R, C); big_dx(1,1) = 1; big_dx(1,end) = -1;
Dx = fft2(big_dx);

B0x = B0 .* Dx;

% figure;
% imshow(mat2gray(real(Dx)));

we = 0;

for l1 = 1:max1it
    
    exponent1 = exp1_min + delta1 * (l1-1);
    we1 = 10 .^ exponent1;
    exps1(l1) = exponent1;

    % Gaussian step
    A10  = A0 + we1 .* A1;
    derx = B0x ./ A10;    
    derx2  = conj(derx) .* derx  ;
%    L2s(l1) = sqrt(sum(derx2(:)) / (R * C));
    L2s(l1) = sum(derx2(:)) / (R * C * R * C);

    if L2s(l1) < noise_thresold2
        we = 10 .^ exponent1;
        break;
    end;

end;
% 
% 
% hFig = figure('Color',[1 1 1]); x = 100; y = 100; w = 900; h = 800; 
% set(hFig, 'Position', [x y w h]);
% set(gca,'fontsize',10);
% 
% title('|dx|_2');
% xlabel('log10(we1)');
% ylabel('|dx|_2');
% 
% h4 = plot(exps1, sqrt(L2s), 'm', 'LineWidth', 2);
% %axis([-6, 0, 0, 0.25]);
% hold on;
% h2 = plot(exps1, noise_thresold, 'k', 'LineWidth', 2);
% % h = legend([h2, h3, h4],{'|hf - g|_2','|f - f0|_2', '|dx|_2 + |dy|_2' });
% % rect = [0.7, 0.7, .10, .10];
% % set(h, 'Position', rect);
% 
% hold off;
% 
