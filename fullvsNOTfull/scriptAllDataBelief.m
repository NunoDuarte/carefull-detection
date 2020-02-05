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

%% Classify train data
classE = fun_beliefDSnorm(Eall, Priors, Mu, Sigma);
classF = fun_beliefDSnorm(Fall, Priors, Mu, Sigma);

% Output Confusion Matrix

trainETruePos = classE(1)
trainEFalsePos = classE(2)
trainFTrueNeg = classF(1)
trainFFalseNeg = classF(2)



