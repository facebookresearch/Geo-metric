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

function [C, current_distortion_label] = convert_to_user_friendly_labels(current_distortion)

    C = {'Reference', 'Level 1', 'Level 2', 'Level 3', 'Level 4'};        
    switch current_distortion
        case 'Noise_f0.01'
            current_distortion_label = 'Noise - Lowest Frequency';
        case 'Noise_f0.06'
            current_distortion_label = 'Noise - Low Frequency';
        case 'Noise_f0.34'
            current_distortion_label = 'Noise - High Frequency';            
        case 'Noise_f2.00'
            current_distortion_label = 'Noise - Highest Frequency';
        case 'Simp'
            current_distortion_label = 'Simplification';
        case 'Smooth'
            current_distortion_label = 'Smoothing';                
    end

end

