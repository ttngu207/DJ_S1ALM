function mode_orthogonal = fn_orthogonalize(mode1, mode2)
    
    nanix = isnan(mode1);
    
    mode1(isnan(mode1)) = 0;
    mode2(isnan(mode2)) = 0;
    mode1 = mode1 - (dot(mode1, mode2)./dot(mode2, mode2)).*mode2;
    mode1(nanix) = NaN;
    mode_orthogonal=mode1;
