function mask = generate_mask(unpadded_rows, unpadded_cols, padded_rows, padded_cols, alpha)
mask = zeros(padded_rows, padded_cols);
R = unpadded_rows;
C = unpadded_cols;
rc = padded_rows/2;
cc = padded_cols/2;
log_alpha = log10((1-alpha)/alpha);
nr = ceil(0.5*log_alpha/log10(rc/(R/2)));
nc = ceil(0.5*log_alpha/log10(cc/(C/2)));
for i=1:padded_rows
    for j=1:padded_cols
        p1 = i-rc;
        p2 = R/2;
        p3 = p1/p2;
        p4 = 1 + p3*(2*nr);
        p5 = j-cc;
        p6 = C/2;
        p7 = p5/p6;
        p8 = 1 + p7*(2*nc);
        mask(i,j) = 1/(p4*p8);
    end
end
