%% Plot all the data and normalize it to the same end point
%  Follower
Datamu = [0, 0];
targetSize = [1, 200];

count = 1;
for i=1:length(follower)

    ts = time{i}(1);
    tf = time{i}(end);
 
    Datamu = [Datamu(1) + follower{i}(2,end), Datamu(2) + follower{i}(3,end)];
    count= count + 1;
end

% average all the last point of the coordinates for the actions
Datamu(1) = Datamu(1)/count;
Datamu(2) = Datamu(2)/count;

DataFy = [];
DataFx = [];
Fy_new = [];
Fx_new = [];

for i=1:count-1
    
    ts = time{i}(1);
    tf = time{i}(end);
    
    a1 = follower{i}(2,:);
    a2 = follower{i}(3,:);
    
    % subtract the average of the last point to the specific last point
    d1 = follower{i}(2,end) - Datamu(1);
    d2 = follower{i}(3,end) - Datamu(2);

    % subtract the differenre (d) on the whole vector of the action
    b1 = a1 - d1;
    b2 = a2 - d2;
    
    % update the matrix DataAnew with now the new shifted data
    DataFy = [];
    DataFx = [];

    DataFy = [DataFy, b1]; 
    DataFx = [DataFx, b2];
    
    Fy_new = [];
    Fx_new = [];
    for a=1:length(DataFx)
    
        if DataFy(a) < 0
            % you don't save to the new vector
        else
            Fy_new = [Fy_new, DataFy(a)];
            Fx_new = [Fx_new, DataFx(a)];
        end
    end
    
    dataFy = imresize(Fy_new, targetSize);
    dataFx = imresize(Fx_new, targetSize);       
    
    demoF{i} = [-1*dataFy;-1*dataFx];
    
end

%% plot(DataAx,DataAy, '.');

ploty = [];
plotx = [];
for i=1:length(demoF)

        datay = demoF{i}(1,:);
        datax = demoF{i}(3,:);   
        
        ploty = [ploty, datay];
        plotx = [plotx, datax];
    
end

figure()
plot(ploty, plotx, '.');

