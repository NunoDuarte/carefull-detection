%% Load Path
clearvars
clc

addpath('../SEDS')
addpath('data')
addpath('DS')
addpath('beliefDS')
addpath('../../Khansari/SEDS/SEDS_lib')
addpath('../../Khansari/SEDS/GMR_lib')

%% trained data
Etrain = [];
Ftrain = [];
% Which Person to choose (Salman, Leo, Bernardo)
[E, F] = read('Kunpeng', 'plastic-cup');
Etrain = [Etrain, E];
Ftrain = [Ftrain, F];
[E, F] = read('Kunpeng', 'red-cup');
Etrain = [Etrain, E];
Ftrain = [Ftrain, F];
[E, F] = read('Leo', 'red-cup');
Etrain = [Etrain, E];
Ftrain = [Ftrain, F];
[E, F] = read('Leo', 'champagne');
Etrain = [Etrain, E];
Ftrain = [Ftrain, F];
[E, F] = read('Leo', 'wine-glass');
Etrain = [Etrain, E];
Ftrain = [Ftrain, F];
[E, F] = read('Athanasios', 'champagne');
Etrain = [Etrain, E];
Ftrain = [Ftrain, F];

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
[classEtrain, outEtrain] = fun_beliefDSnorm(Etrain, Priors, Mu, Sigma);
[classFtrain, outFtrain] = fun_beliefDSnorm(Ftrain, Priors, Mu, Sigma);

% Output Confusion Matrix

trainETruePos = classEtrain(1)
trainEFalsePos = classEtrain(2)
trainFTrueNeg = classFtrain(2)
trainFFalseNeg = classFtrain(1)

%% test data
Etest = [];
Ftest = [];
% Which Person to choose (Salman, Leo, Bernardo)
[E, F] = read('Kunpeng', 'wine-glass');
Etest = [Etest, E];
Ftest = [Ftest, F];
[E, F] = read('Leo', 'plastic-cup');
Etest = [Etest, E];
Ftest = [Ftest, F];
[E, F] = read('Athanasios', 'red-cup');
Etest = [Etest, E];
Ftest = [Ftest, F];

%% Classify train data
[classEtest, outEtest] = fun_beliefDSnorm(Etest, Priors, Mu, Sigma);
[classFtest, outFtest] = fun_beliefDSnorm(Ftest, Priors, Mu, Sigma);

% Output Confusion Matrix

testETruePos = classEtest(1)
testEFalsePos = classEtest(2)
testFTrueNeg = classFtest(2)
testFFalseNeg = classFtest(1)

%% F measure

% train
PreciTrain = trainETruePos/(trainETruePos+trainEFalsePos);
RecallTrain = trainETruePos/(trainETruePos+trainFFalseNeg);

% test
PreciTest = testETruePos/(testETruePos+testEFalsePos);
RecallTest = testETruePos/(testETruePos+testFFalseNeg);

F1_train = 2*(PreciTrain*RecallTrain)/(PreciTrain+RecallTrain)
F1_test  = 2*(PreciTest*RecallTest)/(PreciTest+RecallTest)
