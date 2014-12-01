function ws = compute_priors(f)
    [rows, cols] = size(f);

    ws = zeros(1, 5);
    derivs = getA1(rows, cols);
    F = fft2(f);
    for i = 1 : 5
        numer = derivs .* f;
        if (i < 3)
            threshold = 0.065;
        else
            threshold = 0.0325;
        endif;
        denom = threshold ./ numer;
        denom = denom .^ 4 + 1;
        ws(1, i) = numer ./ denom;
    endfor;



    %{
    dy = fspecial('sobel');
    dx = transpose(dy);
    DX = fft2(dx);
    DY = fft2(dy);
    fst_derivs = zeros(3, 3, 2);
    fst_derivs(:, :, 1) = dx;
    fst_derivs(:, :, 2) = dy;
    snd_derivs = zeros(5, 5, 3);
    snd_derivs(:, :, 1) = conv2(dx, dx);
    snd_derivs(:, :, 2) = conv2(dy, dy);
    snd_derivs(:, :, 3) = conv2(dx, dy);

    ws = zeros(rows, cols, 5);

    threshold = 0.065;
    for i = 1 : 2
        der = conv2(fst_derivs(:, :, i), double(f), 'same');
        denom = (threshold ./ der) ^ 4 + 1;
        ws(:, :, i) = der ./ denom;
    end

    threshold = 0.0325;
    for i = 1 : 3
        der = conv2(snd_derivs(:, :, i), double(f), 'same');
        denom = (threshold ./ der) ^ 4 + 1;
        ws(:, :, i + 2) = der ./ denom;
    end
    %}
