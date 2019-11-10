%% Segment data of wrist

Wl = W{3}(383:end,:);

Wlreaching = Wl(1:100,:);
Wlscrew2 = Wl(320:430,:);

Wlscrew{1} = Wlscrew1';

figure()
plot3(Wlscrew1(:,1), Wlscrew1(:,2), Wlscrew1(:,3), '.');

%% Segment data of elbow

El = E{3}(383:end,:);

Elreaching = El(1:100,:);
Elscrew2 = El(320:430,:);

Elscrew{1} = Elscrew1';

figure()
plot3(Elpolish5(:,1), Elpolish5(:,2), Elpolish5(:,3), '.');

%% Segment data of Shoulder

Sl = S{3}(383:end,:);

Slreaching = Sl(1:100,:);
Slscrew2 = Sl(320:430,:);

Slscrew{1} = Slscrew1';


figure();
plot3(Slpolish5(:,1), Slpolish5(:,2), Slpolish5(:,3), '.');

