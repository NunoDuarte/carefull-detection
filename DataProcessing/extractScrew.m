%% Segment data of wrist

Wl = W{2}(383:end,:);

Wlreaching = Wl(1:100,:);
Wlscrew1 = Wl(320:430,:);
Wlscrew2 = Wl(530:640,:);
Wlscrew3 = Wl(640:750,:);
Wlscrew4 = Wl(880:970,:);
Wlscrew5 = Wl(970:1080,:);
Wlscrew6 = Wl(1195:1285,:);
Wlscrew7 = Wl(1285:1390,:);
Wlscrew8 = Wl(1480:1600,:);
Wlscrew9 = Wl(1610:1710,:);
Wlscrew10 = Wl(1720:1820,:);

Wlscrew{1} = Wlscrew1';
Wlscrew{2} = Wlscrew2';
Wlscrew{3} = Wlscrew3';
Wlscrew{4} = Wlscrew4';
Wlscrew{5} = Wlscrew5';
Wlscrew{6} = Wlscrew6';
Wlscrew{7} = Wlscrew7';
Wlscrew{8} = Wlscrew8';
Wlscrew{9} = Wlscrew9';
Wlscrew{10} = Wlscrew10';

figure()
plot3(Wlscrew3(:,1), Wlscrew3(:,2), Wlscrew3(:,3), '.');

%% Segment data of elbow

El = E{2}(383:end,:);

Elreaching = El(1:100,:);
Elscrew1 = El(320:430,:);
Elscrew2 = El(530:640,:);
Elscrew3 = El(640:750,:);
Elscrew4 = El(880:970,:);
Elscrew5 = El(970:1080,:);
Elscrew6 = El(1195:1285,:);
Elscrew7 = El(1285:1390,:);
Elscrew8 = El(1480:1600,:);
Elscrew9 = El(1610:1710,:);
Elscrew10 = El(1720:1820,:);

Elscrew{1} = Elscrew1';
Elscrew{2} = Elscrew2';
Elscrew{3} = Elscrew3';
Elscrew{4} = Elscrew4';
Elscrew{5} = Elscrew5';
Elscrew{6} = Elscrew6';
Elscrew{7} = Elscrew7';
Elscrew{8} = Elscrew8';
Elscrew{9} = Elscrew9';
Elscrew{10} = Elscrew10';

figure()
plot3(Elscrew1(:,1), Elscrew1(:,2), Elscrew1(:,3), '.');

%% Segment data of Shoulder

Sl = S{2}(383:end,:);

Slreaching = Sl(1:100,:);
Slscrew1 = Sl(320:430,:);
Slscrew2 = Sl(530:640,:);
Slscrew3 = Sl(640:750,:);
Slscrew4 = Sl(880:970,:);
Slscrew5 = Sl(970:1080,:);
Slscrew6 = Sl(1195:1285,:);
Slscrew7 = Sl(1285:1390,:);
Slscrew8 = Sl(1480:1600,:);
Slscrew9 = Sl(1610:1710,:);
Slscrew10 = Sl(1720:1820,:);

Slscrew{1} = Slscrew1';
Slscrew{2} = Slscrew2';
Slscrew{3} = Slscrew3';
Slscrew{4} = Slscrew4';
Slscrew{5} = Slscrew5';
Slscrew{6} = Slscrew6';
Slscrew{7} = Slscrew7';
Slscrew{8} = Slscrew8';
Slscrew{9} = Slscrew9';
Slscrew{10} = Slscrew10';

figure();
plot3(Slscrew1(:,1), Slscrew1(:,2), Slscrew1(:,3), '.');

