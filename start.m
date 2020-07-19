% for the glitch of the Command Window
%MATLAB_JAVA = '/usr/lib/jvm/java-8-openjdk/jre matlab -desktop -nosplash';
% Add this to ~/.bashrc
% export MATLAB_JAVA=/usr/lib/jvm/java-8-openjdk/jre
clear
clc

addpath('../SEDS')
addpath('data')
addpath('DS')
addpath('beliefDS')
addpath('../../Khansari/SEDS/SEDS_lib')
addpath('../../Khansari/SEDS/GMR_lib')

%% 

K = [6, 7, 8];

for i=1:4
    for k = 1:length(K)

       scriptAllDataDS(K(k))
       close all;
    end
end