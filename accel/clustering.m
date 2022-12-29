
[train] = getDataAll();
Etrain = [];
Ftrain = [];
for i = 1:length(train)
    [E, F] = read(train{i}{1}, train{i}{2});
    Etrain = [Etrain, E];
    Ftrain = [Ftrain, F];
end

clear E3
clear En
clear F3
clear Fn

% plotting?
plotting = 0;

%% Remove Non-Zeros - Empty

if plotting
    [plotx, ploty, plotz] = deal([]);
end

for i=1:length(Etrain)
    En{i} = Etrain{i}(any(Etrain{i},2),2:4);          % remove only full rows of 0s
    En{i} = En{i}(all(~isnan(En{i}),2),:);  % remove rows of NANs    
    E3{i}(1,:) = En{i}(:,1)';
    E3{i}(2,:) = En{i}(:,2)';
    E3{i}(3,:) = En{i}(:,3)';       
    E3{i} = round(E3{i},4);
    
    if plotting
        plotx = [plotx, E3{i}(1,:)];
        ploty = [ploty, E3{i}(2,:)];
        plotz = [plotz, E3{i}(3,:)];             
    end

end

if plotting
    figure;
    plot3(ploty, plotx, plotz, '.');
end

%% computing the first and second time derivative

dt = 1/120;
for i=1:length(E3)
    
    xT = E3{i}(:,end);
    Norm1 = [];
    for j=1:length(E3{i})
        dis = xT - E3{i}(:,j);
        disN = norm(dis,2);
        Norm1 = [Norm1; disN];

        % normalized over distance
        Norm2 = Norm1/max(Norm1);
    end
    Emp3Dnorm{i} = Norm2';
    tmp_d{i} = abs(diff(Norm2,1)/dt);
    tmp_2d{i} = abs(diff(tmp_d{i},1)/dt);
end

for i=1:length(E3)

    d3tmp_dE{i} = tmp_d{i}';
    d3tmp_2dE{i} = tmp_2d{i}';
    
    % remove outlier
    ThresholdToDelete = d3tmp_2dE{i} > 200;
    d3tmp_2dE{i}(ThresholdToDelete) = [];
    
    Emp3Dnorm{i}(ThresholdToDelete) = [];
    d3tmp_dE{i}(ThresholdToDelete) = [];
end

[plotx, ploty, plotz] = deal([]);
for i=1:length(E3)
    if plotting
        plotz = [plotz, Emp3Dnorm{i}(1,:)];     
        plotx = [plotx, [d3tmp_dE{i}(1,:), NaN]];
        ploty = [ploty, [d3tmp_2dE{i}(1,:), NaN, NaN]];         
    end
end
if plotting
    figure(4);
    plot3(plotx, ploty, plotz, '.');
end
hold on;

%% Remove Non Zeros - Full

if plotting
    [plotx, ploty, plotz] = deal([]);
end

for i=1:length(Ftrain)
    Fn{i} = Ftrain{i}(any(Ftrain{i},2),2:4);          % remove only full rows of 0s
    Fn{i} = Fn{i}(all(~isnan(Fn{i}),2),:);  % remove rows of NANs    
    F3{i}(1,:) = Fn{i}(:,1)';
    F3{i}(2,:) = Fn{i}(:,2)';
    F3{i}(3,:) = Fn{i}(:,3)'; 
    
    F3{i} = round(F3{i},4);
    
    if plotting
        plotx = [plotx, F3{i}(1,:)];
        ploty = [ploty, F3{i}(2,:)];
        plotz = [plotz, F3{i}(3,:)];             
    end

end

if plotting
    figure();
    plot3(ploty, plotx, plotz, '.');
end

%% computing the first and second time derivative

clear tmp_d
clear tmp_2d

dt = 1/120;
for i=1:length(F3)
    
    xT = F3{i}(:,end);
    Norm1 = [];
    for j=1:length(F3{i})
        dis = xT - F3{i}(:,j);
        disN = norm(dis,2);
        Norm1 = [Norm1; disN];

        % normalized over distance
        Norm2 = Norm1/max(Norm1);
    end
    Fmp3Dnorm{i} = Norm2';
    tmp_d{i} = abs(diff(Norm2,1)/dt);
    tmp_2d{i} = abs(diff(tmp_d{i},1)/dt);
end

for i=1:length(F3)

    d3tmp_dF{i} = tmp_d{i}';
    d3tmp_2dF{i} = tmp_2d{i}';

    % remove outlier    
    ThresholdToDelete = d3tmp_2dF{i} > 200;
    d3tmp_2dF{i}(ThresholdToDelete) = [];
    
    Fmp3Dnorm{i}(ThresholdToDelete) = [];
    d3tmp_dF{i}(ThresholdToDelete) = [];
    
end

[plotx, ploty, plotz] = deal([]);
for i=1:length(F3)
    if plotting
        plotz = [plotz, Fmp3Dnorm{i}(1,:)];     
        plotx = [plotx, [d3tmp_dF{i}(1,:),NaN]];
        ploty = [ploty, [d3tmp_2dF{i}(1,:), NaN,NaN]];         
    end
end
if plotting
    figure(4);
    plot3(plotx, ploty, plotz, '.');
end


%% Plot the max velocity and max acceleration

for i=1:length(E3)
   
    [max_dE(i), id_dE(i)] = max(d3tmp_dE{i});
    id_E(i) = Emp3Dnorm{i}(id_dE(i));
    max_ddE(i) = max(d3tmp_2dE{i});
end    
for i=1:length(F3)
    [max_dF(i), id_dF(i)] = max(d3tmp_dF{i});
    id_F(i) = Fmp3Dnorm{i}(id_dF(i));
    max_ddF(i) = max(d3tmp_2dF{i});
end  


figure();
hold on;
plot(max_dE, id_E, 'ro','MarkerSize',12);
plot(max_dF, id_F, 'bo','MarkerSize',12);

%% Perform unsupervised Clustering 
% K-means (dependent on data quantity)

X = [[max_dE;id_E],[max_dF;id_F]]';

[idx,C] = kmeans(X,2);

% plot

figure;
plot(X(idx==1,1),X(idx==1,2),'b.','MarkerSize',12)
hold on
plot(X(idx==2,1),X(idx==2,2),'r.','MarkerSize',12)
% hold on
% plot(X(idx==3,1),X(idx==3,2),'g.','MarkerSize',12)
plot(C(:,1),C(:,2),'kx',...
     'MarkerSize',15,'LineWidth',3) 
legend('Cluster 1','Cluster 2','Centroids',...
       'Location','NW')
title 'Cluster Assignments and Centroids'
hold off

%% Perform unsupervised Clustering 
% DBScan 

X = [[max_dE;id_E],[max_dF;id_F]]';


idx = dbscan(X,0.05,5);

gscatter(X(:,1),X(:,2),idx);
title('DBSCAN Using Euclidean Distance Metric')



