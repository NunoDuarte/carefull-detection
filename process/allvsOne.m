function [train, test] = allvsOne(ID)

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
    
    V = [a1;a2;b1;b2;c1;c2;d1;d2];
    
    Obj = {'plastic-cup', 'red-cup', 'champagne'};
    Hum = {'Kunpeng', 'Leo', 'Athanasios', 'David'};

    ObjID = find(cellfun('length',regexp(Obj,ID)) == 1);
    HumID = find(cellfun('length',regexp(Hum,ID)) == 1);
    if ObjID
        indexOut = find(cellfun('length',regexp(V,Obj{ObjID})) == 1) - length(V);
    elseif HumID
        indexOut = find(cellfun('length',regexp(V,Hum{HumID})) == 1);
    end
    % remove the One from the All
    index = find([1:length(V)]);
    index(indexOut) = [];
        
    %training set
    for n = 1:length(index)
        train{n} = {V{index(n)}, V{index(n),2}};
    end
    
    % testing set
    for n = 1:length(indexOut)
        test{n} = {V{indexOut(n)}, V{indexOut(n),2}};
    end

end