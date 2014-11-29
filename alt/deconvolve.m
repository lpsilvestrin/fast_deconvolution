function result = deconvolve(G, H, weights, w_set)
    [rows, cols, chans] = size(G);
    % derivative of image
    sobelV = fspecial('sobel');
    sobelH = transpose(sobelV);
    dx = sobelH;
    DX = fft2(dx, rows, cols);
    dy = sobelV;
    DY = fft2(dy, rows, cols);
    derivs = fillDerivs(DX, DX, rows, cols);

    %% STEP 1
    A = conj(H) .* H;
    for i = 1 : 5
        S = weights(i) * (conj(derivs(:, :, i)) .* derivs(:, :, i));
        A += S;
    end;

    W = fft2(w_set);
    B = conj(H) .* G;

    result = ifft2(B ./ A);
