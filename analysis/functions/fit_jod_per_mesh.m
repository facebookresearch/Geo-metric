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

function [JODs] = fit_jod_per_mesh(S)
   
    options = {'regularization', 'fix0'};

    %% finding unique values in dataste
    unique_settings = unique(S.setting); % list of criterions
    unique_distortions = unique(S.dst_type); %list of distortions
    unique_meshes = unique(S.basemesh); %list of meshes

    %% declaring cell array that will store final JOD values
    JODs = {};

    % for each basemesh
    for mesh_num = 1:length( unique_meshes )

        current_mesh = unique_meshes{mesh_num};
        S_mesh = S(strcmp( S.basemesh, current_mesh ), :);

        %% main part
        % for each disotortion type
        for distortion_num = 1:length( unique_distortions )

            current_distortion = unique_distortions{distortion_num};
            S_distortion = S_mesh(strcmp( S_mesh.dst_type, current_distortion ), :);

            C = unique( cat( 1, S_distortion.condition_1, S_distortion.condition_2 ) );
            C = sort_conditions(C, current_distortion);    

            % for each setting
            for setting_num = 1:length( unique_settings )

                current_setting = unique_settings{setting_num};
                S_setting = S_distortion(strcmp( S_distortion.setting, current_setting ), :);

                % prepare data for JOD scaling                
                M = compute_comparison_matrix(S_setting, C);
                % run the perceptual scaling code
                Q = pw_scale( M, options);

                for i = 1: length(C)        
                    JODs_index = size(JODs, 1)+1;                    
                    JODs{JODs_index, 1} = current_mesh; 
                    JODs{JODs_index, 2} = current_distortion;
                    JODs{JODs_index, 3} = current_setting;     
                    JODs{JODs_index, 4} = C{i}; 
                    JODs{JODs_index, 5} = Q(i);        
                end
            end
        end
    end   
    
    % create table to store all JOD values
    T = cell2table(JODs, 'VariableNames',{'basemesh', 'dst_type', 'setting', 'magnitude', 'JOD'});
    JODs = T;
    
end
