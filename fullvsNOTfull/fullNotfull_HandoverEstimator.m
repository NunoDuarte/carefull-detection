% This file finds the handover location for a handover, assuming a DS for
% the human motion, and the robot following it.

% clearvars;
close all;

addpath('data')
addpath('../../handover_location_estimator_matlab');
% Which Person to choose (Salman, Leo, Bernardo)
[E, F] = read('Kunpeng', 'plastic-cup');

% pick one trajectory
testX = E{3}; 
% remove nonzeros
testXn(:,1) = nonzeros(testX(:,2));
testXn(:,2) = nonzeros(testX(:,3));
testXn(:,3) = nonzeros(testX(:,4));
test3{1}(1,:) = testXn(:,1)';
test3{1}(2,:) = testXn(:,2)';
test3{1}(3,:) = testXn(:,3)'; 
testXn = test3{1};
testXn = testXn - testXn(:,end);
testXn = round(testXn,3);

%% Real Velocity of testX
dt = 0.02; % frequency 

for i=2:length(testXn(1,:))
   testX_d(1,i-1) = (testXn(1,i) - testXn(1,i-1))/dt;
   testX_d(2,i-1) = (testXn(2,i) - testXn(2,i-1))/dt;
   testX_d(3,i-1) = (testXn(3,i) - testXn(3,i-1))/dt;
end
%testX_d = diff(testXn,1,2);

%%

humanShPose = eye(4); % shoulder position for human
robotShPose = [cos(pi) 0 sin(pi) 0;
             0 1 0 0;
             -sin(pi) 0 cos(pi)  0;
             0 0 0 1]; % shoulder position for robot

robotPos0 = [-0.4;0;0;1]; % robot starting location
humanPos0 = [0; 0; 0; 1]; % human starting location
humanPosF = [1; 1; 1; 1];

T = 10; % Human trajectory total time
simT = 2*T; % total simulation time
dt = 0.04; % dt for simulation
dtH = 0.02; % dt of Human data
DSdt = 1; % dt multiplier for the human model estimation
counter = 5; % number of data points for human model estimation

robotPosCurr = robotPos0; % current position of the robot
humanPosCurr = humanPos0; % current position of human
humanPos0Global = humanShPose*humanPos0; % curr position of human in the global frame
humanPosFGlobal = humanShPose*humanPosF; % goal position of human in the global frame
humanVelCurr = testX_d(3,1); % init velocities for human
robotVelCurr = zeros(3,1); % init velocities for robot

handoverPoseGlobal = humanPos0Global; % init handover pose

for i = 1:counter % initializing model estimation data
humanPosCurrGlobalVectorDS(:,i) = humanShPose*humanPosCurr;
end

humanPosCurrGlobalVector = humanPosCurrGlobalVectorDS; %history of human posesx

%% Plot
figure(1);
hold on;
axis([-0.05 0.4 -0.05 0.01 -0.1 0.8]);
title('Simulation of handover location estimation','fontsize',12);

xlabel('X');
ylabel('Y');
zlabel('Z');
%% Simulation

humanVelCurrVector = [];

i = 1;
for t = 0:dt:simT
%loop from here

%calculate everything in global frame
robotPosCurrGlobal = robotShPose*robotPosCurr;
%robotVelCurrGlobal = robotShPose(1:3,1:3)*robotVelCurr;

humanPosCurrGlobal = humanShPose*humanPosCurr;
%humanVelCurrGlobal = humanShPose(1:3,1:3)*humanVelCurr;

% store history
humanPosCurrGlobalVector(:,end+1) = humanPosCurrGlobal;

% packet the data used for finding model (end->latest pose)
if(mod(t/dt,DSdt) == 0 )
    humanPosCurrGlobalVectorDS(:,end+1) = humanPosCurrGlobalVector(:,end - DSdt - 1);
    humanPosCurrGlobalVectorDS(:,1) = [];
end

%find the next handover location
handoverPoseGlobal(1:3) = findHandoverLocation(robotPosCurrGlobal(1:3), humanPosCurrGlobalVectorDS(1:3,:), dt*DSdt);

%move the robot and human
handoverPose = robotShPose\handoverPoseGlobal;

[robotPosCurr, robotVelCurr] = findNextPosRobot(robotPosCurr, handoverPose, dt);
%[humanPosCurr, humanVelCurr] = findNextPosHuman(humanPos0,humanPosF,T, t, tCirc, tDist);
humanVelCurr = [testX_d(:,i);1];
humanPosCurr = humanPosCurr + humanVelCurr*dtH;

humanVelCurrVector = [humanVelCurrVector, humanVelCurr];

%plot
figure(1);
plot3(robotPosCurrGlobal(1), robotPosCurrGlobal(2), robotPosCurrGlobal(3), 'xr', 'markersize',8);
plot3(humanPosCurrGlobal(1), humanPosCurrGlobal(2), humanPosCurrGlobal(3), '*b', 'markersize',8);
plot3(handoverPoseGlobal(1), handoverPoseGlobal(2), handoverPoseGlobal(3), 'og', 'markersize',12);
legend('robot position', 'human position', 'handover estimate');
%view(3);

%stop if reached the human
if(norm(humanPosCurrGlobal(1:3)-robotPosCurrGlobal(1:3)) < 0.01)
    break;
end

pause(0.1);

if i < length(testX_d)
    i = i+1;
end
end