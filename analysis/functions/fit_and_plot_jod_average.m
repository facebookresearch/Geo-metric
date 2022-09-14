function [JODs] = fit_and_plot_jod_average(S, bootstrap_samples, use_user_firendly_labels)

    results_directory = 'results';
    plots_directory = fullfile(results_directory, 'plots');

    mkdir(results_directory)
    mkdir(plots_directory)

    markers = {'-s','-v','-*','-d','v','d','^','s','>','<'};
    yLimVals = [-4,0.5];

    %% finding unique values in dataste
    unique_settings = unique(S.setting); % list of criterions
    unique_distortions = unique(S.dst_type); %list of distortions
    unique_observers = unique(S.observer); %list of observers

    %% declaring cell array that will store final JOD values
    JODs = {};

    %% main part
    % for each disotortion type
    for distortion_num = 1:length( unique_distortions )

        current_distortion = unique_distortions{distortion_num};
        S_distortion = S(strcmp( S.dst_type, current_distortion ), :);

        C = unique( cat( 1, S_distortion.condition_1, S_distortion.condition_2 ) );
        C = sort_conditions(C, current_distortion);    

        N = length(C);    
        x_axis_indices = 1:N;

        f = figure;
        hold on;

        % for each setting
        for setting_num = 1:length( unique_settings )

            current_setting = unique_settings{setting_num};
            S_setting = S_distortion(strcmp( S_distortion.setting, current_setting ), :);

            % prepare data for JOD scaling
            MM = zeros(length(unique_observers), N*N);
            for observer_num=1:length(unique_observers)        
                S_observer =  S_setting( S_setting.observer == unique_observers(observer_num) , :);            
                M = compute_comparison_matrix(S_observer, C);            
                MM(observer_num,:) = M(:)';        
            end

            % JOD scaling
            [jod, stats] = pw_scale_bootstrp( MM, bootstrap_samples, { 'regularization', 'fix0' } );

            error_bars = zeros(N, 2);
            error_bars(:,1) = jod'-stats.jod_low';
            error_bars(:,2) = stats.jod_high'-jod';

            yneg = error_bars(:,1)';
            ypos = error_bars(:,2)';

            current_setting = strrep(current_setting,'_','-');
            errorbar(x_axis_indices, jod,yneg,ypos,markers{setting_num}, 'DisplayName',current_setting, 'LineWidth',1);

            for i = 1: length(jod)        
                JODs_index = size(JODs, 1)+1;
                JODs{JODs_index, 1} = current_distortion;
                JODs{JODs_index, 2} = current_setting;     
                JODs{JODs_index, 3} = C{i}; 
                JODs{JODs_index, 4} = jod(i);        
            end
        end

        % prepare labels
        if(use_user_firendly_labels)
            [C, current_distortion_label] = convert_to_user_friendly_labels(current_distortion);
        else
            current_distortion_label = strrep(current_distortion,'_',' - ');        
            for i = 1:length(C)
                C{i} = strrep(C{i},[current_distortion, '_'],''); 
            end           
        end    

        % modify figure
        xlabel('Artifact magnitude'); ylabel('JOD scale'); title(['Distortion: ', current_distortion_label]);
        set(gca,'xtick',x_axis_indices,'xticklabel',C)   
        legend('Location','southwest')
        grid on
        ylim(yLimVals)

        % save figures
        saveas(gcf,[plots_directory, '/', current_distortion, '.png'])
        saveas(gcf,[plots_directory, '/', current_distortion, '.pdf'])
    end

    % conveerting JODs cell array to table
    variable_names = {'dst_type', 'setting' 'magnitude', 'JOD'};
    JODs = cell2table(JODs, 'VariableNames', variable_names);
    
end

