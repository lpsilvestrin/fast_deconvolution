function result = deconvolve(g, H, weights, w_set)
    [rows, cols, chans] = size(g);

    G = fft2(g);
    result = zeros(rows, cols);
    % derivative set
%    derivs = getA1(rows, cols);

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
    
    conj_dx  = rot90(dx,2 ); %rot 180 deg, same as flipud(fliplr(dx));    
    conj_dy  = rot90(dy,2 );
    conj_dxx = rot90(dxx,2);
    conj_dyy = rot90(dyy,2);
    conj_dxy = rot90(dxy,2);    
    derivs = zeros(rows, cols, 5);

    DX = fft2(dx, rows, cols);
    DY = fft2(dy, rows, cols);
    DXX = fft2(dxx, rows, cols);
    DYY = fft2(dyy, rows, cols);
    DXY = fft2(dxy, rows, cols);
    derivs(:, :, 1) = DX;
    derivs(:, :, 2) = DY;            % dy
    derivs(:, :, 3) = DXX; % dxx
    derivs(:, :, 4) = DYY; % dyy
    derivs(:, :, 5) = DXY; % dxy

    %{
    dy = fspecial('sobel');
    dx = transpose(dy);
    DX = fft2(dx, rows, cols);
    DY = fft2(dy, rows, cols);
    derivs = zeros(rows, cols, 5);
    derivs(:, :, 1) = DX;
    derivs(:, :, 2) = DY;            % dy
    derivs(:, :, 3) = DX .* DX; % dxx
    derivs(:, :, 4) = DY .* DY; % dyy
    derivs(:, :, 5) = DX .* DY; % dxy
    %}

    A = conj(H) .* H;
    for i = 1 : 5
        S = weights(i) .* (conj(derivs(:, :, i)) .* derivs(:, :, i));
%        S = weights(i) .* (conj(derivs) .* derivs); %derivs(:, :, i));
        A += S;
    end;

    W = zeros(rows, cols, 5);
%    disp(size(w_set));
%j    for i = 1 : 5
 %       W(:, :, i) = fft2(w_set(:, :, i), rows, cols);
 %   endfor;
    W = fft2(w_set);


    B = conj(H) .* G;
    for i = 1 : 5
        S = weights(i) .* (conj(derivs(:, :, i)) .* W(:, :, i));
%        b1 = get_b1(w_set(:, :, i));
%        W = fft2(b1);
%        S = weights(i) .*  fft2(b1);
        B += S;
    end;
    result = ifft2(B ./ A);
