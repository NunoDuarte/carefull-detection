% for the glitch of the Command Window
%MATLAB_JAVA = '/usr/lib/jvm/java-8-openjdk/jre matlab -desktop -nosplash';
% Add this to ~/.bashrc
% export MATLAB_JAVA=/usr/lib/jvm/java-8-openjdk/jre
clear
clc

addpath('data')
addpath('ds') 
addpath('processing')
addpath('belief')
addpath('scripts')
addpath('../../software/Khansari/SEDS/SEDS_lib')
addpath('../../software/Khansari/SEDS/GMR_lib')

%% 

K = [3, 4, 5, 6, 7, 8];
P = [0.6, 0.7, 0.8, 0.65, 0.75, 0.85]; % percentage

for i=1:length(P)
    for k = 1:length(K)

       scriptAllDataDS(K(k), P(i), ' ', ' ');
       close all;
    end
end

% K = [3, 4, 5, 6, 7, 8];
% 
% type = {'All', 'One'};
% 
% Obj = {'plastic-cup', 'red-cup', 'champagne'};
% Hum = {'Kunpeng', 'Leo', 'Athanasios', 'David'};
% L = [Obj, Hum];
% 
% for t=1:2
%     for i=1:length(L)
%         for k = 1:length(K)
% 
%            scriptAllDataDS(K(k), type{t}, L{i})
%            close all;
%         end
%     end
% end