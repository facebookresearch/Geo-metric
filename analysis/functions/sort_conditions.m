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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [C] = sort_conditions(C, dst_type)
%Function sorts condition, so the magnitude of the distortion is
%increasing: [reference, level1, level2, level3, level4]
    if( strcmp(dst_type, 'Simp' ))
        C = flip(C,1);
    else
        C = circshift(C,1);
    end
end

