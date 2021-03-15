%% Load Path
clc

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
samp_freq = 1/50; % for EPFL data
[classEtrain, outEtrain] = fun_belief_norm(Etrain, Priors, Mu, Sigma, samp_freq, epsilon);
[classFtrain, outFtrain] = fun_belief_norm(Ftrain, Priors, Mu, Sigma, samp_freq, epsilon);

% Output Confusion Matrix

trainTruePos = classEtrain(1);
trainFalsePos = classEtrain(2);
trainTrueNeg = classFtrain(2);
trainFalseNeg = classFtrain(1);

%% Classify train data
samp_freq = 1/10; % for QMUL data
[classEtest, outEtest] = fun_belief_norm(Etest, Priors, Mu, Sigma, samp_freq, epsilon);
[classFtest, outFtest] = fun_belief_norm(Ftest, Priors, Mu, Sigma, samp_freq, epsilon);

% Output Confusion Matrix

testTruePos = classEtest(1);
testFalsePos = classEtest(2);
testTrueNeg = classFtest(2);
testFalseNeg = classFtest(1);

%% F measure

% train
PreciTrain = trainTruePos/(trainTruePos+trainFalsePos);
RecallTrain = trainTruePos/(trainTruePos+trainFalseNeg);

% test
PreciTest = testTruePos/(testTruePos+testFalsePos);
RecallTest = testTruePos/(testTruePos+testFalseNeg);

F1_train = 2*(PreciTrain*RecallTrain)/(PreciTrain+RecallTrain);
F1_test  = 2*(PreciTest*RecallTest)/(PreciTest+RecallTest);
