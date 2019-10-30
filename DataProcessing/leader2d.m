%% Plot all the data and normalize it to the same end point
%  Leader
Datamu = [0, 0];
targetSize = [1, 200];

count = 1;
for i=1:length(leader)

    ts = time{i}(1);
    tf = time{i}(end);
 
    Datamu = [Datamu(1) + leader{i}(2,end), Datamu(2) + leader{i}(3,end)];
    count= count + 1;
end

% average all the last point of the coordinates for the actions
Datamu(1) = Datamu(1)/count;
Datamu(2) = Datamu(2)/count;

DataLy = [];
DataLx = [];
Ly_new = [];
Lx_new = [];

for i=1:count-1
    
    ts = time{i}(1);
    tf = time{i}(end);
    
    a1 = leader{i}(2,:);
    a2 = leader{i}(3,:);
    
    % subtract the average of the last point to the specific last point
    d1 = leader{i}(2,end) - Datamu(1);
    d2 = leader{i}(3,end) - Datamu(2);

    % subtract the differenre (d) on the whole vector of the action
    b1 = a1 - d1;
    b2 = a2 - d2;
    
    % update the matrix DataAnew with now the new shifted data
    DataLy = [];
    DataLx = [];

    DataLy = [DataLy, b1]; 
    DataLx = [DataLx, b2];
    
    Ly_new = [];
    Lx_new = [];
    for a=1:length(DataLx)
    
        if DataLy(a) < 0
            % you don't save to the new vector
        else
            Ly_new = [Ly_new, DataLy(a)];
            Lx_new = [Lx_new, DataLx(a)];
        end
    end
    
    dataLy = imresize(Ly_new, targetSize);
    dataLx = imresize(Lx_new, targetSize);       
    
    demoL{i} = [-1*dataLy;-1*dataLx];
    
end

%% plot(DataAx,DataAy, '.');

ploty = [];
plotx = [];
for i=1:length(demoL)

        datay = demoL{i}(1,:);
        datax = demoL{i}(2,:);   
        
        ploty = [ploty, datay];
        plotx = [plotx, datax];
    
end

figure()
plot(plotx, ploty, '.');

