function [Etrain, Ftrain, train, test, Etest, Ftest] = scriptAllData(P, type, ID)

    % P = 0.80;   % percentage train/test
    %% EPFL 
    [train, test] = getData(P);

    [Etrain, Ftrain, Etest, Ftest] = deal([]);

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

    %% QMUL
    % [Etrain, Etest, Ftrain, Ftest] = getDataQMUL(P);
    % train = Etrain;
    % test = Etest;

    %% Both - train EPFL
    % [train, test, Etrain, Etest, Ftrain, Ftest] = pickData(P);

    %% Both - train QMUL
    % [train, test, Etrain, Etest, Ftrain, Ftest] = pickData_test(P);

    %% Both - train EPFL+QMUL
    % [train, test, Etrain, Etest, Ftrain, Ftest] = pickAny(P);

    %% One vs All or All vs One

    % if type == 'All'
    %     [train, test] = allvsOne(ID);
    %     
    %     [Etrain, Ftrain, Etest, Ftest] = deal([]);
    %     
    %     for i = 1:length(train)
    %         [E, F] = read(train{i}{1}, train{i}{2});
    %         Etrain = [Etrain, E];
    %         Ftrain = [Ftrain, F];
    %     end
    %     
    %     for i = 1:length(test)
    %         [E, F] = read(test{i}{1}, test{i}{2});
    %         Etest = [Etest, E];
    %         Ftest = [Ftest, F];
    %     end
    %     
    % elseif type == 'One'
    %     [train, test] = onevsAll(ID);
    %     
    %     [Etrain, Ftrain, Etest, Ftest] = deal([]);
    %     
    %     for i = 1:length(train)
    %         [E, F] = read(train{i}{1}, train{i}{2});
    %         Etrain = [Etrain, E];
    %         Ftrain = [Ftrain, F];
    %     end
    %     
    %     for i = 1:length(test)
    %         [E, F] = read(test{i}{1}, test{i}{2});
    %         Etest = [Etest, E];
    %         Ftest = [Ftest, F];
    %     end    
    % end

end
