% Read data from should - elbow - wrist - hand (cyberglove)

% polishing motion
S = csvread('Polish-shoulder.csv');
E = csvread('Polish-elbow.csv');
W = csvread('Polish-hand.csv');
H = csvread('Polish-glove.csv');

figure();
hold on;
plot3(S(:,1), S(:,2), S(:,3), '.');
plot3(E(:,1), E(:,2), E(:,3), '.');
plot3(W(:,1), W(:,2), W(:,3), '.');
title('Polishing');

% screwing motion
S = csvread('Screw-shoulder.csv');
E = csvread('Screw-elbow.csv');
W = csvread('Screw-hand.csv');

figure();
hold on;
plot3(S(:,1), S(:,2), S(:,3), '.');
plot3(E(:,1), E(:,2), E(:,3), '.');
plot3(W(:,1), W(:,2), W(:,3), '.');
title('Screwing');

% giving motion
S = csvread('Give-shoulder.csv');
E = csvread('Give-elbow.csv');
W = csvread('Give-hand.csv');

figure();
hold on;
plot3(S(:,1), S(:,2), S(:,3), '.');
plot3(E(:,1), E(:,2), E(:,3), '.');
plot3(W(:,1), W(:,2), W(:,3), '.');
title('Handover - giving');

% Receive motion
S = csvread('Receive-shoulder.csv');
E = csvread('Receive-elbow.csv');
W = csvread('Receive-hand.csv');

figure();
hold on;
plot3(S(:,1), S(:,2), S(:,3), '.');
plot3(E(:,1), E(:,2), E(:,3), '.');
plot3(W(:,1), W(:,2), W(:,3), '.');
title('Handover - receiving');

