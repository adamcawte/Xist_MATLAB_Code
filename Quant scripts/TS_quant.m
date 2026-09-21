function [Mins, Maxs, MaxM, Maxstd, MinM, Minstd] = TS_quant(Spots)

Mins = []
Maxs = []
for i = 1:length(Spots)
[G,ID] = findgroups(Spots{i}(:,2))
c = splitapply(@(m){m},Spots{i},G)

    mins = []
    maxs = []
    for j = 1:length(c)
        mis = min(c{j},[],1)
        mxs = max(c{j},[],1)
        mins = [mins ; mis]
        maxs = [maxs ; mxs]
       

    end
    Mins = [Mins ; {mins}]
    Maxs = [Maxs ; {maxs}]
end

MaxC = cellfun(@(x) x(:, 3), Maxs, 'UniformOutput', false);
MaxC = cellfun(@(x) [x; NaN(60 - length(x), 1)], MaxC, 'UniformOutput', false);

MinsC = cellfun(@(x) x(:, 3), Mins, 'UniformOutput', false);
MinsC = cellfun(@(x) [x; NaN(60 - length(x), 1)], MinsC, 'UniformOutput', false);

Maxstacked = cat(2, MaxC{:});     % Result is 60×22 matrix
MaxM = mean(Maxstacked, 2, 'omitnan'); % Compute row-wise mean → 60×1 vector
Maxstd = std(Maxstacked, 0, 2, 'omitnan');

Minstacked = cat(2, MinsC{:});     % Result is 60×22 matrix
MinM = mean(Minstacked, 2, 'omitnan'); % Compute row-wise mean → 60×1 vector
Minstd = std(Minstacked, 0, 2, 'omitnan');

frame = 1:length(MaxM)

figure;
hold on;
plot(frame,MaxM)
plot(frame,MinM)
end