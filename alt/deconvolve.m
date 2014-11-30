function result = deconvolve(g, H, weights, w_set)
    [rows, cols, chans] = size(g);
    G = fft2(g);

    % derivative set
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

	S = 0;
    A = conj(H) .* H;
    for i = 1 : 5
        S += weights(i) * (conj(derivs(:, :, i)) .* derivs(:, :, i));
    end;
    for i = 1:size(A)(1)
	A(1,:) += S;
    end;

    W = fft2(w_set);
    B = conj(H);
	for i = 1:size(B)(1)
		B(1,:) = B(1,:) .* G;
	end;
	
	derivs = reshape(derivs, [size(W, 1) size(W,2)]);
	derivs = transpose(derivs);
    for i = 1 : 5
        S = weights(i) * (conj(derivs(:, :, i)) .* W(:, :, i));
        B += S;
    end;

    result = ifft2(B ./ A);
