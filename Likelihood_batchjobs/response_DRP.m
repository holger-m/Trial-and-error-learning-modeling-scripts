function [current_probs_softmax] = response_DRP(stim_in, DRP_guess_internal, DRP_corr_internal, dfkl_version, tau_value)

if isnan(DRP_corr_internal(stim_in,1))
        
    resp_internal_out = DRP_guess_internal(stim_in,1);

else

    resp_internal_out = DRP_corr_internal(stim_in,1);

end

resp_external_out = dfkl_version(1,resp_internal_out);

current_probs = zeros(1,4);

current_probs(1,resp_external_out) = 1;


if ~isnan(tau_value)   
    
    current_probs_softmax = exp(current_probs/tau_value)/sum(exp(current_probs/tau_value));    
    
else
    
    current_probs_softmax = current_probs;

end




