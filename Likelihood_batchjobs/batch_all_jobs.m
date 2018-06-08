function [] = batch_all_jobs(model_no)

load('C:\data_path\Human_data.mat');

tau_vec = [NaN, 1./(6:-0.2:0.2)]';
alpha_vec = (0.05:0.05:1)';

all_perms = perms((1:4));

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

save_str = ['Likelihoods_',model_str];

if model_no <= 26
    
    likelihoods_3D = NaN(70, 20, 85, 31);
    
elseif model_no == 27
    
    likelihoods_3D = NaN(70, 20, 85, 31, 20);
    
end

for subj = 1:85
    
    disp(' ');
    disp(['Processing model ',model_str,', subj no. ',num2str(subj,'%02.0f')]);
    
    for block = 1:20
        
        current_stim_vec = stim_3D(:, block, subj); %#ok<NODEF>
        
        block_length = sum(~isnan(current_stim_vec));
        
        if any(~isnan(current_stim_vec) ~= [true(block_length,1); false(70 - block_length,1)])
            
            error('Stimulus pattern wrong!');
            
        end
        
        current_stim_vec = current_stim_vec(1:block_length);        
        
        current_resp_actu_vec = response_actual_3D(1:block_length, block, subj);
        
        current_resp_corr_vec = response_correct_3D(1:block_length, block, subj);
        
        for tau_no = 1:31
            
            tau_value = tau_vec(tau_no, 1);
            
            if model_no <= 26
                
                likelihood_vec = run_block(current_stim_vec, current_resp_actu_vec, current_resp_corr_vec, model_str, tau_value);
                
                likelihoods_3D(1:block_length, block, subj, tau_no) = likelihood_vec;
                
            elseif model_no == 27
                
                for alpha_no = 1:20
                    
                    alpha_value = alpha_vec(alpha_no, 1);
                    
                    likelihood_vec = run_block(current_stim_vec, current_resp_actu_vec, current_resp_corr_vec, model_str, tau_value, alpha_value);
                    
                    likelihoods_3D(1:block_length, block, subj, tau_no, alpha_no) = likelihood_vec;
                    
                end
                
            end
            
        end
        
    end
    
end

save(save_str,'likelihoods_3D');
