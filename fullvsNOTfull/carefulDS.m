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
[E, F] = read('All');

%% Remove Non-Zeros - Empty

for i=1:length(E)

    En{i}(:,1) = nonzeros(E{i}(:,2));
    En{i}(:,2) = nonzeros(E{i}(:,3));
    En{i}(:,3) = nonzeros(E{i}(:,4));
    E3{i}(1,:) = En{i}(:,1)';
    E3{i}(2,:) = En{i}(:,2)';
    E3{i}(3,:) = En{i}(:,3)';         

end

%%

plotting = 1;    % do you want to plot the 3D versions?
[Emp3D, Emp2Do, Emp2D] = processData(E3, plotting);

%% Generate a DS for Empty Cups
default = 1;    % do you default parameters?

% for i=1:length(Emp3D)
%     Norm1 = [];
%     for j=1:length(Emp3D{i})
%     
%         norm1 = Emp3D{i}(:,j);
%         Norm1 = [Norm1; norm(norm1,2)];
%         Emp3Dnorm{i} = Norm1';
%     end
% end

%% 
genDS(Emp3D, default, [], [], [], 'E')

%% Remove Non Zeros

for i=1:length(F)
    Fn{i}(:,1) = nonzeros(F{i}(:,2));
    Fn{i}(:,2) = nonzeros(F{i}(:,3));
    Fn{i}(:,3) = nonzeros(F{i}(:,4));
    F3{i}(1,:) = Fn{i}(:,1)';
    F3{i}(2,:) = Fn{i}(:,2)';
    F3{i}(3,:) = Fn{i}(:,3)'; 
end

%% 
plotting = 0;    % do you want to plot the 3D versions?
[Full3D, Full2Dorigin, Full2D] = processData(F3, plotting);

%% Generate a DS for Empty Cups
default = 1;    % do you default parameters?

% for i=1:length(Full3D)
%     Norm1 = [];
%     for j=1:length(Full3D{i})
%     
%         norm1 = Full3D{i}(:,j);
%         Norm1 = [Norm1; norm(norm1,2)];
%         Full3Dnorm{i} = Norm1';
%     end
% end

genDS(Full3D, default, [], [], [], 'F')


