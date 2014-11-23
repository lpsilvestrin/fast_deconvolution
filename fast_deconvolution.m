function img = fast_deconvolution(image, kernel, weights)
img = padding(image,10);

function padded = padding(img, n)
padded = padarray(img, [n n], 'replicate');
[R, C] = size(img);
[m, n] = size(padded);
R = double(R);
C = double(C);
rc = round(m/2);
cc = round(n/2);
alpha = 0.01;
nr = ceil(0.5*log2((1-alpha)/alpha)/log2(rc/(R/2)));
nc = ceil(0.5*log2((1-alpha)/alpha)/log2(cc/(C/2)));
mask = zeros(m,n);
for i=1:m
    for j=1:n
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
padded = padded.*uint8(abs(mask));
% padded = uint8(abs(mask));
padded = mask;