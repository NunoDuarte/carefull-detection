files = dir('/home/nuno/Documents/MATLAB/PhD/armMotionDS/fullvsNOTfull/data/QMUL/1/*.csv');
fullpaths = fullfile({files.folder}, {files.name});

% Empty Cups
fu0 = strfind(fullpaths, 'fu0');
indexE = find(~cellfun(@isempty,fu0));

for i=1:length(indexE)

    E{i} = csvread(fullpaths{indexE(i)});
    
end

% Full Cups
fu2 = strfind(fullpaths, 'fu2');
indexF = find(~cellfun(@isempty,fu2));

for i=1:length(indexF)

    F{i} = csvread(fullpaths{indexF(i)});
    
end    