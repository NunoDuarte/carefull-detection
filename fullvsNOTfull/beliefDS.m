%% Load Path
addpath('../SEDS')
addpath('data')
addpath('../../Khansari/SEDS/SEDS_lib')
addpath('../../Khansari/SEDS/GMR_lib')

% Which Person to choose (Salman, Leo, Bernardo)
[E, F] = read('All');

%% Belief System for 2 DS

b1 = 0.5;
b2 = 0.5;
b = [b1, b2];

% pick one trajectory
testX = E{2}; 

% remove nonzeros
testXn(:,1) = nonzeros(testX(:,2));
testXn(:,2) = nonzeros(testX(:,3));
testXn(:,3) = nonzeros(testX(:,4));
test3{1}(1,:) = testXn(:,1)';
test3{1}(2,:) = testXn(:,2)';
test3{1}(3,:) = testXn(:,3)'; 

plotting = 0;    % do you want to plot the 3D versions?
[test3D, test2Dorigin, test2D] = processData(test3, plotting);

%% Origin the Data

testXn = test3D{1};
testXn = testXn - testXn(:,end);

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
%% Real Velocity of testX
dt = 0.1;
testX_d = diff(testXn,1,2)/dt;

%% Run each DS to get the desired velocity?
opt_sim.dt = 0.05;
opt_sim.i_max = 3000;
opt_sim.tol = 0.001;

d = length(PriorsE); %dimension of data
xT = [0; 0; 0];
for i = 1:1
    
    for j = 1:1
        
        x0 = abs(testXn(:,j));
        fn_handle = @(x) GMR(Priors{i},Mu{i},Sigma{i},x,1:d,d+1:2*d);
        [x, xd, tmp, xT]=Simulation(x0,xT,fn_handle,opt_sim); %running the simulator
    end
end




