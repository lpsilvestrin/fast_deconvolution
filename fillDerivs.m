% Generate matrix containing all needed derivatives from the image
function derivs = fillDerivs(DX, DY, rows, cols)
    derivs = zeros(rows, cols, 5);
    derivs(:, :, 1) = DX;
    derivs(:, :, 2) = DY;            % dy
    derivs(:, :, 3) = DX .* DX; % dxx
    derivs(:, :, 4) = DY .* DY; % dyy
    derivs(:, :, 5) = DX .* DY; % dxy

%{
    derivs(:, :, 1) = fft2(double(dx), rows, cols);            % dx
    derivs(:, :, 2) = fft2(double(dy), rows, cols);            % dy
    derivs(:, :, 3) = fft2(double(conv2(dx, dx)), rows, cols); % dxx
    derivs(:, :, 4) = fft2(double(conv2(dy, dy)), rows, cols); % dyy
    derivs(:, :, 5) = fft2(double(conv2(dx, dy)), rows, cols); % dxy
}%

