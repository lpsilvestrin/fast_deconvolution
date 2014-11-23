function img = fast_deconvolution(image, kernel, weights)


function padded = padding(img, n)
% Add n lines and cols under, above and in the sides of the image. 
% n = 2*max(kernel_cols, kernel_rows)
padded = padarray(img, [n, n], 'replicate');
