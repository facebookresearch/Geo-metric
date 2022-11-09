%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2022 Meta Platforms, Inc. and affiliates
%
% This repository contains Matlab code associated with our paper:
% 
% Geo-metric: A Perceptual Dataset of Distortions on Faces
% Krzysztof Wolski, Laura Trutoiu, Zhao Dong, Zhengyang Shen, Kevin MacKenzie, Alexandre Chapiro
% Journal track of SIGGRAPH Asia 2022
%
% Contact:
% Krzysztof Wolski (wolskikrzys@gmail.com)
% Alex Chapiro (alex@chapiro.net) 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%function [M] = compute_comparison_matrix(subset, C)

    N = length(C);
    M = zeros(N,N); 
    for kk=1:length(subset)

        % Find the indexes of both conditions
        c1 = find( strcmp( subset.condition_1(kk), C ), 1 );
        c2 = find( strcmp( subset.condition_2(kk), C ), 1 );

        if( isempty( c1 ) )
            error( 'Cannot find condition %s', subset.condition_1(kk) );
        end
        if( isempty( c2 ) )
            error( 'Cannot find condition %s', subset.condition_2(kk) );
        end

        if( subset.selection(kk) == 0 )
            M(c1,c2) = M(c1,c2) + 1; % c1 better than c2 
        else
            M(c2,c1) = M(c2,c1) + 1; % c2 better than c1
        end
    end
    
end

