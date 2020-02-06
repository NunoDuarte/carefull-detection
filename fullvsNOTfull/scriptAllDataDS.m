% for the glitch of the Command Window
%MATLAB_JAVA = '/usr/lib/jvm/java-8-openjdk/jre matlab -desktop -nosplash';
% Add this to ~/.bashrc
% export MATLAB_JAVA=/usr/lib/jvm/java-8-openjdk/jre
clear
clc

addpath('../SEDS')
addpath('data')
addpath('DS')
addpath('../../Khansari/SEDS/SEDS_lib')
addpath('../../Khansari/SEDS/GMR_lib')

%% pick train/test set
Etrain = [];
Ftrain = [];
Etest = [];
Ftest = [];

P = 0.75;   % percentage train/test
[train, test] = getData(P);

for i = 1:length(train)
    [E, F] = read(train{i}{1}, train{i}{2});
    Etrain = [Etrain, E];
    Ftrain = [Ftrain, F];
end

for i = 1:length(test)
    [E, F] = read(test{i}{1}, test{i}{2});
    Etest = [Etest, E];
    Ftest = [Ftest, F];
end

%% Remove Non-Zeros - Empty
ploty = [];
plotx = [];
plotz = [];
for i=1:length(Etrain)

    En{i}(:,1) = nonzeros(Etrain{i}(:,2));
    En{i}(:,2) = nonzeros(Etrain{i}(:,3));
    En{i}(:,3) = nonzeros(Etrain{i}(:,4));
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
[Emp3D, Emp2Do, Emp2D] = processData(E3, plotting);

%% Generate a DS for Empty Cups
default = 1;    % do you default parameters?

for i=1:length(Emp3D)
    Norm1 = [];
    for j=1:length(Emp3D{i})
    
        norm1 = Emp3D{i}(:,j);
        Norm1 = [Norm1; norm(norm1,2)];
        Emp3Dnorm{i} = Norm1';
    end
end

genDS(Emp3Dnorm, default, [], [], [], 'E', '2D');

%% Remove Non Zeros
ploty = [];
plotx = [];
plotz = [];
for i=1:length(Ftrain)
    Fn{i}(:,1) = nonzeros(Ftrain{i}(:,2));
    Fn{i}(:,2) = nonzeros(Ftrain{i}(:,3));
    Fn{i}(:,3) = nonzeros(Ftrain{i}(:,4));
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
plotting = 0;    % do you want to plot the 3D versions?
[Full3D, Full2Do, Full2D] = processData(F3, plotting);

%% Generate a DS for Empty Cups
default = 1;    % do you default parameters?

for i=1:length(Full3D)
    Norm1 = [];
    for j=1:length(Full3D{i})
    
        norm1 = Full3D{i}(:,j);
        Norm1 = [Norm1; norm(norm1,2)];
        Full3Dnorm{i} = Norm1';
    end
end

genDS(Full3Dnorm, default, [], [], [], 'F', '2D');


