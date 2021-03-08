function [train, test, Etrain, Etest, Ftrain, Ftest] = pickData(P)

    % EPFL Dataset

    a1 = {'Kunpeng', 'plastic-cup'};
    a2 = {'Kunpeng', 'red-cup'};
    a3 = {'Kunpeng', 'wine-glass'};
    b1 = {'Leo', 'plastic-cup'};
    b2 = {'Leo', 'red-cup'};
    b3 = {'Leo', 'champagne'};
    b4 = {'Leo', 'wine-glass'};
    c1 = {'Athanasios', 'red-cup'};
    c2 = {'Athanasios', 'champagne'};
    d1 = {'David', 'plastic-cup'};
    d2 = {'David', 'red-cup'};
    e1 = {'Salman', 'red-mug'};
    f1 = {'Bernardo', 'bowl'};
    
    % QMUL dataset
    files = dir('/home/nuno/Documents/MATLAB/PhD/fullvsNOTfull/data/QMUL/1/*.csv');
    fullpaths = fullfile({files.folder}, {files.name});

    % Empty Cups
    fu0 = strfind(fullpaths, 'fu0');
    indexE = find(~cellfun(@isempty,fu0));
    for i=1:length(indexE)

        E{i} = csvread(fullpaths{indexE(i)});
        testE{i} = {'1-fu0', fullpaths{indexE(i)}(end-7:end-4)};
    end
    % Full Cups
    fu2 = strfind(fullpaths, 'fi3fu2');
    indexF = find(~cellfun(@isempty,fu2));
    for i=1:length(indexF)

        F{i} = csvread(fullpaths{indexF(i)});
        testF{i} = {'1-fi3fu2', fullpaths{indexE(i)}(end-7:end-4)};
    end        
    
    files = dir('/home/nuno/Documents/MATLAB/PhD/fullvsNOTfull/data/QMUL/2/*.csv');
    fullpaths = fullfile({files.folder}, {files.name});

    % Empty Cups
    fu0 = strfind(fullpaths, 'fu0');
    indexE = find(~cellfun(@isempty,fu0));
    for i=1:length(indexE)

        E{i+4} = csvread(fullpaths{indexE(i)});
        testE{i+4} = {'2-fu0', fullpaths{indexE(i)}(end-7:end-4)};
    end
    % Full Cups
    fu2 = strfind(fullpaths, 'fi3fu2');
    indexF = find(~cellfun(@isempty,fu2));
    for i=1:length(indexF)

        F{i+4} = csvread(fullpaths{indexF(i)});
        testF{i+4} = {'2-fi3fu2', fullpaths{indexE(i)}(end-7:end-4)};
    end      
    
    files = dir('/home/nuno/Documents/MATLAB/PhD/fullvsNOTfull/data/QMUL/4/*.csv');
    fullpaths = fullfile({files.folder}, {files.name});

    % Empty Cups
    fu0 = strfind(fullpaths, 'fu0');
    indexE = find(~cellfun(@isempty,fu0));
    for i=1:length(indexE)

        E{i+8} = csvread(fullpaths{indexE(i)});
        testE{i+8} = {'4-fu0b1', fullpaths{indexE(i)}(end-7:end-4)};
    end
    % Full Cups
    fu2 = strfind(fullpaths, 'fi3fu2');
    indexF = find(~cellfun(@isempty,fu2));
    for i=1:length(indexF)

        F{i+8} = csvread(fullpaths{indexF(i)});
        testF{i+8} = {'4-fi3fu2b1', fullpaths{indexE(i)}(end-7:end-4)};
    end
    
    files = dir('/home/nuno/Documents/MATLAB/PhD/fullvsNOTfull/data/QMUL/5/*.csv');
    fullpaths = fullfile({files.folder}, {files.name});    
    
    % Empty Cups
    fu0 = strfind(fullpaths, 'fu0');
    indexE = find(~cellfun(@isempty,fu0));
    for i=1:length(indexE)

        E{i+12} = csvread(fullpaths{indexE(i)});
        testE{i+12} = {'5-fu0', fullpaths{indexE(i)}(end-7:end-4)};
    end
    % Full Cups
    fu2 = strfind(fullpaths, 'fi3fu2');
    indexF = find(~cellfun(@isempty,fu2));
    for i=1:length(indexF)-1

        F{i+12} = csvread(fullpaths{indexF(i)});
        testF{i+12} = {'5-fi3fu2', fullpaths{indexE(i)}(end-7:end-4)};
    end
       
    %% pick train
    Etrain = [];
    Ftrain = [];
    Etest = [];
    Ftest = [];
        
%     m = length(E);
%     idx = randperm(m);
% 
%     V = [a1;a2;b2;c1;c2;e1;f1];
%     m = length(V);
%     
%     idx = randperm(m);
%     
%     %training set labels
%     k = idx(1:round(P*m));
%     for n = 1:length(k)
%         train{n} = {V{k(n)}, V{k(n),2}};
%     end
%     
%     % sort to Etrain and Ftrain
%     for i = 1:length(train)
%         [E1, F1] = read(train{i}{1}, train{i}{2});
%         Etrain = [Etrain, E1];
%         Ftrain = [Ftrain, F1];
%     end 
    
    % pick just what you need
    Vtrain = [a2;b2;c1;d2];
    
    %training set
    for n = 1:length(Vtrain)
        train{n} = {Vtrain{n}, Vtrain{n,2}};
    end
    
    % sort to Etrain and Ftrain
    for i = 1:length(train)
        [E1, F1] = read(train{i}{1}, train{i}{2});
        Etrain = [Etrain, E1];
        Ftrain = [Ftrain, F1];
    end 
 
    %% pick test set
    P = 1; % pick ALL
    
    m = length(E);
    idx = randperm(m);

    % testing set labels
    k = idx(1:round(P*m));
    l = 0;
    for n = 1:length(k)
        test{n} = {testE{k(n)}{1}, testE{k(n)}{2}};
        l = l+1;
    end
    
    % testing set
    k = idx(1:round(P*m));
    for n = 1:length(k)
        Etest{n} = E{n};
    end
    
    m = length(F);
    idx = randperm(m);

    % testing set labels (continue)
    k = idx(1:round(P*m));
    for n = 1:length(k)
        test{n+l} = {testF{k(n)}{1}, testF{k(n)}{2}};
    end
    
    % testing set
    k = idx(1:round(P*m));
    for n = 1:length(k)
        Ftest{n} = F{n};
    end

end
    