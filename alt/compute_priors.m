function ws = compute_priors(f)
    [rows, cols] = size(f);

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
        der = conv2(double(f), fst_derivs(:, :, i), 'same');
        denom = (threshold ./ der) .^ 4 + 1;
        ws(:, :, i) = der ./ denom;
    end

    threshold = 0.0325;
    for i = 1 : 3
        der = conv2(double(f), snd_derivs(:, :, i), 'same');
        denom = (threshold ./ der) .^ 4 + 1;
        ws(:, :, i + 2) = der ./ denom;
    end
    %{
    ws = zeros(rows, cols);
    derivs = getA1(rows, cols);
    F = fft2(f);
    numer = derivs .* F;
    threshold = 0.0325;
    denom = threshold ./ numer;
    denom = denom .^ 4 + 1;

    ws(:, :) = numer ./ denom;
    %}



