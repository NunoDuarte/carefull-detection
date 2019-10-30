function [L3, L2origin, L2] = leader3d(leader, time, varargin)
if nargin > 2
    plotting = varargin{1};
else
    plotting = 1;
end

%% Plot all the data and normalize it to the same end point
%  Leader
Datamu = [0, 0, 0];
targetSize = [1, 200];

count = 1;
total = 1;
for i=1:length(leader)
 
    if ~isempty(leader{i})
        Datamu = [Datamu(1) + leader{i}(1,end), Datamu(2) + leader{i}(2,end), Datamu(3) + leader{i}(3,end)];
        total= total + 1;
    end
    count= count + 1;
end

% average all the last point of the coordinates for the actions
Datamu(1) = Datamu(1)/total;
Datamu(2) = Datamu(2)/total;
Datamu(3) = Datamu(3)/total;

DataLx = [];
DataLy = [];
DataLz = [];
Lx_new = [];
Ly_new = [];
Lz_new = [];

countL = 1;
for i=1:count-1
    
    if ~isempty(leader{i})
        ts = time{i}(1);
        tf = time{i}(end);

        a1 = leader{i}(1,:);
        a2 = leader{i}(2,:);
        a3 = leader{i}(3,:);    

        % If you want to visualize all actions with the reference in end-goal
        % center the final point to be (0, 0, 0)
        c1 = a1 - leader{i}(1,end);
        c2 = a2 - leader{i}(2,end);
        c3 = a3 - leader{i}(3,end);

        % subtract the average of the last point to the specific last point
        d1 = leader{i}(1,end) - Datamu(1);
        d2 = leader{i}(2,end) - Datamu(2);
        d3 = leader{i}(3,end) - Datamu(3);

        % If you want to visualize all actions with end-goal in average end-goal
        % subtract the differenre (d) on the whole vector of the action
        b1 = a1 - d1;
        b2 = a2 - d2;
        b3 = a3 - d3;
        
        % end point be the origin for all actions (HRI experiments of
        % coupling)
        e1 = leader{i}(1,:) - leader{i}(1,end);
        e2 = leader{i}(2,:) - leader{i}(2,end);
        e3 = leader{i}(3,:) - leader{i}(3,end);

        % update the matrix DataL with new data
        % choose c or b
        DataLx = b1; 
        DataLy = b2;
        DataLz = b3;

        Lx_new = [];
        Ly_new = [];
        Lz_new = [];    
        for a=1:length(DataLx)
            Lx_new = [Lx_new, DataLx(a)];
            Ly_new = [Ly_new, DataLy(a)];
            Lz_new = [Lz_new, DataLz(a)];            
        end

        dataLx = imresize(Lx_new, targetSize);          
        dataLy = imresize(Ly_new, targetSize); 
        dataLz = imresize(Lz_new, targetSize);      

        L3{countL} = [dataLx; dataLy; dataLz];
        L3origin{countL} = [e1; e2; e3];
        countL= countL + 1;
    end 
end

countL = 1;
for i=1:count-1
    
    if ~isempty(leader{i})
        ts = time{i}(1);
        tf = time{i}(end);

        a1 = leader{i}(1,:);
        a2 = leader{i}(2,:);
        a3 = leader{i}(3,:);    

        % reduce dimension
        b1 = sqrt(a1.^2 + a2.^2);
        b2 = a3;
        
        % subtract the average of the last point to the specific last point
        d1 = b1(end) - sqrt(Datamu(1)^2 + Datamu(2)^2);
        d2 = leader{i}(3,end) - Datamu(3);        

        % If you want to visualize all actions with end-goal in average end-goal
        % subtract the differenre (d) on the whole vector of the action
        c1 = b1 - d1;
        c2 = b2 - d2;
        
        % end point be the origin for all actions (HRI experiments of
        % coupling)
        e1 = c1 - c1(end);
        e2 = c2 - c2(end);

        % update the matrix DataL with new data
        % choose c or b
        DataLy = e1; 
        DataLz = e2;

        Ly_new = [];
        Lz_new = [];    
        for a=1:length(DataLy)
            Ly_new = [Ly_new, DataLy(a)];
            Lz_new = [Lz_new, DataLz(a)];            

        end
  
        dataLy = imresize(Ly_new, targetSize); 
        dataLz = imresize(Lz_new, targetSize);      
        L2origin{countL} = [dataLy; dataLz];

        % update the matrix DataL with new data
        % choose c or b
        DataLy = c1; 
        DataLz = c2;

        Ly_new = [];
        Lz_new = [];    
        for a=1:length(DataLy)
            Ly_new = [Ly_new, DataLy(a)];
            Lz_new = [Lz_new, DataLz(a)];            
        end
  
        dataLy = imresize(Ly_new, targetSize); 
        dataLz = imresize(Lz_new, targetSize);  
        L2{countL} = [dataLy; dataLz];

        countL= countL + 1;
    end 
end


%% plot(DataAx,DataAy, '.');
if plotting
    plotx = [];
    ploty = [];
    plotz = [];
    for i=1:length(L3)

            datax = L3{i}(1,:);
            datay = L3{i}(2,:);   
            dataz = L3{i}(3,:);

            plotx = [plotx, datax];
            ploty = [ploty, datay];
            plotz = [plotz, dataz];
    end
    
    figure()
    plot3(ploty, plotx, plotz, '.');
   
end
end
%plot(plotx, plotz, '.');