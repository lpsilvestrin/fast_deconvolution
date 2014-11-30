function result = expand_kernel(k, rows, cols, i, j)
    k_dim = size(k);

    result = zeros(rows, cols);
    result(i : (i + k_dim(1) - 1), j : (j + k_dim(2) - 1)) = k (:, :);
    result = reshape(transpose(result), 1, rows * cols);
