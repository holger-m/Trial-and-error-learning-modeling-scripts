function [resp_out] = response_FOP(stim_in, Q_3D_in, tau_value)


prob_mat = mean(Q_3D_in, 3);

current_probs = prob_mat(stim_in,:);

if ~isnan(tau_value)
    
    current_probs_softmax = exp(current_probs/tau_value)/sum(exp(current_probs/tau_value));
    
else
    
    max_prob = max(current_probs);
    
    current_probs_bin = current_probs==max_prob;
    
    current_probs_softmax = current_probs_bin/sum(current_probs_bin);
    
end

current_probs_cum = cumsum(current_probs_softmax);

u_resp_temp = rand();

u_resp_binary = u_resp_temp <= current_probs_cum;

[~,resp_out] = max(u_resp_binary);

