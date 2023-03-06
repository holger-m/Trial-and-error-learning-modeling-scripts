function [current_probs] = response_probs_FOP(stim_in, Q_3D_in)


prob_mat = mean(Q_3D_in, 3);

current_probs = prob_mat(stim_in,:);
