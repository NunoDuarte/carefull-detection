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

% Which Person to choose (Salman, Leo, Bernardo)
[E, F] = read('Salman');

%% Plot the data - EMPTY

plotx = [];
ploty = [];
plotz = [];
for i=1:length(E)

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
[Emp3D, Emp2Do, Emp2D] = processData(E3, plotting);

%% Generate a DS for Empty Cups
default = 1;    % do you default parameters?
genDS(Emp3D, default)

%% Plot the data - FULL

plotx = [];
ploty = [];
plotz = [];
for i=1:length(F)

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

for i=1:length(F)
    F3{i}(1,:) = Fn{i}(:,1)';
    F3{i}(2,:) = Fn{i}(:,2)';
    F3{i}(3,:) = Fn{i}(:,3)'; 
    
end
plotting = 0;    % do you want to plot the 3D versions?
[Full3D, Full2Dorigin, Full2D] = processData(F3, plotting);

%% Generate a DS for full Cups
default = 1;    % do you default parameters?
genDS(Full3D, default)


