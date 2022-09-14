function [coeffs] = compute_correlation_coefficients(D, JODs_per_mesh)
    
    %% merging metric data and JODs per head
    SS = cell(1,4);    
    % for each unique setting
    unique_settings = unique(JODs_per_mesh.setting); % list of criterions    
    for setting_num = 1:length( unique_settings )
        current_setting = unique_settings{setting_num};
        S = JODs_per_mesh(strcmp( JODs_per_mesh.setting, current_setting ), :);
        S.METRO = D.METRO;
        S.FMPD = D.FMPD;
        S.DAME = D.DAME;
        S.MSDM = D.MSDM;
        S.MSDM2 = D.MSDM2;
        S.RMS = D.RMS;
        SS{setting_num} = S;
    end
    
    % merge of all four settings
    S = [SS{1}; SS{2}; SS{3}; SS{4}];
    writetable(S,'results/JODPerMesh.csv')    
    
    %% preapring parameters for correlation coefficients computation
    % finding all possible distortion types
    unique_dst_types = unique(S.dst_type);
    unique_dst_types{length(unique_dst_types)+1} = 'noSimp';
    unique_dst_types{length(unique_dst_types)+1} = 'allTypes';

    % finding all possible layout settings
    unique_settings = unique(JODs_per_mesh.setting);
    unique_settings{length(unique_settings)+1} = 'allSettings';
    
    % creating empty table to save all correlation coefficients
    variable_names = {'Condition', 'Dst_type' 'Metric', 'Pearson', 'Kendall', 'Spearman'};
    coeffs = cell2table(cell(0,length(variable_names)), 'VariableNames', variable_names);
    
    % fetching input table variable names and setting indices for metrics
    column_names = S.Properties.VariableNames;
    metrics_indices = 6:11;
    
    %% computing correlation coefficients
    % for every setting
    for setting_num = 1 : length(unique_settings)

        setting = unique_settings{setting_num};
        dataset_setting = S;

        % selecting records for a given setting
        if(~strcmp( setting, 'allSettings' ))
            dataset_setting = dataset_setting(strcmp( dataset_setting.setting, setting ), :);
        end

        % for every distortion type
        for dst_type_num = 1 : length(unique_dst_types)

            dst_type = unique_dst_types{dst_type_num};
            dataset_type = dataset_setting;

            % selecting records for a given distortion type
            if(strcmp( dst_type, 'noSimp' ))
                dataset_type = dataset_type(~strcmp( dataset_type.dst_type, 'Simp' ), :);
            elseif(~strcmp( dst_type, 'allTypes' ))
                dataset_type = dataset_type(strcmp( dataset_type.dst_type, dst_type ), :);
            end

            % compute correlation coefficeint for every metric
            for metric_num = metrics_indices
                metric_name = column_names{metric_num};

                results_set = dataset_type;    
                if( strcmp(metric_name, 'DAME') || strcmp(metric_name, 'MSDM') )
                    results_set = results_set(~strcmp( results_set.dst_type, 'Simp' ), :);
                    % remove all records if metric is DAME or MSDM and type
                    % is AllTypes, to prevent unfair comparisons.
                    if(strcmp(dst_type, 'allTypes'))
                        results_set(:,:) = [];
                    end
                end

                JODs = results_set.JOD;
                metric_response = table2array(results_set(:, metric_num));

                if(isempty(metric_response))
                    R_pearson = nan;
                    R_Kendall = nan;
                    R_Spearman = nan;
                else
                    R_pearson = corr(JODs, metric_response);
                    R_Kendall = corr(JODs, metric_response, 'Type','Kendall');
                    R_Spearman = corr(JODs, metric_response, 'Type','Spearman');
                end
                
                record = {setting, dst_type, metric_name, R_pearson, R_Kendall, R_Spearman};
                coeffs = [coeffs; record];
            end
        end
    end

end

