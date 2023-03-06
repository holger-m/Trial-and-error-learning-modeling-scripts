function [current_probs_softmax] = response_QL(stim_in, Q_2D_in, tau_value)

q_current = Q_2D_in(stim_in,:);


if ~isnan(tau_value)
    
    current_probs_softmax = exp(q_current/tau_value)/sum(exp(q_current/tau_value));
    
else
    
    max_prob = max(q_current);
    
    current_probs_bin = q_current==max_prob;
    
    current_probs_softmax = current_probs_bin/sum(current_probs_bin);
    
end
