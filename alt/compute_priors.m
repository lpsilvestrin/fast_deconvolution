function ws = compute_priors(f)

	[rows, cols] = size(f);

    dx   = [-0.5, 0, 0.5];
    dy   = [-0.5; 0; 0.5];
    dxx  = [-1 / 1.4142, 2 / 1.4142, -1 / 1.4142];
    dyy  = [-1 / 1.4142; 2 / 1.4142; -1 / 1.4142]; 
    dxy  = [-1.4142, 1.4142, 0; 1.4142, -1.4142, 0 ; 0, 0, 0];

    dx  = rot90(dx,2 ); %rot 180 deg, same as flipud(fliplr(dx));    
    dy  = rot90(dy,2 );
    dxx = rot90(dxx,2);
    dyy = rot90(dyy,2);
    dxy = rot90(dxy,2); 
    
    threshold1 = 0.065;
    threshold2 = 0.0325;
    ws(:, :, 1) = calc_ratio(f, dx, threshold1);
    ws(:, :, 2) = calc_ratio(f, dy, threshold1);
    ws(:, :, 3) = calc_ratio(f, dxx, threshold2);
    ws(:, :, 4) = calc_ratio(f, dyy, threshold2);
    ws(:, :, 5) = calc_ratio(f, dxy, threshold2);
    

function ratio = calc_ratio(f, der, threshold)
    numer = conv2(double(f), der, 'same');
    denom = (threshold ./ numer) .^ 4 + 1;
    ratio = numer ./ denom;


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
        ws(:, :, i) = calc_ratio(f, fst_derivs(:, :, i), 0.065);
    end

    threshold = 0.0325;
    for i = 1 : 3
        ws(:, :, i + 2) = calc_ratio(f, snd_derivs(:, :, i), 0.0325);
    end

    %}
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


