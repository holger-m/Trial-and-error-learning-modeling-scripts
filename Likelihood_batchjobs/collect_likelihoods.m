
load('C:\data_path\Human_data.mat');

length_initial_learning = NaN(85,20);

for subj = 1:85
    
    for block = 1:20
        
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
        
        length_initial_learning(subj,block) = latest_stim_corr;
        
    end
    
end



all_perms = perms((1:4));

likelihood_mat = NaN(85,27);

parameter_tau_mat = NaN(85,27);

parameter_alpha_vec = NaN(85,1);

for model_no = 1:27
    
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
    
    load_str = ['Likelihoods_',model_str,'.mat'];
    
    load(load_str);   
   
    
    for subj = 1:85
        
        if model_no <= 26
        
            logprobs_subj = NaN(31,1);

        else
            
            logprobs_subj = NaN(31,20);

        end
        
        for tau_no = 1:31
            
            if model_no <= 26
                
                data_temp = likelihoods_3D(:,:,subj,tau_no);
                
                likelihood_initial_phase_blocks_of_interest = [];
                
                for block = 6:20
                    
                    human_actual_responses_isnan = isnan(response_actual_3D(1:length_initial_learning(subj,block),block,subj));
                    
                    initial_block_part = data_temp(1:length_initial_learning(subj,block),block);
                    
                    initial_block_part(human_actual_responses_isnan,:) = [];
                    
                    likelihood_initial_phase_blocks_of_interest = [likelihood_initial_phase_blocks_of_interest; initial_block_part]; %#ok<AGROW>
                                        
                end
                
                if tau_no >= 2 && (any(likelihood_initial_phase_blocks_of_interest < 0.000001) || any(isnan(likelihood_initial_phase_blocks_of_interest)))
                    
                    error('Low probs, maybe missing response?');
                    
                end
                
                log_probs = log(likelihood_initial_phase_blocks_of_interest);
                
                logprobs_subj(tau_no,1) = mean(log_probs);
                
            else
                
                for alpha_no = 1:20
                    
                    data_temp = likelihoods_3D(:,:,subj,tau_no,alpha_no);

                    likelihood_initial_phase_blocks_of_interest = [];

                    for block = 6:20

                        human_actual_responses_isnan = isnan(response_actual_3D(1:length_initial_learning(subj,block),block,subj));

                        initial_block_part = data_temp(1:length_initial_learning(subj,block),block);

                        initial_block_part(human_actual_responses_isnan,:) = [];

                        likelihood_initial_phase_blocks_of_interest = [likelihood_initial_phase_blocks_of_interest; initial_block_part]; %#ok<AGROW>

                    end

                    if tau_no >= 2 && (any(likelihood_initial_phase_blocks_of_interest < 0.000001) || any(isnan(likelihood_initial_phase_blocks_of_interest)))

                        error('Low probs, maybe missing response?');

                    end

                    log_probs = log(likelihood_initial_phase_blocks_of_interest);

                    logprobs_subj(tau_no,alpha_no) = mean(log_probs); 
                    
                end
                
            end
            
        end
        
        if model_no <= 26
            
            max_likeli = max(logprobs_subj);
            
            tau_no = find(logprobs_subj == max_likeli);
            
            if size(tau_no,1) ~= 1
                
                error('Maximum not unique!');
                
            end
            
            likelihood_mat(subj, model_no) = max_likeli;
            
            parameter_tau_mat(subj, model_no) = tau_no;            
            
        else
            
            max_likeli = max(logprobs_subj(:));
            
            [tau_no, alpha_no] = find(logprobs_subj == max_likeli);
            
            if size(tau_no,1) ~= 1
                
                error('Maximum not unique!');
                
            end
            
            likelihood_mat(subj, model_no) = max_likeli;
            
            parameter_tau_mat(subj, model_no) = tau_no;
            
            parameter_alpha_vec(subj, 1) = alpha_no;
            
        end
        
    end
    
end


save('Max_likelihoods','likelihood_mat','parameter_tau_mat','parameter_alpha_vec','length_initial_learning');

