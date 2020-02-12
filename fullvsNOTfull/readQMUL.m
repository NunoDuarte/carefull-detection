files = dir('/home/nuno/Documents/MATLAB/PhD/armMotionDS/fullvsNOTfull/data/QMUL/*.csv');
fullpaths = fullfile({files.folder}, {files.name});

% Empty Cups
fu0 = strfind(fullpaths, 'fu0');
index = find(~cellfun(@isempty,fu0));

for i=1:length(index)

    E{i} = csvread(fullpaths{index(i)});
    
end

% Full Cups
fu2 = strfind(fullpaths, 'fu2');
index = find(~cellfun(@isempty,fu2));

for i=1:length(index)

    F{i} = csvread(fullpaths{index(i)});
    
end    