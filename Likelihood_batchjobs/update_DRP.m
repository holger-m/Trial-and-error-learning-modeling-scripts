function [DRP_guess_internal, DRP_corr_internal] = update_DRP(stim_in, resp_corr_in, resp_ext, resp_int, DRP_guess_internal, DRP_corr_internal)

if isnan(DRP_corr_internal(stim_in,1))
    
    if resp_ext == resp_corr_in
        
        DRP_corr_internal(stim_in,1) = resp_int;
        
        DRP_guess_internal(stim_in,1) = NaN;
        
        shiftup_bin = DRP_guess_internal == resp_int;
        
        if any(shiftup_bin)
            
            free_responses = sort(setdiff([1;2;3;4], DRP_corr_internal))';
            
            larger_bin = free_responses > resp_int;
            
            [~,larger_ind] = max(larger_bin,[],2);
            
            upshifted_response = free_responses(1, larger_ind);
            
            DRP_guess_internal(shiftup_bin) = upshifted_response;
            
        end
        
    else
        
        free_responses = sort(setdiff([1;2;3;4], DRP_corr_internal))';
        
        larger_bin = free_responses > resp_int;
        
        [~,larger_ind] = max(larger_bin,[],2);
        
        upshifted_response = free_responses(1, larger_ind);
        
        DRP_guess_internal(stim_in,1) = upshifted_response;
        
    end
    
end
