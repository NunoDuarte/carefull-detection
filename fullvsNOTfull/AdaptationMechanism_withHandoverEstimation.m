%%  This is a standard formulation of the Adaptation Mechanism to 
% classify the action between 2 DS

% DataV is the 3D velocity coordinates of the Human
%% Handover Estimation Parameters
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
humanVelCurr = DataV(3,1); % init velocities for human
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

%% Set parameters Belief System
% parameters to SEDS
opt_sim.dt = 0.02;
opt_sim.i_max = 1;
opt_sim.tol = 0.001;
opt_sim.plot = 0;
d = 1; % dimension of data
xT = 0; 

% initiliaze variables
b1 = 0.5;
b2 = 0.5;
b = [b1, b2];
b1_d = 0;
b2_d = 0;
b_d = [b1_d, b2_d];

% adaptation rate
epsilon = 300; 

% initialize vectors to save output
DX_desired = [];
B = [];
Er = [];
X0 = [];

% 1st initial belief [0.5, 0.5]
B = [B; b];

k = 1;
for j = 1:length(DataV)

    %% Handover Estimation
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
    
    % Set the Current Human Velocity 
    humanVelCurr = [DataV(:,j);1];
    humanPosCurr = humanPosCurr + humanVelCurr*dtH;

    humanVelCurrVector = [humanVelCurrVector, humanVelCurr];
    robotPosCurrVector = [robotPosCurrVector, robotPosCurr];  
    
    ee = [0 0];
    
    for i = 1:2
        
        % input to DS
        % distance to meeting point
        x = norm(handoverPoseGlobal(1:3) - humanPosCurrGlobalVector(1:3,20+j));
        X0 = [X0, x];

        if j > counter
                 
            % input to DS
            dx_real(k) = norm(DataV(:,k));        % current velocity at current distance

            % DS output
            fn_handle = @(xx) GMR(Priors{i},Mu{i},Sigma{i},xx,1:d,d+1:2*d);
            [~, dx_desired, ~, ~]=Simulation(x,xT,fn_handle,opt_sim); % output desired velocity

            % error (real velocity - desired velocity (pick 1st output))
            ed = abs(dx_real(k) - dx_desired(:,1));

            % save output
            DX_desired = [DX_desired; dx_desired(:,1)'];

            ee(i) = ed;        

            b_d(i) = epsilon * (ed'*dx_desired(:,1) + (b(i) - 0.5) * norm(dx_desired(:,1), 2)); 
                    
            k = k +1;
        end

    end
    
    % save output
    Er = [Er;ee];
                
    % update belief system
    B_d = winnertakeall(b, b_d);
    for i = 1:2
        b(i) = b(i) + B_d(i)*0.1;
        b(i) = max(0., min(1., b(i)));
    end
    b(2) = 1. - b(1);
    
    % save output
    B = [B; b];    
    
end