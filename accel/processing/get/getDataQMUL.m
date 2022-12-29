function [Etrain, Etest, Ftrain, Ftest] = getDataQMUL(P)

    files = dir('/home/nuno/Documents/MATLAB/PhD/armMotionDS/fullvsNOTfull/data/QMUL/1/*.csv');
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
    
    files = dir('/home/nuno/Documents/MATLAB/PhD/armMotionDS/fullvsNOTfull/data/QMUL/2/*.csv');
    fullpaths = fullfile({files.folder}, {files.name});

    % Empty Cups
    fu0 = strfind(fullpaths, 'fu0');
    indexE = find(~cellfun(@isempty,fu0));
    for i=1:length(indexE)

        E{i+4} = csvread(fullpaths{indexE(i)});

    end
    % Full Cups
    fu2 = strfind(fullpaths, 'fi3fu2');
    indexF = find(~cellfun(@isempty,fu2));
    for i=1:length(indexF)

        F{i+4} = csvread(fullpaths{indexF(i)});

    end      
    
    
    files = dir('/home/nuno/Documents/MATLAB/PhD/armMotionDS/fullvsNOTfull/data/QMUL/4/*.csv');
    fullpaths = fullfile({files.folder}, {files.name});

    % Empty Cups
    fu0 = strfind(fullpaths, 'fu0');
    indexE = find(~cellfun(@isempty,fu0));
    for i=1:length(indexE)

        E{i+8} = csvread(fullpaths{indexE(i)});

    end
    % Full Cups
    fu2 = strfind(fullpaths, 'fi3fu2');
    indexF = find(~cellfun(@isempty,fu2));
    for i=1:length(indexF)

        F{i+8} = csvread(fullpaths{indexF(i)});

    end
    
    files = dir('/home/nuno/Documents/MATLAB/PhD/armMotionDS/fullvsNOTfull/data/QMUL/5/*.csv');
    fullpaths = fullfile({files.folder}, {files.name});    
    
    % Empty Cups
    fu0 = strfind(fullpaths, 'fu0');
    indexE = find(~cellfun(@isempty,fu0));
    for i=1:length(indexE)

        E{i+12} = csvread(fullpaths{indexE(i)});

    end
    % Full Cups
    fu2 = strfind(fullpaths, 'fi3fu2');
    indexF = find(~cellfun(@isempty,fu2));
    for i=1:length(indexF)-1

        F{i+12} = csvread(fullpaths{indexF(i)});

    end
       
    %% pick train/test set
    Etrain = [];
    Ftrain = [];
    Etest = [];
    Ftest = [];
        
    m = length(E);
    idx = randperm(m);
    
    %training set
    k = idx(1:round(P*m));
    for n = 1:length(k)
        Etrain{n} = E{n};
    end
    
    % testing set
    k = idx(round(P*m)+1:end);
    for n = 1:length(k)
        Etest{n} = E{n};
    end
    
    m = length(F);
    idx = randperm(m);
    
    %training set
    k = idx(1:round(P*m));
    for n = 1:length(k)
        Ftrain{n} = F{n};
    end
    
    % testing set
    k = idx(round(P*m)+1:end);
    for n = 1:length(k)
        Ftest{n} = F{n};
    end    

end