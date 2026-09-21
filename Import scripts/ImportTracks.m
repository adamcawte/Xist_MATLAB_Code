function Tracks = ImportTracks

% Select folder
folderPath = uigetdir(pwd, 'Select folder containing TrackMate track files');

if isequal(folderPath,0)
    error('No folder selected.');
end

% Find XML files
fileList = dir(fullfile(folderPath, '*.xml'));
% sort XML files alphanumeric sort by filename
fileList = natsortfiles(fileList); 

% Import XMLs
Tracks = cell(1, numel(fileList));

for k = 1:numel(fileList)
    filePath = fullfile(folderPath, fileList(k).name);
    Tracks{k} = importTrackMateTracks(filePath, true, false);

end