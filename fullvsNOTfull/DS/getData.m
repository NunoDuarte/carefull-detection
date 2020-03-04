function [train, test] = getData(P)

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
    
    a = {'All', 'plastic-cup'};
    b = {'All-left', 'plastic-cup'};
    
%     V = [a1;a2;a3;b1;b2;b3;b4;c1;c2];
    V = [a1;a2;a3;b1;b2;b3;c1;d1;d2;e1];
    m = length(V);
    
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

      train{1} = {a{1}, a{2}};
      
      test{1} = {b{1}, b{2}};


end