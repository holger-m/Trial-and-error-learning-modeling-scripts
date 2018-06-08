
load('C:\data_path\Human_data.mat');

accuracy_3D_humans = NaN(70,15,85);

accuracy_initial_3D_humans = NaN(70,15,85);

for subj = 1:85
    
   for block = 6:20
       
       current_stim_vec = stim_3D(:, block, subj); 
        
       block_length = sum(~isnan(current_stim_vec));       
        
       current_stim_vec = current_stim_vec(1:block_length);        
        
       current_resp_actu_vec = response_actual_3D(1:block_length, block, subj);
        
       current_resp_corr_vec = response_correct_3D(1:block_length, block, subj);
       
       current_resp_subj_corr_vec = current_resp_actu_vec == current_resp_corr_vec;
       
       first_correct_stimwise = NaN(4,1);
        
        for stim = 1:4
            
            stim_accu_vec = current_resp_subj_corr_vec & current_stim_vec == stim;
            
            if all(~stim_accu_vec)
                
                error('Stimulus never correct!');
                
            end
            
            [~,first_corr_stim] = max(stim_accu_vec);
            
            first_correct_stimwise(stim,1) = first_corr_stim;
            
        end
        
        latest_stim_corr = max(first_correct_stimwise);
        
        accuracy_3D_humans(1:block_length, block - 5, subj) = current_resp_subj_corr_vec;
        
        accuracy_initial_3D_humans(1:latest_stim_corr, block - 5, subj) = current_resp_subj_corr_vec(1:latest_stim_corr);
       
   end
    
end




all_perms = perms((1:4));

accuracy_3D_models = NaN(70,15,85,5);

accuracy_initial_3D_models = NaN(70,15,85,5);


model_count = 0;

