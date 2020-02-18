%% Load Path
clear all
clc

addpath('../SEDS')
addpath('data')
addpath('beliefDS')
addpath('../../Khansari/SEDS/SEDS_lib')
addpath('../../Khansari/SEDS/GMR_lib')

% Which Person to choose (Salman, Leo, Bernardo)
[E, F] = read('All');

%% Belief System for 2 DS

% pick one trajectory
testX = E{6}; 

% remove nonzeros
testXn(:,1) = nonzeros(testX(:,2));
testXn(:,2) = nonzeros(testX(:,3));
testXn(:,3) = nonzeros(testX(:,4));
test3{1}(1,:) = testXn(:,1)';
test3{1}(2,:) = testXn(:,2)';
test3{1}(3,:) = testXn(:,3)'; 

%% Center the Data in the Origin
plotting = 0;
% 
[Emp3D, Emp2Do, Emp2D] = processData(test3, plotting);

% get 3D positions
[~ , ~, Data3D, index] = preprocess_demos(Emp3D, 0.02, 0.0001); 
% get velocity 3D
testX_d = Data3D(4:end,:);
testX_d(2,:) = testX_d(2,:);
%% Load DS parameters

MuE = load('MuE.mat');
MuE = MuE.Mu;
PriorsE = load('PriorsE.mat');
PriorsE = PriorsE.Priors;
SigmaE = load('SigmaE.mat');
SigmaE = SigmaE.Sigma;

MuF = load('MuF.mat');
MuF = MuF.Mu;
PriorsF = load('PriorsF.mat');
PriorsF = PriorsF.Priors;
SigmaF = load('SigmaF.mat');
SigmaF = SigmaF.Sigma;

Mu{1} = MuE;
Mu{2} = MuF;

Priors{1} = PriorsE;
Priors{2} = PriorsF;

Sigma{1} = SigmaE;
Sigma{2} = SigmaF;

%% Handover Estimation
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
humanVelCurr = testX_d(3,1); % init velocities for human
robotVelCurr = zeros(3,1); % init velocities for robot

handoverPoseGlobal = humanPos0Global; % init handover pose

for i = 1:counter % initializing model estimation data
    humanPosCurrGlobalVectorDS(:,i) = humanShPose*humanPosCurr;
end

humanPosCurrGlobalVector = humanPosCurrGlobalVectorDS; %history of human posesx

% initialize variables
handoverPoseVector = [];
humanVelCurrVector = [];
robotPosCurrVector = [];

%% Run each DS to get the desired velocity?
opt_sim.dt = 0.02;
opt_sim.i_max = 1;
opt_sim.tol = 0.001;
opt_sim.plot = 0;

b1 = 0.5;
b2 = 0.5;
b = [b1, b2];
b1_d = 0;
b2_d = 0;
b_d = [b1_d, b2_d];
epsilon = 300; % adaptation rate

d = 1; %dimension of data
xT = 0;
Xd = [];

B = [];
B = [B; b];
Er = [];

X0 = [];
K = 0; % out many values to average
k = 1;
for j = 1:length(testXn)-K-1   
    ee = [0 0];
    
    %% Simulation
    t = dt*j;

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
    %[humanPosCurr, humanVelCurr] = findNextPosHuman(humanPos0,humanPosF,T, t, tCirc, tDist);
    humanVelCurr = [testX_d(:,j);1];
    humanPosCurr = humanPosCurr + humanVelCurr*dtH;

    humanVelCurrVector = [humanVelCurrVector, humanVelCurr];
    robotPosCurrVector = [robotPosCurrVector, robotPosCurr];    
    
    for i = 1:2

%         %stop if reached the human
%         if(norm(humanPosCurrGlobal(1:3)-robotPosCurrGlobal(1:3)) < 0.05)
%             break;
%         end


%         outD(j) = Data(2,j);
        x0 = norm(handoverPoseGlobal(1:3) - humanPosCurrGlobalVector(1:3,20+j));
        X0 = [X0, x0];
        %x0 = Data(1,j);

        if j > 20
            outD(k) = norm(testX_d(:,k));
            % DS output
            fn_handle = @(xx) GMR(Priors{i},Mu{i},Sigma{i},xx,1:d,d+1:2*d);
            [x, xd, tmp, xT]=Simulation(x0,xT,fn_handle,opt_sim); %running the simulator
    %         y2 = pdf('Normal',x0,Mu{i},Sigma{i});


            % error (real velocity - desired velocity)
            ed = abs(outD(k) - xd(:,1));
            ee(i) = ed;

            Xd = [Xd; xd(:,1)'];

            b_d(i) = epsilon * (ed'*xd(:,1) + (b(i) - 0.5)*norm(xd(:,1), 2)); 
            
        end
    end
    Er = [Er;ee];
    
    if j > 20     
        if abs(outD(k)) > 0.15
           [b1_d, w] = max(b_d); 
            if w == 1
                0
            elseif w == 2
                b_dold = b_d;
                b_d(1) = b1_d;
                b_d(2) = b_dold(1);       
            end
        end
        k = k +1;
    end
        
    B_d = winnertakeall(b, b_d);
    for i = 1:2
        b(i) = b(i) + B_d(i)*0.1;
        b(i) = max(0., min(1., b(i)));
    end
    b(2) = 1. - b(1);
    
    B = [B; b];    
end




