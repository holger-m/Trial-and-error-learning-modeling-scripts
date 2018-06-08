function [current_probs_softmax] = response_BP(stim_in, Q_3D_in, tau_value)


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

