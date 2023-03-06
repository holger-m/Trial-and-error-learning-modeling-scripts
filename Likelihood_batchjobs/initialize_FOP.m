function [Q_3D_out] = initialize_FOP()


all_perms = perms((1:4));

Q_3D_out = zeros(4,4,24);

for index = 1:24

    for subindex = 1:4

        Q_3D_out(subindex,all_perms(index,subindex),index) = 1;

    end

end
