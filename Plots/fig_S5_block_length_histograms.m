
load('C:\data_path\Human_data.mat');

length_initial_learning = NaN(85,20);

length_complete_block = NaN(85,20);

for subj = 1:85
    
    for block = 1:20
        
        current_stim_vec = stim_3D(:, block, subj); 
        
        block_length = sum(~isnan(current_stim_vec));
        
        length_complete_block(subj,block) = block_length;
        
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
        
        length_initial_learning(subj,block) = latest_stim_corr;
        
    end
    
end

length_initial_learning = length_initial_learning(:,6:20);
length_complete_block = length_complete_block(:,6:20);

length_initial_learning_vec = length_initial_learning(:);
length_complete_block_vec = length_complete_block(:);


figure();
hist(length_complete_block_vec, (32:70));
hist_length_complete_block = hist(length_complete_block_vec, (32:70))';

figure();
hist(length_initial_learning_vec, (4:50));
hist_length_initial_learning = hist(length_initial_learning_vec , (4:50))';

