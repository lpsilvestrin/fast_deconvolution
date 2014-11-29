function result = deconvolve(G, H, weights, w_set, derivs)
    [rows, cols, chans] = size(G);

    A = conj(H) .* H;
    for i = 1 : 5
        S = weights(i) * (conj(derivs(:, :, i)) .* derivs(:, :, i));
        A += S;
    end;

    W = fft2(w_set);
    B = conj(H) .* G;

    result = ifft2(B ./ A);
