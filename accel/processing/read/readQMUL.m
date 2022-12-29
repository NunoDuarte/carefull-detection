files = dir('/home/nuno/Documents/MATLAB/PhD/accele_careful/data/QMUL/2/*.csv');
fullpaths = fullfile({files.folder}, {files.name});

% Empty Cups
fu0 = strfind(fullpaths, 'fu0');
indexE = find(~cellfun(@isempty,fu0));

for i=1:length(indexE)

    E{i} = csvread(fullpaths{indexE(i)});
    
end

% Full Cups
fu2 = strfind(fullpaths, 'fi3fu2');
indexF = find(~cellfun(@isempty,fu2));

for i=1:length(indexF)

    F{i} = csvread(fullpaths{indexF(i)});
    
end    