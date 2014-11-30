function result = deconvolve(G, H, weights, w_set)
    [rows, cols, chans] = size(G);

    % derivative set
    sobelV = fspecial('sobel');
    sobelH = transpose(sobelV);
    dx = sobelH;
    DX = fft2(dx, rows, cols);
    dy = sobelV;
    DY = fft2(dy, rows, cols);
    derivs = fillDerivs(DX, DX, rows, cols);

    A = conj(H) .* H;
    for i = 1 : 5
        S = weights(i) * (conj(derivs(:, :, i)) .* derivs(:, :, i));
        A += S;
    end;

    W = fft2(w_set);
    B = conj(H) .* G;
    for i = 1 : 5
        S = weights(i) * (conj(derivs(:, :, i)) .* W(:, :, i));
        B += S;
    end;

    result = ifft2(B ./ A);
