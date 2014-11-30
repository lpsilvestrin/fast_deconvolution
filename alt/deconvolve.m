function result = deconvolve(G, H, weights, w_set)
    [rows, cols, chans] = size(G);

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
<<<<<<< HEAD

	S = 0;
    A = conj(H) .* H;
    for i = 1 : 5
        S += weights(i) * (conj(derivs(:, :, i)) .* derivs(:, :, i));
    end;
    for i = 1:size(A)(1)
	A(1,:) += S;
=======
    %}

    A = conj(H) .* H;
    for i = 1 : 5
%        S = weights(i) * (conj(derivs(:, :, i)) .* derivs); %derivs(:, :, i));
        S = weights(i) .* derivs; %derivs(:, :, i));
        A += S;
>>>>>>> e63eb4954d924cc4fd9b9e06d689b7ab95734d6d
    end;

    W = fft2(w_set);
    B = conj(H);
	for i = 1:size(B)(1)
		B(1,:) = B(1,:) .* G;
	end;
	
	derivs = reshape(derivs, [size(W, 1) size(W,2)]);
	derivs = transpose(derivs);
    for i = 1 : 5
%        S = weights(i) * (conj(derivs(:, :, i)) .* W(:, :, i));
        b1 = get_b1(result);
        S = weights(i) .*  fft2(b1);
        B += S;
    end;

    result = ifft2(B ./ A);
