function b1 = get_b1_circ(im_in)

if (exist('mex_deriv') == 3) 
% dx
    w  = mex_deriv(im_in, 0);
    b1 = - mex_deriv(w, 1);

    w  = mex_deriv(im_in, 2);
    b1 = b1 - mex_deriv(w, 3);

% dxx
    w  = mex_deriv(im_in, 4);
    b1 = b1 + mex_deriv(w, 5);

    w  = mex_deriv(im_in, 6);
    b1 = b1 + mex_deriv(w, 7);

% dxy
    w  = mex_deriv(im_in, 8);
    b1 = b1 + mex_deriv(w, 11);
else
 
    dx   = [-0.5, 0, 0.5];
    dy   = [-0.5; 0; 0.5];
    dxx  = [-1 / 1.4142, 2 / 1.4142, -1 / 1.4142];
    dyy  = [-1 / 1.4142; 2 / 1.4142; -1 / 1.4142]; 
    dxy  = [-1.4142, 1.4142, 0; 1.4142, -1.4142, 0 ; 0, 0, 0];
  
    conj_dx  = rot90(dx,2 ); %rot 180 deg, same as flipud(fliplr(dx));    
    conj_dy  = rot90(dy,2 );
    conj_dxx = rot90(dxx,2);
    conj_dyy = rot90(dyy,2);
    conj_dxy = rot90(dxy,2);    

    % use_dx
        w  = imfilter(im_in, dx,'circular');
        w  = sparse(w);
        b1 = imfilter(w, conj_dx,'circular');

        w  = imfilter(im_in, dy,'circular');
        w  = sparse(w);
        b1 = b1 + imfilter(w, conj_dy,'circular');

    % use_dxx
        w  = imfilter(im_in, dxx,'circular');
        w  = sparse(w);
        b1 = b1 + imfilter(w, conj_dxx,'circular');

        w  = imfilter(im_in, dyy,'circular'); 
        w  = sparse(w);
        b1 = b1 + imfilter(w, conj_dyy,'circular');

    % use_dxy
        w  = imfilter(im_in, dxy,'circular');
        w  = sparse(w);
        b1 = b1 + imfilter(w, conj_dxy,'circular');  % b1xy
         
end;

function dw = sparse(x)
lambda = 0.065;
% dw =  x .* ( 1 - (1 ./ (1 + ((x / lambda) .^ 4)) ) );

    xl = lambda ./ x;
    xl = xl .* xl;
    xl = xl .* xl; % = (lambda ./ x) .^ 4
    xl = 1 + xl;
    
    dw =  x ./ xl;

