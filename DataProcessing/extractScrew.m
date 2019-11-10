%% Segment data of wrist

Wl = W{2}(383:end,:);

Wlreaching = Wl(1:100,:);
Wlscrew2 = Wl(320:430,:);
Wlscrew3 = Wl(530:640,:);
Wlscrew4 = Wl(640:750,:);
Wlscrew5 = Wl(880:970,:);
Wlscrew6 = Wl(970:1080,:);
Wlscrew7 = Wl(1195:1285,:);
Wlscrew8 = Wl(1285:1390,:);
Wlscrew9 = Wl(1480:1600,:);
Wlscrew10 = Wl(1610:1710,:);
Wlscrew11 = Wl(1720:1820,:);

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
Wlscrew{11} = Wlscrew11';

figure()
plot3(Wlscrew1(:,1), Wlscrew1(:,2), Wlscrew1(:,3), '.');

%% Segment data of elbow

El = E{2}(383:end,:);

Elreaching = El(1:100,:);
Elscrew2 = El(320:430,:);
Elscrew3 = El(530:640,:);
Elscrew4 = El(640:750,:);
Elscrew5 = El(880:970,:);
Elscrew6 = El(970:1080,:);
Elscrew7 = El(1195:1285,:);
Elscrew8 = El(1285:1390,:);
Elscrew9 = El(1480:1600,:);
Elscrew10 = El(1610:1710,:);
Elscrew11 = El(1720:1820,:);

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
Elscrew{11} = Elscrew11';

figure()
plot3(Elpolish5(:,1), Elpolish5(:,2), Elpolish5(:,3), '.');

%% Segment data of Shoulder

Sl = S{2}(383:end,:);

Slreaching = Sl(1:100,:);
Slscrew2 = Sl(320:430,:);
Slscrew3 = Sl(530:640,:);
Slscrew4 = Sl(640:750,:);
Slscrew5 = Sl(880:970,:);
Slscrew6 = Sl(970:1080,:);
Slscrew7 = Sl(1195:1285,:);
Slscrew8 = Sl(1285:1390,:);
Slscrew9 = Sl(1480:1600,:);
Slscrew10 = Sl(1610:1710,:);
Slscrew11 = Sl(1720:1820,:);

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
Slscrew{11} = Slscrew11';

figure();
plot3(Slpolish5(:,1), Slpolish5(:,2), Slpolish5(:,3), '.');

