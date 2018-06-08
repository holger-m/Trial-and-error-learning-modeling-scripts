function [response_vec] = run_block(stim_vec, resp_corr_vec, model_str, tau_value, alpha_value)


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
                
end


n_trials = size(stim_vec,1);

response_vec = NaN(n_trials,1);

for trial_no = 1:n_trials
    
    current_stim = stim_vec(trial_no,1);
    
    current_resp_corr = resp_corr_vec(trial_no,1);
    
    
    if strcmp(model_str, 'FOP')
    
        current_resp_actu = response_FOP(current_stim, Q_3D, tau_value);
        
    elseif strcmp(model_str, 'BP')
        
        current_resp_actu = response_BP(current_stim, Q_3D, tau_value);

    elseif strcmp(model_str, 'QL')

        current_resp_actu = response_QL(current_stim, Q_2D, tau_value);

    else

        [current_resp_actu, current_resp_int] = response_DRP(current_stim, DRP_guess_internal, DRP_corr_internal, dfkl_version, tau_value);
        
    end
    
    response_vec(trial_no,1) = current_resp_actu;
    
    
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

