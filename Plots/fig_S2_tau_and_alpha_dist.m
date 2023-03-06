
load('C:\data_path\Likelihood_batchjobs\best_model_subjs.mat');

load('C:\data_path\Likelihood_batchjobs\Max_likelihoods.mat','parameter_tau_mat','parameter_alpha_vec');

DRP_best_tau_DRP_FOP_BP_QL = NaN(sum(best_model_subjs <= 2), 4);
FOP_best_tau_FOP_BP_QL = NaN(sum(best_model_subjs == 3), 3);
BP_best_tau_FOP_BP_QL = NaN(sum(best_model_subjs == 4), 3);

DRP_best_alpha_QL = NaN(sum(best_model_subjs <= 2), 1);
FOP_best_alpha_QL = NaN(sum(best_model_subjs == 3), 1);
BP_best_alpha_QL = NaN(sum(best_model_subjs == 4), 1);

DRP_best_count = 0;
FOP_best_count = 0;
BP_best_count = 0;

for subj = 1:85
    
    switch best_model_subjs(subj,1)
        
        case 1   % dfkl
            
            DRP_best_count = DRP_best_count + 1;
            
            DRP_best_tau_DRP_FOP_BP_QL(DRP_best_count,:) = parameter_tau_mat(subj, [21, 25, 26, 27]);
            
            DRP_best_alpha_QL(DRP_best_count,1) = parameter_alpha_vec(subj,1);
            
        case 2   % lkfd
            
            DRP_best_count = DRP_best_count + 1;
            
            DRP_best_tau_DRP_FOP_BP_QL(DRP_best_count,:) = parameter_tau_mat(subj, [1, 25, 26, 27]);
            
            DRP_best_alpha_QL(DRP_best_count,1) = parameter_alpha_vec(subj,1);
            
        case 3
            
            FOP_best_count = FOP_best_count + 1;
            
            FOP_best_tau_FOP_BP_QL(FOP_best_count,:) = parameter_tau_mat(subj, [25, 26, 27]);
            
            FOP_best_alpha_QL(FOP_best_count,1) = parameter_alpha_vec(subj,1);
            
        case 4
            
            BP_best_count = BP_best_count + 1;
            
            BP_best_tau_FOP_BP_QL(BP_best_count,:) = parameter_tau_mat(subj, [25, 26, 27]);
            
            BP_best_alpha_QL(BP_best_count,1) = parameter_alpha_vec(subj,1);
            
    end    
    
end


tau_tick_vec = 1:10:31;
tau_ticklabel_vec = [0, 1./(6:-0.2:0.2)];
tau_ticklabel_vec = tau_ticklabel_vec(tau_tick_vec);

tau_hist_vec = (1:31);

alpha_tick_vec = 5:5:20;
alpha_ticklabel_vec = 0.05:0.05:1;
alpha_ticklabel_vec = alpha_ticklabel_vec(alpha_tick_vec);

alpha_hist_vec = (1:20);

subplot_index_vec = [1, NaN, NaN, 2, 1, 1, 3, 2, 2, 4, 3, 3]';

figure('rend','painters','pos',[10 10 700 900])

for sub_ind = 1:15
    
    if sub_ind <= 12
        
        xlabel_str = '\tau';
            
        xtick_vec = tau_tick_vec;

        xticklabel_vec = tau_ticklabel_vec;
        
        hist_vec = tau_hist_vec;
        
    else
        
        xlabel_str = '\alpha';
        
        xtick_vec = alpha_tick_vec;

        xticklabel_vec = alpha_ticklabel_vec;
        
        hist_vec = alpha_hist_vec;
        
    end
    
    if mod(sub_ind,3) == 1
        
        title_str = 'DRP best';
        
        if sub_ind <= 12
            
            data_temp = DRP_best_tau_DRP_FOP_BP_QL(:, subplot_index_vec(sub_ind,1));        
            
        else
            
            data_temp = DRP_best_alpha_QL;
            
        end
        
        y_lim_value = 12;
        
    elseif mod(sub_ind,3) == 2       
        
        if sub_ind >= 4
            
            title_str = 'FOP best';            
        
            if sub_ind <= 12

                data_temp = FOP_best_tau_FOP_BP_QL(:, subplot_index_vec(sub_ind,1));        

            else

                data_temp = FOP_best_alpha_QL;

            end
        
        end
        
        y_lim_value = 8;
        
    elseif mod(sub_ind,3) == 0
        
        if sub_ind >= 4
        
            title_str = 'BP best';

            if sub_ind <= 12

                data_temp = BP_best_tau_FOP_BP_QL(:, subplot_index_vec(sub_ind,1));        

            else

                data_temp = BP_best_alpha_QL;

            end
        
        end
        
        y_lim_value = 8;
        
    end
    
    if sub_ind ~= 2 && sub_ind ~= 3
        
        subplot(5, 3, sub_ind);
        hist(data_temp, hist_vec);
        ylim([0 y_lim_value]);
        %title(title_str);
        xlabel(xlabel_str);
        set(gca, 'Xtick', xtick_vec);
        set(gca,'XTickLabel',sprintf('%.1f|',xticklabel_vec))
    
    end
    
end

set(gcf,'PaperPositionMode','auto')
print(gcf, '-r500', '-dtiffn', 'fig_S2_raw_matlab_out.tiff'); 

