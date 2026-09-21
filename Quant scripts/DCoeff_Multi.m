function [D, D_cat, A, A_cat] = DCoeff_Multi(Tracks)

% Both Dcoeffs (D) and Alpha factors (A) are computed for each cell as a cell array. Then they are concatenated
% as D_cat and A_cat to compile all values together 

for FileNum = 1:length(Tracks)
    Trks = Tracks{FileNum};
    [D{FileNum}, A{FileNum}] = DcoeffCalc(Trks);
end

D_cat = vertcat(D{:})
A_cat = vertcat(A{:})

end



function [Dcoeff, Alpha]  = DcoeffCalc(tracks)
    
        % frame rate of acquisition in sec - e.g. 75ms - change as needed
    framerate = 0.075;
    DriftCorr = msdanalyzer(2, 'µm', 'frame');
    DriftCorr = DriftCorr.addAll(tracks);
         
        % Corrects Drift in cloud - remove percentage symbol if required
        
    %DriftCorr = DriftCorr.computeDrift('velocity');
        
        %Plots mean drift of trajectories combined - will plot each cell
        
    %figure
    %DriftCorr.plotDrift
    %DriftCorr.labelPlotTracks
    
        % Computes and fits MSDs for first 25% of the curve - alter 0.25 if required
        
    DriftCorr = DriftCorr.computeMSD;
    DriftCorr = DriftCorr.fitMSD (0.25);
    
        % Removal of bad fits - limit set to an r2 value of 0.6
         
    r2fits = DriftCorr.lfit.r2fit;
    Dcoeff = DriftCorr.lfit.a;
    R2LIMIT = 0.6;
    bad_fits = r2fits < R2LIMIT;
    fprintf('Keeping %d fits (R2 > %.2f).\n', sum(~bad_fits), R2LIMIT); 
    Dcoeff(bad_fits) = [];
    Dcoeff = Dcoeff/framerate;
    
        % Computes LogLogFit for first 50% of curve
        
    DriftCorr = DriftCorr.fitLogLogMSD (0.5);
    
        % Removal of bad loglog fits - limit set to r2 of 0.6
        
    r2logfits = DriftCorr.loglogfit.r2fit;
    Alpha = DriftCorr.loglogfit.alpha;
    R2LIMIT = 0.6;
    bad_logfits = r2logfits < R2LIMIT;
    fprintf('Keeping %d fits (R2 > %.2f).\n', sum(~bad_logfits), R2LIMIT);
    Alpha(bad_logfits) = [];
    
end