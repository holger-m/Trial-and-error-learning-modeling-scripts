function [Q_2D] = update_QL(stim_in, resp_in, resp_corr_in, Q_2D, alpha_value)


if resp_in == resp_corr_in
    
    r = 1;
    
else
    
    r = -1;
    
end

Q_2D(stim_in, resp_in) = (1 - alpha_value)*Q_2D(stim_in, resp_in) + alpha_value*r;

