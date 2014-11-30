function we = find_params(small_kernel, sigma, it_max, beta, display_results)

% im_in = im2double(imread('./images/in/im_00.png'));
% im_in = im_in(:,:,1);

im_in = im2double(imread('./images/in/im_005.png'));
im_in(:) = 0.5;
im_in = im_in(:,:,2);

[R, C] = size(im_in);
b1_im_in   = get_b1_circ(im_in);

kernel = getBigKernel(R, C, small_kernel);
[im_blurred noise] = blurrAndNoise(im_in, kernel, sigma);
fft2_kernel   = fft2(kernel);  conj_fft2_kernel = conj(fft2_kernel);

A0 = conj_fft2_kernel   .* fft2_kernel;
A1 = getA1(R,C);

B0 = conj_fft2_kernel .* fft2(im_blurred);

%--------------------------------------------------------------------------
if display_results
    hFig = figure('Color',[1 1 1]); x = 100; y = 100; w = 900; h = 800;
    set(hFig, 'Position', [x y w h]);
    set(gca,'fontsize',20);
end;

exp_min = -8; exp_max = 2;
max = 100;
delta = (exp_max - exp_min) / (max-1);
d     = zeros(1,max);
param = zeros(1,max);
we    = zeros(1,it_max);

for it = 1:it_max
%--------------------------------------------------------------------------
    for l = 1:max
        exponent = exp_min + delta * (l-1);
        we2 =  10 .^ exponent;
%==========================================================================
        if it > 1
            b = B0 + we2 * B1;
        else
            b = B0;
        end;
        A  = A0 + we2 * A1;
        fft2_im_out = b ./ A;
        im_out = real(ifft2(fft2_im_out));
%==========================================================================
        if it == it_max
            d(l) = errors(im_in, im_out, 0.7);
        else
            b1_im_out = get_b1_circ(im_out);
            d(l) = errors(b1_im_in, b1_im_out, beta);
        end;

        param(l) = exponent;

        if l == 1
            min_d  = d(1);
            min_we = we2;
            min_im_out = im_out;
        else
            if d(l) < min_d
                min_d   = d(l);
                min_we  = we2;
                min_im_out = im_out;
            end;
        end;
    end;
%--------------------------------------------------------------------------
    we(it) = min_we;

    if display_results
        hold on;
        if it == 1
            h1 = plot(param, d, 'r', 'LineWidth', 2);
            %axis([exp_min, exp_max, 0, 0.3]);
        else
            h2 = plot(param, d, 'b', 'LineWidth', 2);
        end;
    end;
    
    if display_results
        im_min{it} = min_im_out;
    end;
    %......................................................................
    % calc weights using best deconvolved image from previous iteration
    b1 = get_b1_circ(min_im_out);
    B1 = fft2(b1);

%--------------------------------------------------------------------------
%   figure; imshow(min_im_out) ; title('min im out');
end;

if display_results
    h = legend([h1 h2],{'First iteration', 'Others iterations'});
    rect = [0.6, 0.7, .10, .10];
    set(h, 'Position', rect);
    xlabel('log10(\lambda)');
    ylabel('\Delta');

    saveplot(sprintf('./images/out/find_params_%d_beta_%d.png', 1000 * sigma, 10 * beta));
%    plot_out(we, it, im_in, kernel, im_blurred, im_min);
end;

%==========================================================================
function d = errors(im_in, im_out, beta)

[R, C] = size(im_in);
N = (R * C);

d0  = abs(im_in - im_out);

if beta == 1
    d = sum(d0(:)) / N;
else
    d0 = d0 .^ beta;
    d  = ( (sum(d0(:)) / N) .^ (1/beta));
end;

%==========================================================================
function plot_out(we, it, im_in, kernel, im_blurred, im_min)
disp we
figure;
subplot(4,4,1); imshow(im_in); title('im in'     );
subplot(4,4,2); imshow(mat2gray(kernel)); title('kernel');
subplot(4,4,3); imshow(im_blurred); title('im blurred');

for k = 1:it+1
     subplot(4,4,k+4);imshow(im_min{k});
end;

%==========================================================================
function saveplot(filename)
% SAVEPLOT - Save current plot to disk in a .png file.

cmd = ['print -dpng ',filename]; % .png graphics format
% For monochrome PostScript format:
%     cmd = ['print -deps ',filename];
% For color PostScript format:
%     cmd = ['print -depsc ',filename];
% Etc. - say 'help print' in either Matlab or Octave
%disp(cmd);
eval(cmd);
