function [resp_external_out, resp_internal_out] = response_DRP(stim_in, DRP_guess_internal, DRP_corr_internal, dfkl_version, tau_value)

if isnan(DRP_corr_internal(stim_in,1))
        
    resp_internal_out = DRP_guess_internal(stim_in,1);

else

    resp_internal_out = DRP_corr_internal(stim_in,1);

end


if ~isnan(tau_value)   
    
    current_probs = zeros(1,4);

    current_probs(1,resp_internal_out) = 1;
    
    current_probs_softmax = exp(current_probs/tau_value)/sum(exp(current_probs/tau_value));
    
    current_probs_cum = cumsum(current_probs_softmax);

    u_resp_temp = rand();

    u_resp_binary = u_resp_temp <= current_probs_cum;

    [~,resp_internal_out] = max(u_resp_binary);

end

resp_external_out = dfkl_version(1,resp_internal_out);

