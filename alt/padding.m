function padded, mask = padding(I, n)
% recebe uma imagem I e o número n de vezes que as linhas serão repetidas em cada lado
alpha = 0.01;
padded = padarray(I, [n, n],'replicate','both');
[padded_rows, padded_cols, ch] = size(padded);
mask = zeros(padded_rows, padded_cols);
[R C ch] = size(I);
rc = 1 + floor(padded_rows/2);
cc = 1 + floor(padded_cols/2);
log_alpha = log10((1-alpha)/alpha);
nr = ceil(0.5*log_alpha/log10(rc/(R/2)));
nc = ceil(0.5*log_alpha/log10(cc/(C/2)));	
for i=1:padded_rows
    for j=1:padded_cols
        term1 = (abs(i-rc) / (R/2))^(2*nr);
        term2 = (abs(j-cc) / (C/2))^(2*nc);
        mask(i,j) = 1/((1+term1) * (1+term2));
    end
end
for i = 1:ch
	padded(:,:,i) = padded(:,:,i) .* mask;
end;
