function [C] = sort_conditions(C, dst_type)
%Function sorts condition, so the magnitude of the distortion is
%increasing: [reference, level1, level2, level3, level4]
    if( strcmp(dst_type, 'Simp' ))
        C = flip(C,1);
    else
        C = circshift(C,1);
    end
end

