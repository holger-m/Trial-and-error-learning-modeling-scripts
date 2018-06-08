
all_perms = perms((1:4));

for model_no = [0, 1, 21, 25, 26, 27]
    
    if model_no == 0
    
        model_str = 'humans';  

    elseif model_no <= 24

        model_str = strcat(num2str(all_perms(model_no,1)), ...
                           num2str(all_perms(model_no,2)), ...
                           num2str(all_perms(model_no,3)), ...
                           num2str(all_perms(model_no,4)));

    elseif model_no == 25

        model_str = 'FOP';

    elseif model_no == 26

        model_str = 'BP';

    elseif model_no == 27

        model_str = 'QL';

    end
    
    clear Errors_types_3D
    
    load(['C:\data_path\Error_analysis\Error_types_1_to_9_',model_str,'.mat']);
    
    eval(['Errors_types_3D_',model_str,' = Errors_types_3D;']);
    
end

clear Errors_types_3D

Errors_types_3D_humans = squeeze(mean(Errors_types_3D_humans(1:7,:,:),2))';
Errors_types_3D_1234 = squeeze(mean(mean(Errors_types_3D_1234(1:7,:,:,:),2),3))';
Errors_types_3D_4321 = squeeze(mean(mean(Errors_types_3D_4321(1:7,:,:,:),2),3))';
Errors_types_3D_FOP = squeeze(mean(mean(Errors_types_3D_FOP(1:7,:,:,:),2),3))';
Errors_types_3D_BP = squeeze(mean(mean(Errors_types_3D_BP(1:7,:,:,:),2),3))';
Errors_types_3D_QL = squeeze(mean(mean(Errors_types_3D_QL(1:7,:,:,:),2),3))';

load('C:\data_path\Likelihood_batchjobs\best_model_subjs.mat');


logical_mat = eye(7) == 1;

opt_sort_5 = repmat(logical_mat(1,:), 1, 5);
subopt_sort_5 = repmat(logical_mat(2,:), 1, 5);
repeat_sort_5 = repmat(logical_mat(3,:), 1, 5);
cfds_sort_5 = repmat(logical_mat(4,:), 1, 5);
both_sort_5 = repmat(logical_mat(5,:), 1, 5);
none_sort_5 = repmat(logical_mat(6,:), 1, 5);
after_1_sort_5 = repmat(logical_mat(7,:), 1, 5);

opt_sort_4 = repmat(logical_mat(1,:), 1, 4);
subopt_sort_4 = repmat(logical_mat(2,:), 1, 4);
repeat_sort_4 = repmat(logical_mat(3,:), 1, 4);
cfds_sort_4 = repmat(logical_mat(4,:), 1, 4);
both_sort_4 = repmat(logical_mat(5,:), 1, 4);
none_sort_4 = repmat(logical_mat(6,:), 1, 4);
after_1_sort_4 = repmat(logical_mat(7,:), 1, 4);

DRP_best_errortypes = NaN(sum(best_model_subjs <= 2), 35);
FOP_best_errortypes = NaN(sum(best_model_subjs == 3), 28);
BP_best_errortypes = NaN(sum(best_model_subjs == 4), 28);

DRP_count = 0;
FOP_count = 0;
BP_count = 0;

for subj = 1:85
    
    switch best_model_subjs(subj,1)
        
        case 1
            
            DRP_count = DRP_count + 1;
            
            unsorted_temp = [Errors_types_3D_humans(subj,:),...
                             Errors_types_3D_1234(subj,:),...
                             Errors_types_3D_FOP(subj,:),...
                             Errors_types_3D_BP(subj,:),...
                             Errors_types_3D_QL(subj,:)];
            
            sorted_temp = [unsorted_temp(1, opt_sort_5),...
                           unsorted_temp(1, subopt_sort_5),...
                           unsorted_temp(1, repeat_sort_5),...
                           unsorted_temp(1, cfds_sort_5),...
                           unsorted_temp(1, both_sort_5),...
                           unsorted_temp(1, none_sort_5),...
                           unsorted_temp(1, after_1_sort_5)];
            
            DRP_best_errortypes(DRP_count,:) = sorted_temp;
            
        case 2
            
            DRP_count = DRP_count + 1;
            
            unsorted_temp = [Errors_types_3D_humans(subj,:),...
                             Errors_types_3D_4321(subj,:),...
                             Errors_types_3D_FOP(subj,:),...
                             Errors_types_3D_BP(subj,:),...
                             Errors_types_3D_QL(subj,:)];
            
            sorted_temp = [unsorted_temp(1, opt_sort_5),...
                           unsorted_temp(1, subopt_sort_5),...
                           unsorted_temp(1, repeat_sort_5),...
                           unsorted_temp(1, cfds_sort_5),...
                           unsorted_temp(1, both_sort_5),...
                           unsorted_temp(1, none_sort_5),...
                           unsorted_temp(1, after_1_sort_5)];
            
            DRP_best_errortypes(DRP_count,:) = sorted_temp;
            
        case 3
            
            FOP_count = FOP_count + 1;
            
            unsorted_temp = [Errors_types_3D_humans(subj,:),...
                             Errors_types_3D_FOP(subj,:),...
                             Errors_types_3D_BP(subj,:),...
                             Errors_types_3D_QL(subj,:)];
            
            sorted_temp = [unsorted_temp(1, opt_sort_4),...
                           unsorted_temp(1, subopt_sort_4),...
                           unsorted_temp(1, repeat_sort_4),...
                           unsorted_temp(1, cfds_sort_4),...
                           unsorted_temp(1, both_sort_4),...
                           unsorted_temp(1, none_sort_4),...
                           unsorted_temp(1, after_1_sort_4)];
            
            FOP_best_errortypes(FOP_count,:) = sorted_temp;
            
        case 4
            
            BP_count = BP_count + 1;
            
            unsorted_temp = [Errors_types_3D_humans(subj,:),...
                             Errors_types_3D_FOP(subj,:),...
                             Errors_types_3D_BP(subj,:),...
                             Errors_types_3D_QL(subj,:)];
            
            sorted_temp = [unsorted_temp(1, opt_sort_4),...
                           unsorted_temp(1, subopt_sort_4),...
                           unsorted_temp(1, repeat_sort_4),...
                           unsorted_temp(1, cfds_sort_4),...
                           unsorted_temp(1, both_sort_4),...
                           unsorted_temp(1, none_sort_4),...
                           unsorted_temp(1, after_1_sort_4)];
            
            BP_best_errortypes(BP_count,:) = sorted_temp;
            
    end

end

