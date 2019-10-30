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

%% Segment data

Wl = W{1}(383:end,:);

Wlreaching = Wl(1:100,:);
Wlpolish1 = Wl(160:230,:);
Wlpolish3 = Wl(326:400,:);
Wlpolish4 = Wl(400:480,:);
Wlpolish5 = Wl(500:570,:);
Wlpolish6 = Wl(940:990,:);
Wlpolish2 = Wl(1252:1320,:);

Wlpolish{1} = Wlpolish1';
Wlpolish{2} = Wlpolish2';
Wlpolish{3} = Wlpolish3';
Wlpolish{4} = Wlpolish4';
Wlpolish{5} = Wlpolish5';
Wlpolish{6} = Wlpolish6';



figure()
plot3(Wlpolish2(:,1), Wlpolish2(:,2), Wlpolish2(:,3), '.');

%%
plotting = 1;    % do you want to plot the 3D versions?
[~, F2origin, F2] = preprocessing(Wlpolish, [], plotting);

%%

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


