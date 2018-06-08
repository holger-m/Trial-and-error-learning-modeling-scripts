function [lost_prob_vec, resp_prob_vec] = run_block_probs(stim_vec, resp_actu_vec, resp_corr_vec)

Q_3D = initialize_FOP();
    
n_trials = size(stim_vec,1);

lost_prob_vec = NaN(n_trials,1);
resp_prob_vec = NaN(n_trials,1);

for trial_no = 1:n_trials
    
    current_stim = stim_vec(trial_no,1);
    
    current_resp_actu = resp_actu_vec(trial_no,1);
    
    current_resp_corr = resp_corr_vec(trial_no,1);    
        
    current_probs = response_probs_FOP(current_stim, Q_3D);
        
      
    if ~isnan(current_resp_actu)
        
        lost_prob_vec(trial_no,1) = max(current_probs) - current_probs(1, current_resp_actu);
        
        resp_prob_vec(trial_no,1) = current_probs(1, current_resp_actu);
        
    else
        
        lost_prob_vec(trial_no,1) = max(current_probs);
        
        resp_prob_vec(trial_no,1) = 0;
        
    end
    
    
    if ~isnan(current_resp_actu)
    
        Q_3D = update_FOP(current_stim, current_resp_actu, current_resp_corr, Q_3D);

    end   
    
end

