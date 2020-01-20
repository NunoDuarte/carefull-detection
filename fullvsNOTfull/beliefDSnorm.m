%% Load Path
clear all
clc

addpath('../SEDS')
addpath('data')
addpath('../../Khansari/SEDS/SEDS_lib')
addpath('../../Khansari/SEDS/GMR_lib')

% Which Person to choose (Salman, Leo, Bernardo)
[E, F] = read('Leo');

%% Belief System for 2 DS

% pick one trajectory
testX = F{1}; 

% remove nonzeros
testXn(:,1) = nonzeros(testX(:,2));
testXn(:,2) = nonzeros(testX(:,3));
testXn(:,3) = nonzeros(testX(:,4));
test3{1}(1,:) = testXn(:,1)';
test3{1}(2,:) = testXn(:,2)';
test3{1}(3,:) = testXn(:,3)'; 

% figure()
% plot3(testXn(:,1), testXn(:,2), testXn(:,3), '.');
% plotting = 0;    % do you want to plot the 3D versions?
% [test3D, test2Dorigin, test2D] = processData(test3, plotting);

%% Center the Data in the Origin

testXn = test3{1};
testXn = testXn - testXn(:,end);
testXn = round(testXn,3);

% do the norm of all dimensions
for n = 1:length(testXn)   
    testXnnorm(n) = norm(testXn(:,n));    
end
testXnnorm = round(testXnnorm,3);
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
dt = 0.02; % frequency 

for i=2:length(testXn(1,:))
%     if i==2
%         testX_d(1,i-1) = -0.2;
%     else
        testX_d(1,i-1) = (testXnnorm(1,i) - testXnnorm(1,i-1))/dt;
%     end
end
%testX_d = diff(testXn,1,2);

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

K = 0; % out many values to average
for j = 1:length(testXn)-K-1   
    ee = [0 0];
    for i = 1:2
        
        out(:,j) = mean(testXn(1:3,j:j+K),2)*0.6;
        outD(j) = mean(testX_d(1,j:j+K),2);
        x0 = norm(out(:,j),2);
        
        % DS output
        fn_handle = @(xx) GMR(Priors{i},Mu{i},Sigma{i},xx,1:d,d+1:2*d);
        [x, xd, tmp, xT]=Simulation(x0,xT,fn_handle,opt_sim); %running the simulator
%         y2 = pdf('Normal',x0,Mu{i},Sigma{i});


        % error (real velocity - desired velocity)
        ed = outD(j) - xd(:,1);
        ee(i) = ed;
        
        Xd = [Xd; xd(:,1)'];
        
        b_d(i) = epsilon * (ed'*xd(:,1) + (b(i) - 0.5)*norm(xd(:,1), 2)); 
        
%         B_d = winnertakeall(b, b_d);
%         
%         b(i) = b(i) + B_d(i)*opt_sim.dt;
%         b(i) = max(0., min(1., b(i)));
%         B = [B; b];

    end
    Er = [Er;ee];
    B_d = winnertakeall(b, b_d);
    for i = 1:2
        b(i) = b(i) + B_d(i)*0.1;
        b(i) = max(0., min(1., b(i)));
    end
    b(2) = 1. - b(1);
    
% Constraints on the belief system
%     if abs(b(1) - b(2)) < 0.001
%        if b(1) > b(2)
%            b(1) = 0.5; 
%            b(2) = 0.5;
%        end
%     end
    B = [B; b];    
end




