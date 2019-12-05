% for the glitch of the Command Window
%MATLAB_JAVA = '/usr/lib/jvm/java-8-openjdk/jre matlab -desktop -nosplash';
% Add this to ~/.bashrc
% export MATLAB_JAVA=/usr/lib/jvm/java-8-openjdk/jre

addpath('DataProcessing')
addpath('../SEDS')
addpath('data')
addpath('../../Khansari/SEDS/SEDS_lib')
addpath('../../Khansari/SEDS/GMR_lib')

% external files
% it should replace the current files in the respective library

[E, F] = read;

%% Plot the data - EMPTY

plotx = [];
ploty = [];
plotz = [];
for i=1:3

        En{i}(:,1) = nonzeros(E{i}(:,2));
        En{i}(:,2) = nonzeros(E{i}(:,3));
        En{i}(:,3) = nonzeros(E{i}(:,4));
        
        datax = En{i}(:,1);   
        datay = En{i}(:,2);
        dataz = En{i}(:,3);       

        plotx = [plotx; datax];
        ploty = [ploty; datay];
        plotz = [plotz; dataz];

end
figure()
plot3(plotx, ploty, plotz, '.');

%%

for i=1:3
    E3{i}(1,:) = En{i}(:,1)';
    E3{i}(2,:) = En{i}(:,2)';
    E3{i}(3,:) = En{i}(:,3)'; 
    
end
plotting = 1;    % do you want to plot the 3D versions?
[~, F2origin, F2] = follower3d(E3, [], plotting);
% [~, L2origin, L2] = leader3d(leader, time, plotting);

%% Plot 2D versions

ploty = [];
plotz = [];
for i=1:length(F2)

        datay = F2{i}(1,:);   
        dataz = F2{i}(2,:);

        ploty = [ploty, datay];
        plotz = [plotz, dataz];

end

figure()
plot(-1*ploty, plotz, '.');

%% follower or leader
default = 1;    % do you default parameters?
intDSfollower(F2origin, default)

%% Plot the data - FULL

plotx = [];
ploty = [];
plotz = [];
for i=1:4

        Fn{i}(:,1) = nonzeros(F{i}(:,2));
        Fn{i}(:,2) = nonzeros(F{i}(:,3));
        Fn{i}(:,3) = nonzeros(F{i}(:,4));
        datax = Fn{i}(:,1);   
        datay = Fn{i}(:,2);
        dataz = Fn{i}(:,3);       

        plotx = [plotx; datax];
        ploty = [ploty; datay];
        plotz = [plotz; dataz];

end
figure()
plot3(plotx, ploty, plotz, '.');

%%

for i=1:3
    F3{i}(1,:) = Fn{i}(:,1)';
    F3{i}(2,:) = Fn{i}(:,2)';
    F3{i}(3,:) = Fn{i}(:,3)'; 
    
end
plotting = 1;    % do you want to plot the 3D versions?
[~, L2origin, L2] = follower3d(F3, [], plotting);
% [~, L2origin, L2] = leader3d(leader, time, plotting);

%% Plot 2D versions

ploty = [];
plotz = [];
for i=1:length(L2)

        datay = L2{i}(1,:);   
        dataz = L2{i}(2,:);

        ploty = [ploty, datay];
        plotz = [plotz, dataz];

end

figure()
plot(-1*ploty, plotz, '.');

%% follower or leader
default = 1;    % do you default parameters?
intDSfollower(L2origin, default)


