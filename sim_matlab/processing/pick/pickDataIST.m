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
       
    %% pick train
    Etrain = [];
    Ftrain = [];
    Etest = [];
    Ftest = [];
%% For ALL data vs IST        

    V = [a1;a2;a3;b1;b2;b3;b4;c1;c2;d1;d2;];
    m = length(V);
    
    idx = randperm(m);
    
    %training set labels
    k = idx(1:round(P*m));
    for n = 1:length(k)
        train{n} = {V{k(n)}, V{k(n),2}};
    end
    
    % sort to Etrain and Ftrain
    for i = 1:length(train)
        [E1, F1] = read(train{i}{1}, train{i}{2});
        Etrain = [Etrain, E1];
        Ftrain = [Ftrain, F1];
    end 

%% Picking manually
%     % pick just what you need
%     Vtrain = [a3;b4];
%     
%     %training set
%     for n = 1:length(Vtrain)
%         train{n} = {Vtrain{n}, Vtrain{n,2}};
%     end
%     
%     % sort to Etrain and Ftrain
%     for i = 1:length(train)
%         [E1, F1] = read(train{i}{1}, train{i}{2});
%         Etrain = [Etrain, E1];
%         Ftrain = [Ftrain, F1];
%     end 
 
    %% pick test set
%     % testing set labels
%     k = idx(1:round(P*m));
%     l = 0;
%     for n = 1:length(k)
%         test{n} = {testE{k(n)}{1}, testE{k(n)}{2}};
%         l = l+1;
%     end
    
    test{1} = {'IST', 'empty - full'};

    % sort to Etest
    [E1, ~] = readIST('empty');
    Etest = [Etest, E1];
    
    % sort to Ftest
    [~, F1] = readIST('full');
    Ftest = [Ftest, F1];

end
    