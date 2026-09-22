function [CVs, LT400s] = NNT_Quant(Tracks)

%This code quantifies the distances between nearest neighbor pairs over time from multiple cells separately. The outputs are currently set to the change in values for NNDs between 
%paired foci (CVs). The script also outputs the paired distances over time for foci which are on average less than 400 nm apart (LT400s), this can be altered in line 12. To confirm that 
%the trajectories are fit correctly with the maximum likelihood estimation, a graph of all paired trajectories and the fits is produced. These fitting parameters can be altered in 
%line 97 within the findchangepoints_YL function to better define the change points (CPs).

[PairedTracks, PairedIndexes] = MultiPairTracks(Tracks)
[Distance, Frames, CPs, CVs] = MultiPairDist(PairedTracks, PairedIndexes)

%edit 0.4 value to alter filtering of tracks
out1 = cellfun(@(x) x < 0.4, Distance, 'UniformOutput', false)

num = [];
for i = 1:length(out1);
numi = double(out1{i});
num = [num ; {numi}];
end
out2 = cellfun(@mean,num)
LT400s = out2(out2~=0)
end


function [PairedTracks, PairedIndexes] = MultiPairTracks(tracks)

PairedTracks = []
PairedIndexes = []
for FileNum = 1:length(tracks)
    try
        [PTs, Idxs] = MeanPairTracks(tracks{FileNum});
    catch
        fprintf('loop number %d failed\n',j)
    end
    
    PairedTracks = [PairedTracks ; {PTs}];
    PairedIndexes = [PairedIndexes ; {Idxs}];
end
end


function [PTs, Index] = MeanPairTracks(tracks)

MeanCell = cellfun(@mean,tracks,'UniformOutput',false);
MeanCell = vertcat(MeanCell{:});
[IDX,NND] = knnsearch(MeanCell,MeanCell,'K',2);
                
            %Use code below for matched pairs%
                
%NND = NND(:,2)
%[lIDX,lNND] = knnsearch(NND,NND,'K',2);
%lNND = lNND(:,2);
%lNND = lNND==0
%mpTracks = MeanCell(NND)
%Index = knnsearch(mpTracks,mpTracks,'K',2)
%pairTracks = tracks(NND)

            %Use code below for all pairs%
            
Index = IDX
PTs = tracks

end

function [Distance, Frames, CPs, CVs] = MultiPairDist(PairedTracks, PairedIndexes)

Dist = [];
Frame = [];
for i = 1:length(PairedTracks);
    try
        PT = PairedTracks{i};
        PI = PairedIndexes{i}(:,2);
    catch
        fprintf('loop number %d failed\n',i)
    end
    for j = 1 :length(PT)
        try
            [dist{j},frame{j}] = PairedDistCalc(PT{j},PT{PI(j)});
        catch
            fprintf('loop number %d failed\n',j)
        end
    end
    Dist = [Dist ; {dist}];
    Frame = [Frame ; {frame}];
    
end
    HCDist = horzcat(Dist{:});
    HCFrame = horzcat(Frame{:});
    MDist = cellfun(@mean,HCDist);
    [C,ia,ic] = unique(MDist,'stable');
    Distance = HCDist(ia);
    Frames = HCFrame(ia);
Distance = Distance(cellfun('length',Distance)>10);
Frames = Frames(cellfun('length',Frames)>10);

CPs = []
for k = 1:length(Distance)
cp = findchangepoints_YL(Distance{k},0.05,0.02).';
CPs = [CPs;{cp}];
end

CVs = []
changes = []
for l = 1:length(CPs)
    cv = CPs{l};
    
    for m = 1:length(cv)-1
        change = cv(m+1) - cv(m);
        changes = [changes ; change];
    end
end
CVs = [CVs ; changes];
CVs = CVs(CVs~=0)
CVs = abs(CVs)
figure;
 hold on;
 cellfun(@plot,Frames,Distance)
 cellfun(@plot,Frames,CPs.')
end

function [Dist, Frame] = PairedDistCalc(Tracks_1, Tracks_2)


Index1 =find(ismember(Tracks_1(:,1),Tracks_2(:,1)));
Index2 =find(ismember(Tracks_2(:,1),Tracks_1(:,1)));
TracksAlign = {Tracks_1(Index1,:),Tracks_2(Index2,:)};

Dist = [];
for i = 1:length(TracksAlign{1});
    dist = norm((TracksAlign{1} (i,:)) - (TracksAlign{2} (i,:)));
    Dist = [Dist ; dist];
end
Frame = TracksAlign{1}(:,1);
end
