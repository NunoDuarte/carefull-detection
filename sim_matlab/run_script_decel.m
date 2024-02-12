% for the glitch of the Command Window
%MATLAB_JAVA = '/usr/lib/jvm/java-8-openjdk/jre matlab -desktop -nosplash';
% Add this to ~/.bashrc
% export MATLAB_JAVA=/usr/lib/jvm/java-8-openjdk/jre
clear
clc

addpath('data')
addpath(genpath('processing/'))
addpath('belief')
addpath('../../software/Khansari/SEDS/SEDS_lib')
addpath('../../software/Khansari/SEDS/GMR_lib')

%% 

K = [1, 2, 3];
P = [1];
%P = [0.3, 0.5, 0.6]; % percentage
Epsilon = [50, 100, 300, 500];

% save the plots?
plots = 0;

for e=1:length(Epsilon)
    epsi = Epsilon(e);
    for i=1:length(P)

        % get the data randomized
        [Etrain, Ftrain, train, test, Etest, Ftest] = data_script(P(i), ' ', ' ');

        for k = 1:length(K)
           ds_script(K(k), Etrain, Ftrain, train, test, Etest, Ftest, epsi, plots);
           close all;

        end
    end
end

