function ws = compute_priors(f, derivs)
    [rows, cols] = size(f);
    thresholds = zeros(1, 5);
    thresholds(1, 1:2) = 0.065;     %first-order
    thresholds(1, 3:5) = 0.0325;    %second-order
    ws = zeros(1, 5);
    for i = 1 : 5
        threshold = thresholds(1, i);
        der = conv2(derivs(:, :, i), double(f));
        denom = (threshold ./ der) ^ 4 + 1;
        ws(i) = der / denom;
    end
