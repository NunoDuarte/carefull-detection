function [trainTruePos, trainFalsePos, trainTrueNeg, trainFalseNeg, ....
    testTruePos, testFalsePos, testTrueNeg, testFalseNeg, ....
    F1_train, F1_test] = ....
        scriptBelief(Etrain, Ftrain, Etest, Ftest, freq, minVel, epsi)
    clc

    %% Load Eigen parameters
    
    SigmaE = load('SigmaE.mat');
    SigmaE = SigmaE.Sigma;

    SigmaF = load('SigmaF.mat');
    SigmaF = SigmaF.Sigma;
    
    Sigma{1} = SigmaE;
    Sigma{2} = SigmaF;
    
    %% CHECK PARAMETERS
    samp_freq_train = freq.train;    
    samp_freq_test = freq.test;    

    %% Classify train data
    [classEtrain, outEtrain] = fun_belief_norm(Etrain, Sigma, samp_freq_train, minVel, epsi);
    [classFtrain, outFtrain] = fun_belief_norm(Ftrain, Sigma, samp_freq_train, minVel, epsi);

    % Output Confusion Matrix

    trainTruePos = classEtrain(1);
    trainFalsePos = classEtrain(2);
    trainTrueNeg = classFtrain(2);
    trainFalseNeg = classFtrain(1);

    %% Classify test data
    [classEtest, outEtest] = fun_belief_norm(Etest, Sigma, samp_freq_test, minVel, epsi);
    [classFtest, outFtest] = fun_belief_norm(Ftest, Sigma, samp_freq_test, minVel, epsi);

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
