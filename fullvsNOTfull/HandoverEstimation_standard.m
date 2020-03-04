% DataV is the 3D velocity coordinates of the Human


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
dt = 0.1; % dt for simulation
dtH = 0.02; % dt of Human data
DSdt = 1; % dt multiplier for the human model estimation
counter = 20; % number of data points for human model estimation

robotPosCurr = robotPos0; % current position of the robot
humanPosCurr = humanPos0; % current position of human
humanPos0Global = humanShPose*humanPos0; % curr position of human in the global frame
humanPosFGlobal = humanShPose*humanPosF; % goal position of human in the global frame
humanVelCurr = zeros(3,1); % init velocities for human
robotVelCurr = zeros(3,1); % init velocities for robot

handoverPoseGlobal = humanPos0Global; % init handover pose

for i = 1:counter % initializing model estimation data
humanPosCurrGlobalVectorDS(:,i) = humanShPose*humanPosCurr;
end

humanPosCurrGlobalVector = humanPosCurrGlobalVectorDS; %history of human posesx

%% Simulation

handoverPoseVector = [];
humanVelCurrVector = [];
robotPosCurrVector = [];

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
handoverPoseVector = [handoverPoseVector, handoverPose];

[robotPosCurr, robotVelCurr] = findNextPosRobot(robotPosCurr, handoverPose, dt);
humanVelCurr = [DataV(:,i);1];
humanPosCurr = humanPosCurr + humanVelCurr*dtH;

humanVelCurrVector = [humanVelCurrVector, humanVelCurr];
robotPosCurrVector = [robotPosCurrVector, robotPosCurr];

%stop if reached the human
if(norm(humanPosCurrGlobal(1:3)-robotPosCurrGlobal(1:3)) < 0.05)
    break;
end

i = i+1;

end