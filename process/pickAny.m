function [train, test, Etrain, Etest, Ftrain, Ftest] = pickAny(P)

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
    
    % get current length
    V = [a1;a2;b2;c1;c2;e1;f1];
    mEPFL = length(V);
    
    listE = trainE';
    Vnew = [];
    for i=1:length(listE)
        Vnew = [Vnew;listE{i}];
    end
    V = [V;Vnew];
    m = length(V); % get new length

    % train set labels (EPFL + QMUL)    
    idx = randperm(m);
    k = idx(1:round(P*m));
    k = sort(k);
    for n = 1:length(k)       
        train{n} = {V{k(n)}, V{k(n),2}};
    end  
    
    % training set    
    lF = 0;
    lE = 0;
    for n = 1:length(k)       
        if k(n) > mEPFL
            Etrain{length(Etrain) + 1} = E{k(n) - mEPFL};
            Ftrain{length(Ftrain) + 1} = F{k(n) - mEPFL};
        elseif k(n) < mEPFL
            [E1, F1] = read(train{n}{1}, train{n}{2});
            Etrain = [Etrain, E1];
            Ftrain = [Ftrain, F1];
        end
    end 
    
 
    %% pick test set

    % testing set
    k = idx(round(P*m)+1:end);
    k = sort(k);
    
    % test set labels (EPFL + QMUL)
    l = 0;
    for n = 1:length(k)       
        test{n} = {V{k(n)}, V{k(n),2}};
    end  
    
    % testing set    
    lF = 0;
    lE = 0;
    for n = 1:length(k)       
        if k(n) > mEPFL
            Etest{length(Etest) + 1} = E{k(n) - mEPFL};
            Ftest{length(Ftest) + 1} = F{k(n) - mEPFL};
        elseif k(n) < mEPFL
            [E1, F1] = read(test{n}{1}, test{n}{2});
            Etest = [Etest, E1];
            Ftest = [Ftest, F1];
        end
    end 

end
    