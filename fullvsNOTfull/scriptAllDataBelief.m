%% Load Path
clearvars
clc

addpath('../SEDS')
addpath('data')
addpath('../../Khansari/SEDS/SEDS_lib')
addpath('../../Khansari/SEDS/GMR_lib')

%% trained data
Eall = [];
Fall = [];
% Which Person to choose (Salman, Leo, Bernardo)
[E, F] = read('Kunpeng', 'plastic-cup');
Eall = [Eall, E];
Fall = [Fall, F];
[E, F] = read('Kunpeng', 'red-cup');
Eall = [Eall, E];
Fall = [Fall, F];
[E, F] = read('Leo', 'red-cup');
Eall = [Eall, E];
Fall = [Fall, F];
[E, F] = read('Leo', 'champagne');
Eall = [Eall, E];
Fall = [Fall, F];
[E, F] = read('Leo', 'wine-glass');
Eall = [Eall, E];
Fall = [Fall, F];
[E, F] = read('Athanasios', 'champagne');
Eall = [Eall, E];
Fall = [Fall, F];

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

%% Belief System for 2 DS

for k = 1:length(Eall)
    % pick one trajectory
    testX = Eall{k}; 

    % remove nonzeros
    testXn(:,1) = nonzeros(testX(:,2));
    testXn(:,2) = nonzeros(testX(:,3));
    testXn(:,3) = nonzeros(testX(:,4));
    test3{1}(1,:) = testXn(:,1)';
    test3{1}(2,:) = testXn(:,2)';
    test3{1}(3,:) = testXn(:,3)'; 

    %% Center the Data in the Origin

    testXn = test3{1};
    testXn = testXn - testXn(:,end);
    testXn = round(testXn,4);

    %% do the norm of all dimensions

    for n = 1:length(testXn)   
        testXnnorm(n) = norm(testXn(:,n));    
    end
    testXnnorm = round(testXnnorm,3);

    %% Real Velocity of testX

    dt = 0.02; % frequency 
    for i=2:length(testXn(1,:))
        testX_d(1,i-1) = (testXnnorm(1,i) - testXnnorm(1,i-1))/dt;
    end

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

            out(:,j) = mean(testXn(1:3,j:j+K),2);
            outD(j) = mean(testX_d(1,j:j+K),2);
            x0 = norm(out(:,j),2);

            % DS output
            fn_handle = @(xx) GMR(Priors{i},Mu{i},Sigma{i},xx,1:d,d+1:2*d);
            [x, xd, tmp, xT]=Simulation(x0,xT,fn_handle,opt_sim); %running the simulator

            % error (real velocity - desired velocity)
            ed = outD(j) - xd(:,1);
            ee(i) = ed;

            Xd = [Xd; xd(:,1)'];

            b_d(i) = epsilon * (ed'*xd(:,1) + (b(i) - 0.5)*norm(xd(:,1), 2)); 

        end
        Er = [Er;ee];
        B_d = winnertakeall(b, b_d);
        for i = 1:2
            b(i) = b(i) + B_d(i)*0.1;
            b(i) = max(0., min(1., b(i)));
        end
        b(2) = 1. - b(1);
        B = [B; b];    
    end
    
    % save to variable
    trainClass1(:,k) = b';
    
    % clear variables
    clear testXn
    clear test3
end

clc
trainClassE = sum(trainClass1,2);
trainETruePos = trainClassE(1)/length(Eall);
trainEFalsePos = trainClassE(2)/length(Eall);

%% Belief System for 2 DS

for k = 1:length(Fall)
    % pick one trajectory
    testX = Fall{k}; 

    % remove nonzeros
    testXn(:,1) = nonzeros(testX(:,2));
    testXn(:,2) = nonzeros(testX(:,3));
    testXn(:,3) = nonzeros(testX(:,4));
    test3{1}(1,:) = testXn(:,1)';
    test3{1}(2,:) = testXn(:,2)';
    test3{1}(3,:) = testXn(:,3)'; 

    %% Center the Data in the Origin

    testXn = test3{1};
    testXn = testXn - testXn(:,end);
    testXn = round(testXn,4);

    %% do the norm of all dimensions

    for n = 1:length(testXn)   
        testXnnorm(n) = norm(testXn(:,n));    
    end
    testXnnorm = round(testXnnorm,3);

    %% Real Velocity of testX

    dt = 0.02; % frequency 
    for i=2:length(testXn(1,:))
        testX_d(1,i-1) = (testXnnorm(1,i) - testXnnorm(1,i-1))/dt;
    end

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

            out(:,j) = mean(testXn(1:3,j:j+K),2);
            outD(j) = mean(testX_d(1,j:j+K),2);
            x0 = norm(out(:,j),2);

            % DS output
            fn_handle = @(xx) GMR(Priors{i},Mu{i},Sigma{i},xx,1:d,d+1:2*d);
            [x, xd, tmp, xT]=Simulation(x0,xT,fn_handle,opt_sim); %running the simulator

            % error (real velocity - desired velocity)
            ed = outD(j) - xd(:,1);
            ee(i) = ed;

            Xd = [Xd; xd(:,1)'];

            b_d(i) = epsilon * (ed'*xd(:,1) + (b(i) - 0.5)*norm(xd(:,1), 2)); 

        end
        Er = [Er;ee];
        B_d = winnertakeall(b, b_d);
        for i = 1:2
            b(i) = b(i) + B_d(i)*0.1;
            b(i) = max(0., min(1., b(i)));
        end
        b(2) = 1. - b(1);
        B = [B; b];    
    end
    
    % save to variable
    trainClass2(:,k) = b';
    
    % clear variables
    clear testXn
    clear test3
end

clc
trainClassF = sum(trainClass2,2);

%% Output Confusion Matrix

trainETruePos = trainClassE(1)/length(Eall)
trainEFalsePos = trainClassE(2)/length(Eall)
trainFTrueNeg = trainClassF(2)/length(Fall)
trainFFalseNeg = trainClassF(1)/length(Fall)



