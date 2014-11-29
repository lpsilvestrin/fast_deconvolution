% Generate matrix containing all needed derivatives from the image
function derivs = fillDerivs(dx, dy)
    [rows, cols] = size(dx); %assuming same size for both dx and dy
    derivs = zeros(rows, cols, 5);
    derivs(:, :, 1) = fft2(double(dx), rows, cols);            % dx
    derivs(:, :, 2) = fft2(double(dy), rows, cols);            % dy
    derivs(:, :, 3) = fft2(double(conv2(dx, dx)), rows, cols); % dxx
    derivs(:, :, 4) = fft2(double(conv2(dy, dy)), rows, cols); % dyy
    derivs(:, :, 5) = fft2(double(conv2(dx, dy)), rows, cols); % dxy

