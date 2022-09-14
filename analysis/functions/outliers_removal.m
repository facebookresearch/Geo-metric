function S = outliers_removal(S)

    unique_settings = unique(S.setting); % list of settings
    unique_distortions = unique(S.dst_type); %list of distortions
    unique_observers = unique(S.observer); %list of observers

    MMs = {};

    index = 0;
    for distortion_num = 1:length( unique_distortions )

        current_distortion = unique_distortions{distortion_num};
        S_distortion = S(strcmp( S.dst_type, current_distortion ), :);
        
        % Find all unique conditions and set reference as first one
        C = unique( cat( 1, S_distortion.condition_1, S_distortion.condition_2 ) ); % all conditions
        C = sort_conditions(C, current_distortion);
        
        % Get dimension of the comparison matrix
        N = length(C);
        
        for setting_num = 1:length( unique_settings )

            index = index + 1;

            current_setting = unique_settings{setting_num};
            S_setting = S_distortion(strcmp( S_distortion.setting, current_setting ), :);

            MM = zeros(length(unique_observers), N*N);        

            for observer_num = 1:length(unique_observers)
                S_observer = S_setting( S_setting.observer == unique_observers(observer_num), :);
                M = compute_comparison_matrix(S_observer, C);
                MM(observer_num,:) = M(:)';
            end

            MMs{index} = MM;

        end
    end

    % Any observer with a dist_L > 1.5 can be considered an outlier
    [L,dist_L] = pw_outlier_analysis( MMs );
    outliers = unique_observers(dist_L > 1.5);
    
    for i = 1:length(outliers)
       index = outliers(i);
       S = S( S.observer ~= index, :);
    end
end