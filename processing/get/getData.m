function [train, test] = getData(P)

    a1 = {'Kunpeng', 'plastic-cup'};
    a2 = {'Kunpeng', 'red-cup'};
    a3 = {'Kunpeng', 'wine-glass'};
    b1 = {'Leo', 'plastic-cup'};
    b2 = {'Leo', 'red-cup'};
    b3 = {'Leo', 'champagne'};
    b4 = {'Leo', 'wine-glass'};
    b5 = {'Leo', 'red-mug'};
    c1 = {'Athanasios', 'red-cup'};
    c2 = {'Athanasios', 'champagne'};
    d1 = {'David', 'plastic-cup'};
    d2 = {'David', 'red-cup'};
    e1 = {'Salman', 'red-mug'};
    f1 = {'Bernardo', 'bowl'};
    
%     a = {'All', 'plastic-cup'};
%     b = {'Kunpeng', 'plastic-cup'};
    
%     V = [b3;c2];
%     m = length(V);
%     
%     idx = randperm(m);
%     
%     %training set
%     k = idx(1:round(P*m));
%     for n = 1:length(k)
%         train{n} = {V{k(n)}, V{k(n),2}};
%     end
%     
%     % testing set
%     k = idx(round(P*m)+1:end);
%     for n = 1:length(k)
%         test{n} = {V{k(n)}, V{k(n),2}};
%     end
    
    Vtest = [b1;b2;b4];
    Vtrain = [c1;c2];
    %training set
    for n = 1:length(Vtrain)
        train{n} = {Vtrain{n}, Vtrain{n,2}};
    end
    
    % testing set
    for n = 1:length(Vtest)
        test{n} = {Vtest{n}, Vtest{n,2}};
    end  
    

end