for model_no = [1, 21, 25, 26, 27]
    
    model_count = model_count + 1;
    
    if model_no <= 24
    
        model_str = strcat(num2str(all_perms(model_no,1)), ...
                           num2str(all_perms(model_no,2)), ...
                           num2str(all_perms(model_no,3)), ...
                           num2str(all_perms(model_no,4)));

    elseif model_no == 25

        model_str = 'FOP';

    elseif model_no == 26

        model_str = 'BP';

    elseif model_no == 27

        model_str = 'QL';

    end   
    
    
    for subj = 1:85
        
        disp(' ');
        disp(['Processing model ',model_str,', subj no. ',num2str(subj,'%02.0f')]);
        
        load(['C:\data_path\Generate_responses\',model_str,'\',model_str,'_',num2str(subj,'%02.0f'),'.mat']);
        
        for block = 6:20
            
            current_stim_vec = stim_3D(:, block, subj); 
        
            block_length = sum(~isnan(current_stim_vec));       

            current_stim_vec = current_stim_vec(1:block_length);        

            current_resp_actu_vec = responses_sims_blocks(1:block_length, :, block - 5);

            current_resp_corr_vec = repmat(response_correct_3D(1:block_length, block, subj),1,1000);

            current_resp_subj_corr_vec = current_resp_actu_vec == current_resp_corr_vec;
            
            latest_stim_corr_all_sims = NaN(1,1000);
            
            for sim_no = 1:1000

                first_correct_stimwise = NaN(4,1);

                for stim = 1:4

                    stim_accu_vec = current_resp_subj_corr_vec(:,sim_no) & current_stim_vec == stim;

                    if all(~stim_accu_vec)                        
                        
                        first_corr_stim = block_length;

                    else

                        [~,first_corr_stim] = max(stim_accu_vec);
                        
                    end

                    first_correct_stimwise(stim,1) = first_corr_stim;

                end

                latest_stim_corr = max(first_correct_stimwise);
                
                latest_stim_corr_all_sims(1,sim_no) = latest_stim_corr;

            end
            
            
            current_initial_resp_subj_corr_vec = NaN(size(current_resp_subj_corr_vec,1), 1000);
            
            for sim_no = 1:1000
                
                current_initial_resp_subj_corr_vec(1:latest_stim_corr_all_sims(1,sim_no),sim_no) = current_resp_subj_corr_vec(1:latest_stim_corr_all_sims(1,sim_no),sim_no);
                
            end
            
            accuracy_3D_models(1:block_length, block - 5, subj, model_count) = mean(current_resp_subj_corr_vec,2);
            
            accuracy_initial_3D_models(1:block_length, block - 5, subj, model_count) = nanmean(current_initial_resp_subj_corr_vec,2);
            
        end
        
    end
    
end



load('C:\data_path\Likelihood_batchjobs\best_model_subjs.mat');

Learning_curves_DRP = NaN(32,5,sum(best_model_subjs <= 2));
Learning_curves_initial_DRP = NaN(32,5,sum(best_model_subjs <= 2));

Learning_curves_FOP = NaN(32,4,sum(best_model_subjs == 3));
Learning_curves_initial_FOP = NaN(32,4,sum(best_model_subjs == 3));

Learning_curves_BP = NaN(32,4,sum(best_model_subjs == 4));
Learning_curves_initial_BP = NaN(32,4,sum(best_model_subjs == 4));

DRP_count = 0;
FOP_count = 0;
BP_count = 0;

for subj = 1:85
    
    subj_human_blockmean_32 = mean(accuracy_3D_humans(1:32,:,subj),2);
    
    subj_initial_human_blockmean_32 = nanmean(accuracy_initial_3D_humans(1:32,:,subj),2);
    
    subj_models_blockmean_32 = squeeze(mean(accuracy_3D_models(1:32,:,subj,:),2));
    
    subj_initial_models_blockmean_32 = squeeze(mean(accuracy_initial_3D_models(1:32,:,subj,:),2));
    
    if best_model_subjs(subj,1) == 1  % dfkl
        
        DRP_count = DRP_count + 1;
        
        Learning_curves_DRP(:,:,DRP_count) = [subj_human_blockmean_32, subj_models_blockmean_32(:,[2,3,4,5])];
        
        Learning_curves_initial_DRP(:,:,DRP_count) = [subj_initial_human_blockmean_32, subj_initial_models_blockmean_32(:,[2,3,4,5])];
        
    elseif best_model_subjs(subj,1) == 2  % lkfd
        
        DRP_count = DRP_count + 1;
        
        Learning_curves_DRP(:,:,DRP_count) = [subj_human_blockmean_32, subj_models_blockmean_32(:,[1,3,4,5])];
        
        Learning_curves_initial_DRP(:,:,DRP_count) = [subj_initial_human_blockmean_32, subj_initial_models_blockmean_32(:,[1,3,4,5])];
        
    elseif best_model_subjs(subj,1) == 3  % FOP
        
        FOP_count = FOP_count + 1;
        
        Learning_curves_FOP(:,:,FOP_count) = [subj_human_blockmean_32, subj_models_blockmean_32(:,[3,4,5])];
        
        Learning_curves_initial_FOP(:,:,FOP_count) = [subj_initial_human_blockmean_32, subj_initial_models_blockmean_32(:,[3,4,5])];
        
    elseif best_model_subjs(subj,1) == 4  % BP
        
        BP_count = BP_count + 1;
        
        Learning_curves_BP(:,:,BP_count) = [subj_human_blockmean_32, subj_models_blockmean_32(:,[3,4,5])];
        
        Learning_curves_initial_BP(:,:,BP_count) = [subj_initial_human_blockmean_32, subj_initial_models_blockmean_32(:,[3,4,5])];
        
    end
    
end


mean_Learning_curves_DRP = mean(Learning_curves_DRP,3);
SEM_Learning_curves_DRP = std(Learning_curves_DRP,0,3)/sqrt(size(Learning_curves_DRP,3));

mean_Learning_curves_initial_DRP = nanmean(Learning_curves_initial_DRP,3);
SEM_Learning_curves_initial_DRP = nanstd(Learning_curves_initial_DRP,0,3)./sqrt(sum(~isnan(Learning_curves_initial_DRP),3));

mean_Learning_curves_FOP = mean(Learning_curves_FOP,3);
SEM_Learning_curves_FOP = std(Learning_curves_FOP,0,3)/sqrt(size(Learning_curves_FOP,3));

mean_Learning_curves_initial_FOP = nanmean(Learning_curves_initial_FOP,3);
SEM_Learning_curves_initial_FOP = nanstd(Learning_curves_initial_FOP,0,3)./sqrt(sum(~isnan(Learning_curves_initial_FOP),3));

mean_Learning_curves_BP = mean(Learning_curves_BP,3);
SEM_Learning_curves_BP = std(Learning_curves_BP,0,3)/sqrt(size(Learning_curves_BP,3));

mean_Learning_curves_initial_BP = nanmean(Learning_curves_initial_BP,3);
SEM_Learning_curves_initial_BP = nanstd(Learning_curves_initial_BP,0,3)./sqrt(sum(~isnan(Learning_curves_initial_BP),3));


