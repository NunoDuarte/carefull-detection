% for the glitch of the Command Window
%MATLAB_JAVA = '/usr/lib/jvm/java-8-openjdk/jre matlab -desktop -nosplash';
% Add this to ~/.bashrc
% export MATLAB_JAVA=/usr/lib/jvm/java-8-openjdk/jre
clear
clc

addpath('data')
addpath('ds') 
addpath(genpath('processing/'))
addpath('belief')
addpath('scripts')
addpath('../../software/Khansari/SEDS/SEDS_lib')
addpath('../../software/Khansari/SEDS/GMR_lib')

%% 

K = [2, 3, 4, 5, 6, 7];
P = [0.5, 0.6, 0.65, 0.7, 0.75, 0.8]; % percentage

% save the plots?
plots = 0;


for i=1:length(P)
    
    % get the data randomized
    [Etrain, Ftrain, train, test, Etest, Ftest] = scriptAllData(P(i), ' ', ' ');
    
    for k = 1:length(K)
       scriptDS(K(k), Etrain, Ftrain, train, test, Etest, Ftest, plots);
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