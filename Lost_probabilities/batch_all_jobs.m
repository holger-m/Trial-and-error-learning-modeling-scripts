function [] = batch_all_jobs(model_no)


all_perms = perms((1:4));

if model_no == 0
    
    model_str = 'humans';  
    
elseif model_no <= 24
    
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


    
load('C:\data_path\Human_data.mat');
    
if model_no >= 1
    
    responses_sims_all_subjs = NaN(70,1000,15,85);
    
    for subj = 1:85
        
        clear responses_sims_blocks
        
        load(['C:\data_path\Generate_responses\',model_str,'\',model_str,'_',num2str(subj,'%02.0f'),'.mat']);
        
        responses_sims_all_subjs(:,:,:,subj) = responses_sims_blocks;
            
    end
    
end




if model_no == 0
    
    Lost_probs = NaN(70,15,85);
    
    Resp_probs = NaN(70,15,85);

else
    
    Lost_probs = NaN(70,1000,15,85);
    
    Resp_probs = NaN(70,1000,15,85);
    
end


for subj = 1:85
    
    disp(' ');
    disp(['Processing model ',model_str,', subj no. ',num2str(subj,'%02.0f')]);
    
    for block = 6:20        
        
        current_stim_vec = stim_3D(:, block, subj); %#ok<NODEF>

        block_length = sum(~isnan(current_stim_vec));

        current_stim_vec = current_stim_vec(1:block_length);        
  
        current_resp_corr_vec = response_correct_3D(1:block_length, block, subj);
                    
        if model_no == 0
            
            current_resp_actu_vec = response_actual_3D(1:block_length, block, subj);

            [lost_prob_vec, resp_prob_vec] = run_block_probs(current_stim_vec, current_resp_actu_vec, current_resp_corr_vec);

            Lost_probs(1:block_length, block - 5, subj) = lost_prob_vec;
            
            Resp_probs(1:block_length, block - 5, subj) = resp_prob_vec;
        
        else
            
            for sim_no = 1:1000
                
                current_resp_actu_vec = responses_sims_all_subjs(1:block_length, sim_no, block - 5, subj);
                
                [lost_prob_vec, resp_prob_vec] = run_block_probs(current_stim_vec, current_resp_actu_vec, current_resp_corr_vec);
                
                Lost_probs(1:block_length, sim_no, block - 5, subj) = lost_prob_vec;
                
                Resp_probs(1:block_length, sim_no, block - 5, subj) = resp_prob_vec;
            
            end
            
        end
        
    end
    
end


save_str = ['Lost_probs_',model_str];

save(save_str,'Lost_probs','Resp_probs');


