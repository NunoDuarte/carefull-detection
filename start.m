% for the glitch of the Command Window
%MATLAB_JAVA = '/usr/lib/jvm/java-8-openjdk/jre matlab -desktop -nosplash';
% Add this to ~/.bashrc
% export MATLAB_JAVA=/usr/lib/jvm/java-8-openjdk/jre

addpath('DataProcessing')
addpath('SEDS')
addpath('data')
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

%% Calculate the yaw angle of the elbow

for i=1:length(Slpolish)
    a = sqrt((Slpolish{i}(1,:) - Elpolish{i}(1,:)).^2 + (Slpolish{i}(2,:) - Elpolish{i}(2,:)).^2 + (Slpolish{i}(3,:) - Elpolish{i}(3,:)).^2);
    b = sqrt((Elpolish{i}(1,:) - Wlpolish{i}(1,:)).^2 + (Elpolish{i}(2,:) - Wlpolish{i}(2,:)).^2 + (Elpolish{i}(3,:) - Wlpolish{i}(3,:)).^2);
    c = sqrt((Slpolish{i}(1,:) - Wlpolish{i}(1,:)).^2 + (Slpolish{i}(2,:) - Wlpolish{i}(2,:)).^2 + (Slpolish{i}(3,:) - Wlpolish{i}(3,:)).^2);

    den = 2.*a.*b;
    beta{i} = acos((a.^2 + b.^2 - c.^2)./den);
    beta_d{i} = rad2deg(beta{i});
end
%%
Wlpolish{1} = Wlpolish5';
% Wlpolish{2} = Wlpolish2';
% Wlpolish{3} = Wlpolish3';
% Wlpolish{4} = Wlpolish4';
% Wlpolish{5} = Wlpolish5';
% Wlpolish{6} = Wlpolish6';

plotting = 1;    % do you want to plot the 3D versions?
[~, F2origin, F2] = preprocessing(Wlpolish, [], plotting);

%% coupling wrist position with yaw angle of elbow

for a=1:length(Slpolish)
    normW = sqrt(Slpolish{a}(3,:).^2 + Slpolish{a}(2,:).^2 + Slpolish{a}(1,:).^2);
    demosNorm{a} = [normW; beta_d{a}];
end

%% old - remove later
normW = sqrt(Slpolish5(:,3).^2);

demosNorm{1} = [normW'; beta_d'];

%% 2nd order dynamics
dt = 0.1;
tmp_d = diff(F2origin{1},1,2)/dt;
F2origin1{1} = [F2origin{1}; [tmp_d zeros(2,1)]];

default = 1;    % do you default parameters?

%% convert quaternion to homogeneous transformation
n = 0;
Wquat = Wlpolish5;
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

eul = rad2deg(eul);

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


%% reaching 
default = 1;    % do you default parameters?

plotting = 1;    % do you want to plot the 3D versions?
[~, F2origin, F2] = preprocessing(Reaching, [], plotting);
DSsolver(F2origin, default)

%% handover

Handover{1} = Sreceive';
[~, F2origin, F2] = preprocessing(Handover, [], plotting);

% parameters for the DS
sim = 1; % simulate
K = 5;
options.tol_mat_bias = 10^-5; % A very small positive scalar to avoid
options.display = 1;          % An option to control whether the algorithm
options.tol_stopping=10^-10;  % A small positive scalar defining the stoppping
options.max_iter = 1000;
options.objective = 'likelihood'; 

DSsolver(F2origin, 0, options, K, sim);



