function [train] = getDataAll()

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
    
    x = {'All', 'plastic-cup'};
    
%     a = {'All', 'plastic-cup'};
%     b = {'Kunpeng', 'plastic-cup'};
    
    V = [a1;a2;a3;b1;b2;b3;b4;b5;c1;c2;d1;d2;e1];
    m = length(V);
    
    idx = randperm(m);
    
    %training set
    k = idx(1:round(m));
    for n = 1:length(k)
        train{n} = {V{k(n)}, V{k(n),2}};
    end

      

end