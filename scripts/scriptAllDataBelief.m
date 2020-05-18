%% Load Path

clc

addpath('../SEDS')
addpath('DS')
addpath('beliefDS')
addpath('../../Khansari/SEDS/SEDS_lib')
addpath('../../Khansari/SEDS/GMR_lib')

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

trainTruePos = classEtrain(1)
trainFalsePos = classEtrain(2)
trainTrueNeg = classFtrain(2)
trainFalseNeg = classFtrain(1)

%% Classify train data
[classEtest, outEtest] = fun_beliefDSnorm(Etest, Priors, Mu, Sigma);
[classFtest, outFtest] = fun_beliefDSnorm(Ftest, Priors, Mu, Sigma);

% Output Confusion Matrix

testTruePos = classEtest(1)
testFalsePos = classEtest(2)
testTrueNeg = classFtest(2)
testFalseNeg = classFtest(1)

%% F measure

% train
PreciTrain = trainTruePos/(trainTruePos+trainFalsePos);
RecallTrain = trainTruePos/(trainTruePos+trainFalseNeg);

% test
PreciTest = testTruePos/(testTruePos+testFalsePos);
RecallTest = testTruePos/(testTruePos+testFalseNeg);

F1_train = 2*(PreciTrain*RecallTrain)/(PreciTrain+RecallTrain)
F1_test  = 2*(PreciTest*RecallTest)/(PreciTest+RecallTest)
