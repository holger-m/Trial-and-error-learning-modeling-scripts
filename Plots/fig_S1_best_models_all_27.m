
load('C:\data_path\Likelihood_batchjobs\Max_likelihoods.mat','likelihood_mat');

[~,best_model_subjs] = max(likelihood_mat,[],2);

figure();
hist(best_model_subjs,(1:27));

hist_data = hist(best_model_subjs,(1:27))';


all_perms = perms((1:4));

model_cell = cell(27,1);

for model_no = 1:27

    if model_no <= 24

        model_str = strcat(num2str(all_perms(model_no,1)), ...
                           num2str(all_perms(model_no,2)), ...
                           num2str(all_perms(model_no,3)), ...
                           num2str(all_perms(model_no,4)));
                       
        model_str_new = 'xxxx';
        
        for j = 1:4
            
            switch model_str(1,j)
                
                case '1'
                    
                    model_str_new(1,j) = 'd';
                    
                case '2'
                    
                    model_str_new(1,j) = 'f';
                    
                case '3'
                    
                    model_str_new(1,j) = 'k';
                    
                case '4'
                    
                    model_str_new(1,j) = 'l';
                    
            end
            
        end
        
        model_str = model_str_new;

    elseif model_no == 25

        model_str = 'FOP';

    elseif model_no == 26

        model_str = 'BP';

    elseif model_no == 27

        model_str = 'QL';

    end
    
    model_cell{model_no,1} = model_str;

end