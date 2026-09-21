function [Acell, Tcell, meansaA, stdsaA, Tmin] = Area_Multi(Foci)

nFiles = numel(Foci);
Acell = cell(nFiles,1);
Tcell = cell(nFiles,1);


for FileNum = 1:nFiles
    try
        % safe indexing: allow row or column cell arrays
        foci = Foci{FileNum};
        [Acell{FileNum}, Tcell{FileNum}] = Area_Calc(foci);
    catch err
        fprintf('VolT_Multi: VolT_Calc failed for file %d: %s\n', FileNum, err.message);
        Acell{FileNum} = [];
        Tcell{FileNum} = [];
    end
end


%Makes mean,std and time values for plotting mean curve
    vT = vertcat(Tcell{:});
    vA = vertcat(Acell{:});
    GroupT = findgroups(vT);
    saA = splitapply(@(m){m},vA,GroupT);
    meansaA = cellfun(@mean,saA);
    stdsaA = cellfun(@std,saA);
    Tmin = 2*(0:(max(GroupT)-1)).';

    %plots mean vs time in min
    figure
    hold on;
    plot(Tmin,meansaA)
    errorbar(Tmin,meansaA,stdsaA)

end



function [A,T] = Area_Calc(Foci)

G = findgroups(Foci(:,4));
c = splitapply(@(m){m},Foci,G);
C = c(cellfun('size',c,1) >= 3);

A = [];
for i = 1:length(C);
    try [~,a] = convhull(C{i}(:,1),C{i}(:,2));
        A = [A ; a];
    catch
        fprintf('loop number %d failed\n',i)
    end
end

T = [];
for j = 1:length(C);
    try mt = mean(C{j}(:,4));
        T = [T ; mt];
    catch
        fprintf('loop number %d failed\n',i)
    end
end
    try T = (T - T(1))*2;
    catch
    fprintf('loop number %d failed\n',i)
    end
end