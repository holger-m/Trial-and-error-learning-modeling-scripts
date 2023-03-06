function [Q_3D_in] = update_FOP(stim_in, resp_in, resp_corr_in, Q_3D_in)

    
if resp_in == resp_corr_in

    Q_3D_in(:,:,squeeze(Q_3D_in(stim_in, resp_in,:)) == 0) = [];

else

    Q_3D_in(:,:,squeeze(Q_3D_in(stim_in, resp_in,:)) == 1) = [];

end
