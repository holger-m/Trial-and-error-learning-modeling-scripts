
load('C:\data_path\Human_data.mat');

load('C:\data_path\Likelihood_batchjobs\Max_likelihoods.mat');


all_perms = perms((1:4));

Loglike_blockmean_3D = NaN(15,5,85);

model_count = 0;

for model_no = [1, 21, 25, 26, 27]
    
    model_count = model_count + 1;
    
    if model_no <= 24
    
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
    
    load_str = ['Likelihoods_',model_str,'.mat'];
    
    load(load_str);   
   
    
    for subj = 1:85
        
        tau_no = parameter_tau_mat(subj, model_no);
        
        if model_no <= 26
        
            clear alpha_value
            
            data_temp = likelihoods_3D(:,:,subj,tau_no);

        else
            
            alpha_no = parameter_alpha_vec(subj,1);
            
            data_temp = likelihoods_3D(:,:,subj,tau_no,alpha_no);

        end
        
        for block = 6:20
            
            human_actual_responses_isnan = isnan(response_actual_3D(1:length_initial_learning(subj,block),block,subj));
                    
            initial_block_part = data_temp(1:length_initial_learning(subj,block),block);

            initial_block_part(human_actual_responses_isnan,:) = [];
            
            log_probs = log(initial_block_part);
            
            log_probs_mean = mean(log_probs);
            
            Loglike_blockmean_3D(block - 5, model_count, subj) = log_probs_mean;
            
        end   
        
    end
    
end


p_values_1_sided = NaN(5,5,85);

for subj = 1:85
    
    subj_loglikelis = Loglike_blockmean_3D(:,:,subj);
    
    for model_i = 1:5
        
        model_j_vec = (1:5);
        
        model_j_vec(:,model_i) = [];
        
        x = subj_loglikelis(:,model_i);
        
        for model_j = model_j_vec
            
            y = subj_loglikelis(:,model_j);
            
            p = signrank(x,y,'tail','right');
            
            p_values_1_sided(model_i, model_j, subj) = p;
            
        end
        
    end
    
    
end

p_values_1_sided_binary = p_values_1_sided <= 0.05;


DRP_dfkl_better_than_others = false(85,1);
DRP_lkfd_better_than_others = false(85,1);
FOP_better_than_BP_and_QL = false(85,1);
BP_better_than_QL = false(85,1);

for subj = 1:85
    
    p_values_binary_subj = double(p_values_1_sided_binary(:,:,subj));
    
    p_values_binary_subj(eye(5) == 1) = NaN;
    
    p_values_binary_subj_sum = nansum(p_values_binary_subj,2);
    
    if p_values_binary_subj_sum(2,1) == 4
        
        DRP_dfkl_better_than_others(subj,1) = true;
        
    elseif p_values_binary_subj_sum(1,1) == 4
        
        DRP_lkfd_better_than_others(subj,1) = true;
        
    elseif p_values_binary_subj(3,4) == 1 && p_values_binary_subj(3,5)
        
        FOP_better_than_BP_and_QL(subj,1) = true;
        
    elseif p_values_binary_subj(4,5)
        
        BP_better_than_QL(subj,1) = true;        
       
    end
    
end


who_is_better_mat = [DRP_dfkl_better_than_others,...
                     DRP_lkfd_better_than_others,...
                     FOP_better_than_BP_and_QL,...
                     BP_better_than_QL];
                     
best_model_subjs = NaN(85,1);

for subj = 1:85
    
    temp = find(who_is_better_mat(subj,:));
    
    if size(temp,2) == 1
        
        best_model_subjs(subj,1) = temp;
        
    else
        
        best_model_subjs(subj,1) = 5;
        
    end
    
end

% 1: DRP_dfkl better than all others
% 2: DRP_lkfd better than all others
% 3: FOP better than BP and QL
% 4: BP better than QL
% 5: BP and QL not sign. different

temp = p_values_1_sided_binary(:,:,best_model_subjs == 5)

save('best_model_subjs','best_model_subjs');

