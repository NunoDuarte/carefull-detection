function [train, test, Etrain, Etest, Ftrain, Ftest] = pickData_test(P)

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
    
    files = dir('/home/nuno/Documents/MATLAB/fullvsNOTfull/data/QMUL/1/*.csv');
    fullpaths = fullfile({files.folder}, {files.name});

    % Empty Cups
    fu0 = strfind(fullpaths, 'fu0b1');
    indexE = find(~cellfun(@isempty,fu0));
    for i=1:length(indexE)

        E{i} = csvread(fullpaths{indexE(i)});
        trainE{i} = {'1-fu0b1', fullpaths{indexE(i)}(end-7:end-4)};
    end
    % Full Cups
    fu2 = strfind(fullpaths, 'fi3fu2b1');
    indexF = find(~cellfun(@isempty,fu2));
    for i=1:length(indexF)

        F{i} = csvread(fullpaths{indexF(i)});
        trainF{i} = {'1-fi3fu2b1', fullpaths{indexE(i)}(end-7:end-4)};
    end   
    
%     files = dir('/home/nuno/Documents/MATLAB/fullvsNOTfull/data/QMUL/2/*.csv');
%     fullpaths = fullfile({files.folder}, {files.name});
% 
%     % Empty Cups
%     fu0 = strfind(fullpaths, 'fu0');
%     indexE = find(~cellfun(@isempty,fu0));
%     for i=1:length(indexE)
% 
%         E{i+4} = csvread(fullpaths{indexE(i)});
%         testE{i+4} = {'2-fu0', fullpaths{indexE(i)}(end-7:end-4)};
%     end
%     % Full Cups
%     fu2 = strfind(fullpaths, 'fi3fu2');
%     indexF = find(~cellfun(@isempty,fu2));
%     for i=1:length(indexF)
% 
%         F{i+4} = csvread(fullpaths{indexF(i)});
%         testF{i+4} = {'2-fi3fu2', fullpaths{indexE(i)}(end-7:end-4)};
%     end      
    
    files = dir('/home/nuno/Documents/MATLAB/fullvsNOTfull/data/QMUL/4/*.csv');
    fullpaths = fullfile({files.folder}, {files.name});

    % Empty Cups
    fu0 = strfind(fullpaths, 'fu0b1');
    indexE = find(~cellfun(@isempty,fu0));
    for i=1:length(indexE)

        E{i+2} = csvread(fullpaths{indexE(i)});
        trainE{i+2} = {'4-fu0b1', fullpaths{indexE(i)}(end-7:end-4)};
    end
    % Full Cups
    fu2 = strfind(fullpaths, 'fi3fu2b1');
    indexF = find(~cellfun(@isempty,fu2));
    for i=1:length(indexF)

        F{i+2} = csvread(fullpaths{indexF(i)});
        trainF{i+2} = {'4-fi3fu2b1', fullpaths{indexE(i)}(end-7:end-4)};
    end
    
%     files = dir('/home/nuno/Documents/MATLAB/fullvsNOTfull/data/QMUL/5/*.csv');
%     fullpaths = fullfile({files.folder}, {files.name});    
%     
%     % Empty Cups
%     fu0 = strfind(fullpaths, 'fu0');
%     indexE = find(~cellfun(@isempty,fu0));
%     for i=1:length(indexE)
% 
%         E{i+12} = csvread(fullpaths{indexE(i)});
%         testE{i+12} = {'5-fu0', fullpaths{indexE(i)}(end-7:end-4)};
%     end
%     % Full Cups
%     fu2 = strfind(fullpaths, 'fi3fu2');
%     indexF = find(~cellfun(@isempty,fu2));
%     for i=1:length(indexF)-1
% 
%         F{i+12} = csvread(fullpaths{indexF(i)});
%         testF{i+12} = {'5-fi3fu2', fullpaths{indexE(i)}(end-7:end-4)};
%     end
       
    %% pick train (All)
    Etrain = [];
    Ftrain = [];
    Etest = [];
    Ftest = [];

    m = length(E);
    idx = randperm(m);

    % train set labels
    k = idx(1:round(P*m));
    l = 0;
    for n = 1:length(k)
        train{n} = {trainE{k(n)}{1}, trainE{k(n)}{2}};
        l = l+1;
    end
    
    % training set
    k = idx(1:round(P*m));
    for n = 1:length(k)
        Etrain{n} = E{n};
    end
    
    m = length(F);
    idx = randperm(m);

    % train set labels (continue)
    k = idx(1:round(P*m));
    for n = 1:length(k)
        train{n+l} = {trainF{k(n)}{1}, trainF{k(n)}{2}};
    end
    
    % train set
    k = idx(1:round(P*m));
    for n = 1:length(k)
        Ftrain{n} = F{n};
    end
 
    %% pick test set

    V = [a1;a2;b2;c1;c2;e1;f1];
    m = length(V);
    
    idx = randperm(m);
    
    %training set labels
    k = idx(1:round(P*m));
    for n = 1:length(k)
        test{n} = {V{k(n)}, V{k(n),2}};
    end
    
    % sort to Etrain and Ftrain
    for i = 1:length(test)
        [E1, F1] = read(test{i}{1}, test{i}{2});
        Etest = [Etest, E1];
        Ftest = [Ftest, F1];
    end 

end
    