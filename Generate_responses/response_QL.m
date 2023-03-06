function [resp_out] = response_QL(stim_in, Q_2D_in, tau_value)

q_current = Q_2D_in(stim_in,:);


if ~isnan(tau_value)
    
    current_probs_softmax = exp(q_current/tau_value)/sum(exp(q_current/tau_value));
    
else
    
    max_prob = max(q_current);
    
    current_probs_bin = q_current==max_prob;
    
    current_probs_softmax = current_probs_bin/sum(current_probs_bin);
    
end

current_probs_cum = cumsum(current_probs_softmax);

u_resp_temp = rand();

u_resp_binary = u_resp_temp <= current_probs_cum;

[~,resp_out] = max(u_resp_binary);

