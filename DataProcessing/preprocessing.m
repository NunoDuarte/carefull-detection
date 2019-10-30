function [F3, F2origin, F2] = preprocessing(follower, time, varargin)
if nargin > 2
    plotting = varargin{1};
else
    plotting = 1;
end

%% Plot all the data and normalize it to the same end point
% Follower

%% filter the data from the follower
Datamu = [0, 0, 0];
targetSize = [1, 200];

count = 1;
total = 1;
for i=1:length(follower)
 
    if ~isempty(follower{i})
        [maxX, idX] = max(follower{i}(1,:));
        Datamu = [Datamu(1) + follower{i}(1,idX), Datamu(2) + follower{i}(2,idX), Datamu(3) + follower{i}(3,idX)];
        total= total + 1;
    end
    count= count + 1;
end

% average all the last point of the coordinates for the actions
Datamu(1) = Datamu(1)/total
Datamu(2) = Datamu(2)/total
Datamu(3) = Datamu(3)/total

DataFy = [];
DataFx = [];
DataFz = [];
Fy_new = [];
Fx_new = [];
Fz_new = [];

countF = 1;
for i=1:count-1
    
    if ~isempty(follower{i})
        [maxX, idX] = max(follower{i}(1,:));
        a1 = follower{i}(1,:);
        a2 = follower{i}(2,:);
        a3 = follower{i}(3,:); 

        % If you want to visualize all actions with the reference in end-goal
        % center the final point to be (0, 0, 0)
        c1 = a1 - follower{i}(1,idX);
        c2 = a2 - follower{i}(2,idX);
        c3 = a3 - follower{i}(3,idX);

        % subtract the average of the last point to the specific last point
        d1 = follower{i}(1,idX) - Datamu(1);
        d2 = follower{i}(2,idX) - Datamu(2);
        d3 = follower{i}(3,idX) - Datamu(3);

        % If you want to visualize all actions with end-goal in average end-goal
        % subtract the differenre (d) on the whole vector of the action
        b1 = a1 - d1;
        b2 = a2 - d2;
        b3 = a3 - d3;
        
        % end point be the origin for all actions (HRI experiments of
        % coupling)
        e1 = follower{i}(1,:) - follower{i}(1,idX);
        e2 = follower{i}(2,:) - follower{i}(2,idX);
        e3 = follower{i}(3,:) - follower{i}(3,idX);

        % update the matrix DataF with now the new data 
        % choose c or b
        DataFx = b1; 
        DataFy = b2;
        DataFz = b3;

        Fy_new = [];
        Fx_new = [];
        Fz_new = [];    
        for a=1:length(DataFx)
            Fx_new = [Fx_new, DataFx(a)];
            Fy_new = [Fy_new, DataFy(a)];
            Fz_new = [Fz_new, DataFz(a)];            

        end

        dataFy = imresize(Fy_new, targetSize);
        dataFx = imresize(Fx_new, targetSize);       
        dataFz = imresize(Fz_new, targetSize);      

        F3{countF} = [dataFx; dataFy; dataFz];
        F3origin{countF} = [e1; e2; e3];        
        countF= countF + 1;
    end
end

countF = 1;
for i=1:count-1
    
    if ~isempty(follower{i})

        a1 = follower{i}(1,:);
        a2 = follower{i}(2,:);
        a3 = follower{i}(3,:);    

        % reduce dimension
        b1 = sqrt(a1.^2 + a2.^2);
        b2 = a3;
        
        % subtract the average of the last point to the specific last point
        d1 = b1(end) - sqrt(Datamu(1)^2 + Datamu(2)^2);
        d2 = follower{i}(3,end) - Datamu(3);        

        % If you want to visualize all actions with end-goal in average end-goal
        % subtract the differenre (d) on the whole vector of the action
        c1 = b1 - d1;
        c2 = b2 - d2;
        
        % end point be the origin for all actions (HRI experiments of
        % coupling)
        e1 = c1 - c1(end);
        e2 = c2 - c2(end);

        % data for F2origin
        DataFy = e1; 
        DataFz = e2;

        Fy_new = [];
        Fz_new = [];    
        for a=1:length(DataFy)
            Fy_new = [Fy_new, DataFy(a)];
            Fz_new = [Fz_new, DataFz(a)];            

        end
  
        dataFy = imresize(Fy_new, targetSize); 
        dataFz = imresize(Fz_new, targetSize);      
        F2origin{countF} = [dataFy; dataFz];

        % data for F2
        DataFy = c1; 
        DataFz = c2;

        Fy_new = [];
        Fz_new = [];    
        for a=1:length(DataFy)
            Fy_new = [Fy_new, DataFy(a)];
            Fz_new = [Fz_new, DataFz(a)];            
        end
  
        dataFy = imresize(Fy_new, targetSize); 
        dataFz = imresize(Fz_new, targetSize);  
        F2{countF} = [dataFy; dataFz];

        countF= countF + 1;
    end 
end


%% plot(DataAx,DataAy, '.');
if plotting
    ploty = [];
    plotx = [];
    plotz = [];
    for i=1:length(F3)


            datax = F3{i}(1,:);
            datay = F3{i}(2,:);   
            dataz = F3{i}(3,:);

            plotx = [plotx, datax];
            ploty = [ploty, datay];
            plotz = [plotz, dataz];

    end

    figure()
    plot3(-1*ploty, plotx, plotz, '.');
    %plot(-1*plotx, plotz, '.');
end
end