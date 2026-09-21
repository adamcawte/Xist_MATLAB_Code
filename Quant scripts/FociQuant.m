function [FociNum, NND, Vol] = FociQuant(Foci)

FociNum = []
for i = 1:length(Foci)
    focinum = length(Foci{i});
    FociNum = [FociNum ; focinum];
end

NND = []
IDX = [];
for j = 1:length(Foci)
    [Idx,nnd] = knnsearch(Foci{j},Foci{j},'K',2);
    nndu = unique(nnd(:,2));
    NND = [NND ; {nndu}];
    IDX = [IDX ; {Idx}];
end
NND = vertcat(NND{:});

%Dist2Mean = []
%D2M_means = []
%for k = 1:length(Foci) 
%    dist = vecnorm(Foci{k} - mean(Foci{k}), 2, 2)
%    Dist2Mean = [Dist2Mean ; {dist}]
%    d2mm = mean(Dist2Mean{k})
%    D2M_means = [D2M_means ; d2mm]
%end

Vol = []
for l = 1:length(Foci)
    x = Foci{l}(:,1);
    y = Foci{l}(:,2);
    z = Foci{l}(:,3);
    try
        [~,V] = convhull(x,y,z);
    catch
        fprintf('loop number %d failed\n',l)
    end
    Vol = [Vol ; V];
end

%D2M_all = vertcat(Dist2Mean{:})