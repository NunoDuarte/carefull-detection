% for the glitch of the Command Window
%MATLAB_JAVA = '/usr/lib/jvm/java-8-openjdk/jre matlab -desktop -nosplash';
% Add this to ~/.bashrc
% export MATLAB_JAVA=/usr/lib/jvm/java-8-openjdk/jre
clear
clc

addpath('../SEDS')
addpath('DS')
addpath('data')
addpath('../../Khansari/SEDS/SEDS_lib')
addpath('../../Khansari/SEDS/GMR_lib')

% Which Person to choose (Salman, Leo, Bernardo)
[E, F] = read('All', 'champagne');

%% Remove Non-Zeros - Empty
ploty = [];
plotx = [];
plotz = [];
for i=1:length(E)

    En{i}(:,1) = nonzeros(E{i}(:,2));
    En{i}(:,2) = nonzeros(E{i}(:,3));
    En{i}(:,3) = nonzeros(E{i}(:,4));
    E3{i}(1,:) = En{i}(:,1)';
    E3{i}(2,:) = En{i}(:,2)';
    E3{i}(3,:) = En{i}(:,3)';         
    plotx = [plotx, E3{i}(1,:)];
    ploty = [ploty, E3{i}(2,:)];
    plotz = [plotz, E3{i}(3,:)];
    E3{i} = round(E3{i},4);
end
figure()
plot3(ploty, plotx, plotz, '.');


%%
plotting = 1;    % do you want to plot the 3D versions?
Emp3D = processData(E3, plotting);

%% Generate a DS for Empty Cups
default = 1;    % default parameters?

for i=1:length(Emp3D)
    xT = Emp3D{i}(:,end);
    Norm1 = [];
    for j=1:length(Emp3D{i})
        dis = xT - Emp3D{i}(:,j);
        disN = norm(dis,2);
        Norm1 = [Norm1; disN];
        Emp3Dnorm{i} = Norm1';
    end
end
genDS(Emp3Dnorm, default, [], [], [], 'E', '2D');

%% Remove Non Zeros
ploty = [];
plotx = [];
plotz = [];
for i=1:length(F)
    Fn{i}(:,1) = nonzeros(F{i}(:,2));
    Fn{i}(:,2) = nonzeros(F{i}(:,3));
    Fn{i}(:,3) = nonzeros(F{i}(:,4));
    F3{i}(1,:) = Fn{i}(:,1)';
    F3{i}(2,:) = Fn{i}(:,2)';
    F3{i}(3,:) = Fn{i}(:,3)'; 
    
    F3{i} = round(F3{i},4);
    
    plotx = [plotx, F3{i}(1,:)];
    ploty = [ploty, F3{i}(2,:)];
    plotz = [plotz, F3{i}(3,:)];
end
figure()
plot3(ploty, plotx, plotz, '.');


%% 
plotting = 1;    % do you want to plot the 3D versions?
Full3D = processData(F3, plotting);

%% Generate a DS for Empty Cups
default = 1;    % default parameters?

for i=1:length(Full3D)
    xT = Full3D{i}(:,end);
    Norm1 = [];
    for j=1:length(Full3D{i})
        dis = xT - Full3D{i}(:,j);
        disN = norm(dis);
        Norm1 = [Norm1; disN];
        Full3Dnorm{i} = Norm1';
    end
end
genDS(Full3Dnorm, default, [], [], [], 'F', '2D');


