function [resp_out] = response_BP(stim_in, Q_3D_in, tau_value)


prob_mat = mean(Q_3D_in, 3);

current_probs = prob_mat(stim_in,:);

current_probs_bin = zeros(1,4);
current_probs_bin(current_probs > 0) = 1;

current_probs_uniform = current_probs_bin/sum(current_probs_bin);


if ~isnan(tau_value)
    
    current_probs_softmax = exp(current_probs_uniform/tau_value)/sum(exp(current_probs_uniform/tau_value));
    
else
    
    current_probs_softmax = current_probs_uniform;
    
end

current_probs_cum = cumsum(current_probs_softmax);

u_resp_temp = rand();

u_resp_binary = u_resp_temp <= current_probs_cum;

[~,resp_out] = max(u_resp_binary);

