%% Segment data of wrist

Wgiving = W{3}(518:750,:);


figure()
plot3(Wl(:,1), Wl(:,2), Wl(:,3), '.');

%% Segment data of elbow

El = E{3}(518:750,:);


figure()
plot3(El(:,1), El(:,2), El(:,3), '.');

%% Segment data of Shoulder

Sl = S{3}(518:750,:);

figure();
plot3(Sl(:,1), Sl(:,2), Sl(:,3), '.');

