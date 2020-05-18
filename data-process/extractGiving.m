%% Segment data of wrist

Wgiving = W{3}(518:750,:);


figure()
plot3(Wgiving(:,1), Wgiving(:,2), Wgiving(:,3), '.');

%% Segment data of elbow

Egiving = E{3}(518:750,:);


figure()
plot3(Egiving(:,1), Egiving(:,2), Egiving(:,3), '.');

%% Segment data of Shoulder

Sgiving = S{3}(300:2000,:);

figure();
plot3(Sgiving(:,1), Sgiving(:,2), Sgiving(:,3), '.');

