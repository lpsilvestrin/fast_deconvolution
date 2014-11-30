function small_kernels = getSmallKernel(kernel_type)

if strcmp(kernel_type, 'fergus_27')
    filt = zeros(19); load kernels.mat; filt = kernel1;
    [RF,CF] = size(filt); 
    small_kernel = im2double(filt);   
    
    small_kernel1 = imresize(small_kernel, [27, 27]);
    small_kernel1 = small_kernel1 ./ sum(small_kernel1(:));
    
    small_kernels  = {small_kernel1};
    
elseif strcmp(kernel_type, 'kernel_scale')

    filt = zeros(19); load kernels.mat; filt = kernel1;
    [RF,CF] = size(filt); 
    small_kernel = im2double(filt);   
    
    small_kernel1 = imresize(small_kernel, [13, 13]);
    small_kernel1 = small_kernel1 ./ sum(small_kernel1(:));
    
    small_kernel2 = imresize(small_kernel, [15, 15]);
    small_kernel2 = small_kernel2 ./ sum(small_kernel2(:));
    
    small_kernel3 = imresize(small_kernel, [17, 17]);
    small_kernel3 = small_kernel3 ./ sum(small_kernel3(:));
    
    small_kernel4 = imresize(small_kernel, [19, 19]);
    small_kernel4 = small_kernel4 ./ sum(small_kernel4(:));
    
    small_kernel5 = imresize(small_kernel, [21, 21]);
    small_kernel5 = small_kernel5 ./ sum(small_kernel5(:));
    
    small_kernel6 = imresize(small_kernel, [23, 23]);
    small_kernel6 = small_kernel6 ./ sum(small_kernel6(:));
    
    small_kernel7 = imresize(small_kernel, [27, 27]);
    small_kernel7 = small_kernel7 ./ sum(small_kernel7(:));
    
    small_kernel8 = imresize(small_kernel, [41, 41]);
    small_kernel8 = small_kernel8 ./ sum(small_kernel8(:));
    
    small_kernels  = {small_kernel1, small_kernel2, small_kernel3, small_kernel4, ...
        small_kernel5, small_kernel6, small_kernel7, small_kernel8};
    
elseif  strcmp(kernel_type,'bident')
    L = 4; 
    small_kernel  = zeros(1,2*L+1);
    small_kernel(1,1)   = 1/2; small_kernel(1,end) = 1/2;
    small_kernel = small_kernel ./ sum(small_kernel(:));
    small_kernels  = {small_kernel};
elseif strcmp(kernel_type,'line')
    L = 4; 
    small_kernel  = zeros(1,2*L+1);
    small_kernel(1,1:end)  = 1;
    small_kernel = small_kernel ./ sum(small_kernel(:));
    small_kernels  = {small_kernel};
elseif strcmp(kernel_type,'levin')
    filt = zeros(15);
    load ./levin/demo_inp;
    [RF,CF] = size(filt);
    RCF = floor(RF/2); CCF = floor(CF/2); 
    filt      = fliplr(flipud(filt));
    small_kernel = im2double(filt);   
    small_kernel = small_kernel ./ sum(small_kernel(:));
    small_kernels  = {small_kernel};
elseif strcmp(kernel_type,'fergus1')
    filt = zeros(19); load kernels.mat; filt = kernel1;
    [RF,CF] = size(filt); 
    small_kernel = im2double(filt);   
    small_kernel = small_kernel ./ sum(small_kernel(:));
    small_kernels  = {small_kernel};
elseif strcmp(kernel_type,'fergus13')
    filt = zeros(19); load kernels.mat; filt = kernel1;
    [RF,CF] = size(filt); 
    small_kernel = im2double(filt);   
    small_kernel = imresize(small_kernel, [13,13]);
    small_kernel = small_kernel ./ sum(small_kernel(:));
    small_kernels  = {small_kernel};
elseif strcmp(kernel_type,'fergus2')
    filt = zeros(19); load kernels.mat; filt = kernel2;
    [RF,CF] = size(filt); 
    small_kernel = im2double(filt);   
    small_kernel = small_kernel ./ sum(small_kernel(:));
    small_kernels  = {small_kernel};
else % motion blurr picasso
    small_kernel = im2double(imread('./images/in/picassoOutKernel.bmp'));
    small_kernel = small_kernel(:,:,1);
    small_kernel = small_kernel ./ sum(small_kernel(:));
    small_kernels  = {small_kernel};
end;

