function [S, E, W] = read
%% reading data of leader and follower

% polishing motion
S{1} = csvread('Polish-shoulder.csv');
E{1} = csvread('Polish-elbow.csv');
W{1} = csvread('Polish-hand.csv');

% ------
% -------

% screwing motion
S{2} = csvread('Screw-shoulder.csv');
E{2} = csvread('Screw-elbow.csv');
W{2} = csvread('Screw-hand.csv');

% ------
% -------

% giving motion
S{3} = csvread('Give-shoulder.csv');
E{3} = csvread('Give-elbow.csv');
W{3} = csvread('Give-hand.csv');

% ------
% -------

% Receive motion
S{4} = csvread('Receive-shoulder.csv');
E{4} = csvread('Receive-elbow.csv');
W{4} = csvread('Receive-hand.csv');


end
