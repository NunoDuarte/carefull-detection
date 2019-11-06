% for the glitch of the Command Window
%MATLAB_JAVA = '/usr/lib/jvm/java-8-openjdk/jre matlab -desktop -nosplash';
% Add this to ~/.bashrc
% export MATLAB_JAVA=/usr/lib/jvm/java-8-openjdk/jre

addpath('DataProcessing')
addpath('SEDS')
addpath('../Khansari/SEDS/SEDS_lib')
addpath('../Khansari/SEDS/GMR_lib')

% external files
% it should replace the current files in the respective library

[S, E, W] = read;

%% Plot the data

plotx = [];
ploty = [];
plotz = [];
for i=1:1

        datax = W{i}(:,1);   
        datay = W{i}(:,2);
        dataz = W{i}(:,3);       

        plotx = [plotx; datax];
        ploty = [ploty; datay];
        plotz = [plotz; dataz];

end
figure()
plot3(plotx, ploty, plotz, '.');

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
plot3(Wlpolish6(:,1), Wlpolish6(:,2), Wlpolish6(:,3), '.');

%% Segment data of elbow

El = E{1}(383:end,:);

Elreaching = El(1:100,:);
Elpolish1 = El(160:230,:);
Elpolish3 = El(326:400,:);
Elpolish4 = El(400:480,:);
Elpolish5 = El(500:570,:);
Elpolish6 = El(940:990,:);
Elpolish2 = El(1252:1320,:);

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
Slpolish1 = Sl(160:230,:);
Slpolish3 = Sl(326:400,:);
Slpolish4 = Sl(400:480,:);
Slpolish5 = Sl(500:570,:);
Slpolish6 = Sl(940:990,:);
Slpolish2 = Sl(1252:1320,:);

Slpolish{1} = Slpolish1';
Slpolish{2} = Slpolish2';
Slpolish{3} = Slpolish3';
Slpolish{4} = Slpolish4';
Slpolish{5} = Slpolish5';
Slpolish{6} = Slpolish6';


figure();
plot3(Slpolish5(:,1), Slpolish5(:,2), Slpolish5(:,3), '.');

%% Calculate the yaw angle of the elbow

a = sqrt((Slpolish5(:,1) - Elpolish5(:,1)).^2 + (Slpolish5(:,2) - Elpolish5(:,2)).^2 + (Slpolish5(:,3) - Elpolish5(:,3)).^2);
b = sqrt((Elpolish5(:,1) - Wlpolish5(:,1)).^2 + (Elpolish5(:,2) - Wlpolish5(:,2)).^2 + (Elpolish5(:,3) - Wlpolish5(:,3)).^2);
c = sqrt((Slpolish5(:,1) - Wlpolish5(:,1)).^2 + (Slpolish5(:,2) - Wlpolish5(:,2)).^2 + (Slpolish5(:,3) - Wlpolish5(:,3)).^2);

den = 2.*a.*b;
beta = acos((a.^2 + b.^2 - c.^2)./den);
beta_d = rad2deg(beta);

%%
plotting = 1;    % do you want to plot the 3D versions?
[~, F2origin, F2] = preprocessing(Wlpolish, [], plotting);

%% 2nd order dynamics
dt = 0.1;
tmp_d = diff(F2origin{1},1,2)/dt;
F2origin1{1} = [F2origin{1}; [tmp_d zeros(2,1)]];

default = 1;    % do you default parameters?

%% convert quaternion to homogeneous transformation
n = 0;
Wquat = Wlpolish6;
quat = zeros(4,length(Wquat));

for i=1:length(Wquat)
   
    if (i >= 1 && i < 2)
        quat0 = [Wquat(i, 4) Wquat(i, 5) Wquat(i, 6) Wquat(i, 7)];
        Hw0 = quat2tform(quat0);
        Hr = quat2tform([Wquat(i, 4:7)])/Hw0;
        quat(:,i) = tform2quat(Hr);
    elseif (i == 2)
        Hr = quat2tform([Wquat(i, 4:7)])/Hw0;
        quat(:,i) = tform2quat(Hr);
    else
        Hr = quat2tform([Wquat(i, 4:7)])/Hw0;
        quat(:,i) = tform2quat(Hr);
    end
end

% Convert from quaternion to euler angles
eul = quat2eul(quat', 'ZYX');

eul = radtodeg(eul);

figure();
plot3(eul(:,1), eul(:,2), eul(:,3), '.');
%% 
DSsolver(F2origin, default)

%% Plot 2D versions

ploty = [];
plotz = [];
for i=1:length(L2origin)

        datay = L2origin{i}(1,:);   
        dataz = L2origin{i}(2,:);

        ploty = [ploty, datay];
        plotz = [plotz, dataz];

end
figure()
plot(ploty, plotz, '.');

ploty = [];
plotz = [];
for i=1:length(F2origin)

        datay = F2origin{i}(1,:);   
        dataz = F2origin{i}(2,:);

        ploty = [ploty, datay];
        plotz = [plotz, dataz];

end
figure()
plot(-1*ploty, plotz, '.');
   
%% Coupling Distance
for i=1:length(L2origin)
    demosNorm{i}(1,:) = L2origin{i}(1,:) + F2origin{i}(1,:);
    demosNorm{i}(2,:) = -1*abs(L2origin{i}(2,:) - F2origin{i}(2,:));
end

default = 1;
externalCDS;%(DS, 1, [], [], []); 

%% follower or leader
default = 1;    % do you default parameters?
intDSfollower(F2origin, default)
intDSleader(L2origin, default)

%% Run the script 

scriptCDS


%% export files to .txt 
Data = load('SigmaC2.mat');
DataField = fieldnames(Data);
dlmwrite('SigmaC21.txt', Data.(DataField{1}')(:,:,3));

%% Plot Simulated Data
ploty = [];
plotz = [];
for i=1:length(CouplM)

        datay = CouplM{i}(:,1);   
        dataz = CouplM{i}(:,2);

        ploty = [ploty, datay];
        plotz = [plotz, dataz];

end
figure()
plot(ploty, plotz, '.');

for i=1:length(CouplM)
    demosNorm{i} = CouplM{i}(1:200,:)';
end

default = 1;
externalCDS;%(DS, 1, [], [], []); 

%% Plot follower Coupling 1
ploty = [];
plotz = [];
for i=1:length(dis)

        datay = dis{i}(:,2);   
        dataz = height{i}(:,2);

        ploty = [ploty, datay];
        plotz = [plotz, dataz];

end
figure()
plot(ploty, plotz, '.');

%% Plot follower Coupling 2
ploty = [];
plotz = [];
for i=1:length(CouplM)

        datay = CouplM{i}(1:200,1) - L2origin{i}(1,:)';   
        dataz = -1*(CouplM{i}(1:200,2) - L2origin{i}(2,:)');

        ploty = [ploty, datay(1:70,:)];
        plotz = [plotz, dataz(1:70,:)];

end
figure()
plot(ploty, plotz, '.');


