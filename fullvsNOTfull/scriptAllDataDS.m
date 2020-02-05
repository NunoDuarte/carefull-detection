% for the glitch of the Command Window
%MATLAB_JAVA = '/usr/lib/jvm/java-8-openjdk/jre matlab -desktop -nosplash';
% Add this to ~/.bashrc
% export MATLAB_JAVA=/usr/lib/jvm/java-8-openjdk/jre
clear
clc

addpath('../SEDS')
addpath('data')
addpath('../../Khansari/SEDS/SEDS_lib')
addpath('../../Khansari/SEDS/GMR_lib')

Eall = [];
Fall = [];
% Which Person to choose (Salman, Leo, Bernardo)
[E, F] = read('Kunpeng', 'plastic-cup');
Eall = [Eall, E];
Fall = [Fall, F];
[E, F] = read('Kunpeng', 'red-cup');
Eall = [Eall, E];
Fall = [Fall, F];
[E, F] = read('Leo', 'red-cup');
Eall = [Eall, E];
Fall = [Fall, F];
[E, F] = read('Leo', 'champagne');
Eall = [Eall, E];
Fall = [Fall, F];
[E, F] = read('Leo', 'wine-glass');
Eall = [Eall, E];
Fall = [Fall, F];
[E, F] = read('Athanasios', 'champagne');
Eall = [Eall, E];
Fall = [Fall, F];


%% Remove Non-Zeros - Empty
ploty = [];
plotx = [];
plotz = [];
for i=1:length(Eall)

    En{i}(:,1) = nonzeros(Eall{i}(:,2));
    En{i}(:,2) = nonzeros(Eall{i}(:,3));
    En{i}(:,3) = nonzeros(Eall{i}(:,4));
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
for i=1:length(Fall)
    Fn{i}(:,1) = nonzeros(Fall{i}(:,2));
    Fn{i}(:,2) = nonzeros(Fall{i}(:,3));
    Fn{i}(:,3) = nonzeros(Fall{i}(:,4));
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


