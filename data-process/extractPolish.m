%% Segment data of wrist

Wl = W{1}(383:end,:);

Wlreaching = Wl(1:100,:);
Wlpolish1 = Wl(172:230,:);
Wlpolish3 = Wl(326:400,:);
Wlpolish4 = Wl(400:490,:);
Wlpolish5 = Wl(503:570,:);
Wlpolish6 = Wl(940:990,:);
Wlpolish2 = Wl(1260:1320,:);

Wlpolish{1} = Wlpolish1';
Wlpolish{2} = Wlpolish2';
Wlpolish{3} = Wlpolish3';
Wlpolish{4} = Wlpolish4';
Wlpolish{5} = Wlpolish5';
Wlpolish{6} = Wlpolish6';

figure()
plot3(Wlpolish5(:,1), Wlpolish5(:,2), Wlpolish5(:,3), '.');

%% Segment data of elbow

El = E{1}(383:end,:);

Elreaching = El(1:100,:);
Elpolish1 = El(172:230,:);
Elpolish3 = El(326:400,:);
Elpolish4 = El(400:490,:);
Elpolish5 = El(503:570,:);
Elpolish6 = El(940:990,:);
Elpolish2 = El(1260:1320,:);

Elpolish{1} = Elpolish1';
Elpolish{2} = Elpolish2';
Elpolish{3} = Elpolish3';
Elpolish{4} = Elpolish4';
Elpolish{5} = Elpolish5';
Elpolish{6} = Elpolish6';

figure()
plot3(Elpolish5(:,1), Elpolish5(:,2), Elpolish5(:,3), '.');

%% Segment data of Shoulder

Sl = S{1}(383:end,:);

Slreaching = Sl(1:100,:);
Slpolish1 = Sl(172:230,:);
Slpolish3 = Sl(326:400,:);
Slpolish4 = Sl(400:490,:);
Slpolish5 = Sl(503:570,:);
Slpolish6 = Sl(940:990,:);
Slpolish2 = Sl(1260:1320,:);

Slpolish{1} = Slpolish1';
Slpolish{2} = Slpolish2';
Slpolish{3} = Slpolish3';
Slpolish{4} = Slpolish4';
Slpolish{5} = Slpolish5';
Slpolish{6} = Slpolish6';

figure();
plot3(Slreaching(:,1), Slreaching(:,2), Slreaching(:,3), '.');

