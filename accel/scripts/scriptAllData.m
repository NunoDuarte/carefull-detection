function [Etrain, Ftrain, train, test, Etest, Ftest] = scriptAllData(P)

    %% train EPFL - test EPFL
    % P = 0.10;   % percentage train/test
    [train, test] = getData(P);
    Etrain = [];
    Ftrain = [];
    Etest = [];
    Ftest = [];
    for i = 1:length(train)
        [E, F] = read(train{i}{1}, train{i}{2});
        Etrain = [Etrain, E];
        Ftrain = [Ftrain, F];
    end

    for i = 1:length(test)
        [E, F] = read(test{i}{1}, test{i}{2});
        Etest = [Etest, E];
        Ftest = [Ftest, F];
    end

    % [Etrain, Etest, Ftrain, Ftest] = getDataQMUL(P);
    % train = Etrain;
    % test = Etest;
    
%     %% Both - train EPFL - test QMUL
%     [train, test, Etrain, Etest, Ftrain, Ftest] = pickData(P);
    
%     %% Both - train EPFL - test IST
%     [train, test, Etrain, Etest, Ftrain, Ftest] = pickDataIST(P);
end