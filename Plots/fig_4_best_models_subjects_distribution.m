
load('C:\data_path\Likelihood_batchjobs\best_model_subjs.mat');

hist_5 = hist(best_model_subjs,(1:5))';

hist_4 = [hist_5(1,1) + hist_5(2,1); hist_5(3:end)];

figure();
bar(hist_4);
