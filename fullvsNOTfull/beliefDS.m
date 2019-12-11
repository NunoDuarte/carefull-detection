%% Load Path
clear all
clc

addpath('../SEDS')
addpath('data')
addpath('../../Khansari/SEDS/SEDS_lib')
addpath('../../Khansari/SEDS/GMR_lib')

% Which Person to choose (Salman, Leo, Bernardo)
[E, F] = read('All');

%% Belief System for 2 DS

% pick one trajectory
testX = F{3}; 

% remove nonzeros
testXn(:,1) = nonzeros(testX(:,2));
testXn(:,2) = nonzeros(testX(:,3));
testXn(:,3) = nonzeros(testX(:,4));
test3{1}(1,:) = testXn(:,1)';
test3{1}(2,:) = testXn(:,2)';
test3{1}(3,:) = testXn(:,3)'; 

% plotting = 0;    % do you want to plot the 3D versions?
% [test3D, test2Dorigin, test2D] = processData(test3, plotting);

%% Center the Data in the Origin

testXn = test3{1};
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
opt_sim.dt = 0.01;
opt_sim.i_max = 1;
opt_sim.tol = 0.001;
opt_sim.plot = 0;

b1 = 0.5;
b2 = 0.5;
b = [b1, b2];
b1_d = 0;
b2_d = 0;
b_d = [b1_d, b2_d];
epsilon = 200; % adaptation rate

d = length(PriorsE); %dimension of data
xT = [0; 0; 0];
Xd = [];

B = [];
for j = 1:length(testXn)-1   
    for i = 1:2
        
        x0 = abs(testXn(:,j));
        
        fn_handle = @(x) GMR(Priors{i},Mu{i},Sigma{i},x,1:d,d+1:2*d);
        [x, xd, tmp, xT]=Simulation(x0,xT,fn_handle,opt_sim); %running the simulator

        % error (real velocity - desired velocity)
        ed = testX_d(:,j) - xd(:,1);
        
        Xd = [Xd; xd(:,1)'];
        
        b_d(i) = epsilon * (ed'*xd(:,1) + (b(i) - 0.5)*norm(xd(:,1), 2)); 
        
        B_d = winnertakeall(b, b_d);
        
        b(i) = b(i) + B_d(i)*0.1;
        b(i) = max(0., min(1., b(i)));
        B = [B; b];

    end
    b(2) = 1. - b(1);
end




