function res = comp_reg_terms(f)
 
    dx   = [-0.5, 0, 0.5];
    dy   = [-0.5; 0; 0.5];
    dxx  = [-1 / 1.4142, 2 / 1.4142, -1 / 1.4142];
    dyy  = [-1 / 1.4142; 2 / 1.4142; -1 / 1.4142]; 
    dxy  = [-1.4142, 1.4142, 0; 1.4142, -1.4142, 0 ; 0, 0, 0];

    dx  = rot90(dx,2 ); %rot 180 deg, same as flipud(fliplr(dx));    
    dy  = rot90(dy,2 );
    dxx = rot90(dxx,2);
    dyy = rot90(dyy,2);
    dxy = rot90(dxy,2); 
    
    conj_dx  = rot90(dx,2 ); %rot 180 deg, same as flipud(fliplr(dx));    
    conj_dy  = rot90(dy,2 );
    conj_dxx = rot90(dxx,2);
    conj_dyy = rot90(dyy,2);
    conj_dxy = rot90(dxy,2);    

    % use_dx
    threshold = 0.065;
    
    w  = conv2(f, dx, 'same');       
    w  = comp_priors(w, threshold);
    res = conv2(w, conj_dx, 'same');

    w  = conv2(f, dy, 'same');
    w  = comp_priors(w, threshold);
    res = res + conv2(w, conj_dy, 'same');

    % use_dxx
    threshold = 0.5 * threshold;
    
    w  = conv2(f, dxx, 'same');
    w  = comp_priors(w, threshold);
    res = res + conv2(w, conj_dxx, 'same');

    w  = conv2(f, dyy, 'same');
    w  = comp_priors(w, threshold);
    res = res + conv2(w, conj_dyy, 'same');

    % use_dxy
    w  = conv2(f, dxy, 'same');
    w  = comp_priors(w, threshold);
    res = res + conv2(w, conj_dxy, 'same');
        

function reg_prior = comp_priors(x, threshold)
    
    xl = threshold ./ x;
    xl = xl .* xl;
    xl = xl .* xl; % = (threshold ./ x) .^ 4
    xl = 1 + xl;
    reg_prior =  x ./ xl;

    
