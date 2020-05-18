%% Load Path
clear testXn
clear test3
clear all 

%% Get Data
files = dir('/home/nuno/Documents/MATLAB/PhD/armMotionDS/fullvsNOTfull/data/QMUL/1/*.csv');
fullpaths = fullfile({files.folder}, {files.name});

% Empty Cups
fu0 = strfind(fullpaths, 'fu0');
indexE = find(~cellfun(@isempty,fu0));

for i=1:length(indexE)
    E{i} = csvread(fullpaths{indexE(i)});
end

% Full Cups
fu2 = strfind(fullpaths, 'fu2');
indexF = find(~cellfun(@isempty,fu2));

for i=1:length(indexF)
    F{i} = csvread(fullpaths{indexF(i)}); 
end    
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

%% Center the Data in the Origin
plotting = 0;
% 
[Emp3D, Emp2Do, Emp2D] = processData(test3, plotting);
for i=1:length(Emp3D)
    Norm1 = [];
    for j=1:length(Emp3D{i})
    
        norm1 = Emp3D{i}(:,j);
        Norm1 = [Norm1; norm(norm1,2)];
        Emp3Dnorm{i} = Norm1';
    end
end

[~ , ~, Data, index] = preprocess_demos(Emp3Dnorm, 0.0333, 0.0001); 
[maxVel, idVel] = min(Data(2,:));

Dataold = Data;
Datanew = Data(:,idVel:end);


% testXn = test3{1};
% testXn = testXn - testXn(:,end);
% testXn = round(testXn,3);
% 
% % do the norm of all dimensions
% for n = 1:length(testXn)   
%     testXnnorm(n) = norm(testXn(:,n));       
% end
% % testXnnorm = round(testXnnorm,4);
% 
% testXnnorm0 = testXnnorm - testXnnorm(:,end);
% testXnnorm0 = testXnnorm0;
% testXnnorm0 = round(testXnnorm0,3);

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
for j = 1:length(Datanew)   
    ee = [0 0];
    for i = 1:2
        

        outD(j) = Datanew(2,j);
        x0 = Datanew(1,j);

        % DS output
        fn_handle = @(xx) GMR(Priors{i},Mu{i},Sigma{i},xx,1:d,d+1:2*d);
        [x, xd, tmp, xT]=Simulation(x0,xT,fn_handle,opt_sim); %running the simulator
        Xd = [Xd; xd(:,1)'];
        
        % error (real velocity - desired velocity)
        ed = abs(outD(j) - xd(:,1));
        ee(i) = ed;

        b_d(i) = epsilon * (ed'*xd(:,1) + (b(i) - 0.5)*norm(xd(:,1), 2)); 
        
    end
    Er = [Er;ee];
    
    % Threshold for stupid bug
    if abs(outD(j)/x0) > 2.5 && abs(outD(j)) > 0.20
       [b1_d, w] = max(b_d); 
        if w == 1
            0
        elseif w == 2
            b_dold = b_d;
            b_d(1) = b1_d;
            b_d(2) = b_dold(1);       
        end
    end
        
    B_d = winnertakeall(b, b_d);
    for i = 1:2
        b(i) = b(i) + B_d(i)*0.1;
        b(i) = max(0., min(1., b(i)));
    end
    b(2) = 1. - b(1);
    B = [B; b];    
end

clearvars -except b B E F indexE indexF fullpaths Datanew Data


