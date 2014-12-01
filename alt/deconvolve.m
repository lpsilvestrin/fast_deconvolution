function result = deconvolve(g, H, weights, w_set)
    [rows, cols, chans] = size(g);

    G = fft2(g);
    result = zeros(rows, cols);
    % derivative set
    derivs = getA1(rows, cols);
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
        S = weights(i) .* (conj(derivs) .* derivs); %derivs(:, :, i));
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
        S = weights(i) .* (conj(derivs) .* W(:, :, i));
%        b1 = get_b1(w_set(:, :, i));
%        W = fft2(b1);
%        S = weights(i) .*  fft2(b1);
        B += S;
    end;
    result = ifft2(B ./ A);
