function [] = batch_all_jobs(batch_no)

maxNumCompThreads(1);

rng('shuffle');
scurr = rng; %#ok<NASGU>

end_subj_vec = [(6:6:60), (65:5:85)]';
start_subj_vec = [1; end_subj_vec(1:14,1) + 1];

start_subj = start_subj_vec(batch_no,1);
end_subj = end_subj_vec(batch_no,1);

load('C:\data_path\Human_data.mat','stim_3D','response_correct_3D');

load('C:\data_path\Likelihood_batchjobs\Max_likelihoods.mat','parameter_tau_mat','parameter_alpha_vec');

tau_vec = [NaN, 1./(6:-0.2:0.2)]';
alpha_vec = (0.05:0.05:1)';

all_perms = perms((1:4));


n_sim = 1000;

for subj = start_subj:end_subj   
    
    for model_no = [1, 21, 25, 26, 27]        
        
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
        
        disp(' ');
        disp(['Processing subj no. ',num2str(subj,'%02.0f'),', model ',model_str]);
        
        
        tau_no = parameter_tau_mat(subj, model_no);
        
        tau_value = tau_vec(tau_no, 1);
        
        if model_no == 27
            
            alpha_no = parameter_alpha_vec(subj,1);
            
            alpha_value = alpha_vec(alpha_no,1);
            
        else
            
            clear alpha_no
            clear alpha_value
            
        end
        
        responses_sims_blocks = NaN(70, n_sim, 15);
        
        for block = 6:20
            
            current_stim_vec = stim_3D(:, block, subj); %#ok<NODEF>
            
            block_length = sum(~isnan(current_stim_vec));
            
            current_stim_vec = current_stim_vec(1:block_length);
            
            current_resp_corr_vec = response_correct_3D(1:block_length, block, subj);
            
            for sim_no = 1:n_sim
                
                if model_no <= 26
                
                    response_vec = run_block(current_stim_vec, current_resp_corr_vec, model_str, tau_value);
                    
                elseif model_no == 27
                    
                    response_vec = run_block(current_stim_vec, current_resp_corr_vec, model_str, tau_value, alpha_value);                    
                    
                end
                
                responses_sims_blocks(1:block_length, sim_no, block - 5) = response_vec;            
                
            end
            
        end
        
        save_str = ['.\',model_str,'\',model_str,'_',num2str(subj,'%02.0f'),'.mat'];
        
        save(save_str,'responses_sims_blocks','scurr');
        
    end
    
end


