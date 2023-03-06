
run('fig_S3_error_bar_plots.m');

DRP_opti_subopti = [DRP_best_errortypes(:,(1:5)), NaN(43,1), DRP_best_errortypes(:,(6:10))];

FOP_opti_subopti = [FOP_best_errortypes(:,(1:4)), NaN(18,1), FOP_best_errortypes(:,(5:8))];

BP_opti_subopti = [BP_best_errortypes(:,(1:4)), NaN(19,1), BP_best_errortypes(:,(5:8))];

