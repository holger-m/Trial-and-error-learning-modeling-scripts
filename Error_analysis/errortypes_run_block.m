function [errors_types_1_to_9] = errortypes_run_block(stim_vec, resp_actu_vec, resp_corr_vec, lost_prob_vec, resp_prob_vec)

n_trials = size(stim_vec,1);

errors_types_1_to_9 = zeros(9,1);   % 1: optimal 
                                    % 2: suboptimal 
                                    % 3: repeatly wrong 
                                    % 4: correct for different stimulus
                                    % 5: both 3 and 4
                                    % 6: neither 3 nor 4                                   
                                    % 7: after stim corr
                                    % 8: after initial
                                    % 9: no response


resp_accuracy = resp_actu_vec == resp_corr_vec;

n_errors_overall = sum(~resp_accuracy);

first_correct_stimwise = NaN(4,1);

for stim = 1:4

    stim_accu_vec = resp_accuracy & stim_vec == stim;

    if all(~stim_accu_vec)                        

        first_corr_stim = n_trials;

    else

        [~,first_corr_stim] = max(stim_accu_vec);

    end

    first_correct_stimwise(stim,1) = first_corr_stim;

end

latest_stim_corr = max(first_correct_stimwise);


for trial_no = 1:n_trials
    
    if ~resp_accuracy(trial_no,1)
        
        if isnan(resp_actu_vec(trial_no,1))
            
            errors_types_1_to_9(9,1) = errors_types_1_to_9(9,1) + 1;
            
        else
            
            current_stim = stim_vec(trial_no,1);
            
            current_resp_actu = resp_actu_vec(trial_no,1);
            
            if trial_no > latest_stim_corr
                
                errors_types_1_to_9(8,1) = errors_types_1_to_9(8,1) + 1;
                
            elseif trial_no > first_correct_stimwise(current_stim,1)
                
                errors_types_1_to_9(7,1) = errors_types_1_to_9(7,1) + 1;
                
            elseif lost_prob_vec(trial_no,1) == 0
                
                errors_types_1_to_9(1,1) = errors_types_1_to_9(1,1) + 1;
                
            elseif resp_prob_vec(trial_no,1) > 0
                
                errors_types_1_to_9(2,1) = errors_types_1_to_9(2,1) + 1;
                
            else 
                
                if any(stim_vec(1:trial_no-1,1) == current_stim & resp_actu_vec(1:trial_no-1,1) == current_resp_actu)
                    
                    repeated_wrong_flag = true;
                    
                else
                    
                    repeated_wrong_flag = false;
                    
                end
                
                if any(resp_actu_vec(1:trial_no-1,1) == current_resp_actu & resp_accuracy(1:trial_no-1,1))
                    
                    corr_for_diff_stim_flag = true;
                    
                else
                    
                    corr_for_diff_stim_flag = false;
                    
                end
                
                if repeated_wrong_flag && ~corr_for_diff_stim_flag

                    errors_types_1_to_9(3,1) = errors_types_1_to_9(3,1) + 1;

                elseif ~repeated_wrong_flag && corr_for_diff_stim_flag

                    errors_types_1_to_9(4,1) = errors_types_1_to_9(4,1) + 1;

                elseif repeated_wrong_flag && corr_for_diff_stim_flag

                    errors_types_1_to_9(5,1) = errors_types_1_to_9(5,1) + 1;

                elseif ~repeated_wrong_flag && ~corr_for_diff_stim_flag

                    errors_types_1_to_9(6,1) = errors_types_1_to_9(6,1) + 1;

                end
                
            end
            
        end
    
    end
    
end

if sum(errors_types_1_to_9) ~= n_errors_overall
    
    error('Did not catch all errors!');
    
end

