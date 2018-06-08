function [likelihood_vec] = run_block(stim_vec, resp_actu_vec, resp_corr_vec, model_str, tau_value, alpha_value)


if strcmp(model_str, 'FOP') || strcmp(model_str, 'BP')
    
    Q_3D = initialize_FOP();
    
elseif strcmp(model_str, 'QL')
    
    Q_2D = initialize_QL;
    
else
    
    [DRP_guess_internal, DRP_corr_internal] = initialize_DRP;
    
    dfkl_version = [str2double(model_str(1,1)),...
                    str2double(model_str(1,2)),...
                    str2double(model_str(1,3)),...
                    str2double(model_str(1,4))];
                
    dfkl_version_inv = NaN(1,4);
    
    for j = 1:4
        
        dfkl_version_inv(1,dfkl_version(1,j)) = j;
        
    end
    
end


n_trials = size(stim_vec,1);

likelihood_vec = NaN(n_trials,1);

for trial_no = 1:n_trials
    
    current_stim = stim_vec(trial_no,1);
    
    current_resp_actu = resp_actu_vec(trial_no,1);
    
    current_resp_corr = resp_corr_vec(trial_no,1);
    
    
    if strcmp(model_str, 'FOP')
    
        current_resp_probs = response_FOP(current_stim, Q_3D, tau_value);
        
    elseif strcmp(model_str, 'BP')
        
        current_resp_probs = response_BP(current_stim, Q_3D, tau_value);

    elseif strcmp(model_str, 'QL')

        current_resp_probs = response_QL(current_stim, Q_2D, tau_value);

    else

        current_resp_probs = response_DRP(current_stim, DRP_guess_internal, DRP_corr_internal, dfkl_version, tau_value);
        
        if ~isnan(current_resp_actu)
        
            current_resp_int = dfkl_version_inv(1,current_resp_actu);

        else

            clear current_resp_int

        end        

    end
    
    
    if ~isnan(current_resp_actu)
        
        likelihood_vec(trial_no,1) = current_resp_probs(1, current_resp_actu);
        
    else
        
        likelihood_vec(trial_no,1) = 0;
        
    end
    
    
    if ~isnan(current_resp_actu)
    
        if strcmp(model_str, 'FOP') || strcmp(model_str, 'BP')
    
            Q_3D = update_FOP(current_stim, current_resp_actu, current_resp_corr, Q_3D);

        elseif strcmp(model_str, 'QL')

            Q_2D = update_QL(current_stim, current_resp_actu, current_resp_corr, Q_2D, alpha_value);

        else
            
            if ~(isnan(DRP_corr_internal(current_stim,1)) && current_resp_corr ~= current_resp_actu && dfkl_version(1,DRP_guess_internal(current_stim,1)) ~= current_resp_actu)
                
                [DRP_guess_internal, DRP_corr_internal] = update_DRP(current_stim, current_resp_corr, current_resp_actu, current_resp_int, DRP_guess_internal, DRP_corr_internal);
                
            end

        end
        
    end   
    
end

