function scriptDS(Etrain, Ftrain, train, test, Etest, Ftest, K, minVel, epsilon, plots, freq)

    %% Define parameters
    default = 0;    % No default
    samp_freq_train = freq.train;

    %% Preprocessing - Empty
    for i=1:length(Etrain)

        En{i} = Etrain{i}(any(Etrain{i},2),2:4);       % remove only full rows of 0s
        En{i} = En{i}(all(~isnan(En{i}),2),:);         % remove rows of NANs    
        E3{i}(1,:) = En{i}(:,1)';
        E3{i}(2,:) = En{i}(:,2)';
        E3{i}(3,:) = En{i}(:,3)';         
        
        E3{i} = round(E3{i},4);
    end
    
    %% Generate a DS for Empty Cups
    for i=1:length(E3)
        xT = E3{i}(:,end);
        Norm1 = [];
        for j=1:length(E3{i})
            dis = xT - E3{i}(:,j);
            disN = norm(dis,2);
            Norm1 = [Norm1; disN];

            % normalized over distance
            Norm2 = Norm1/max(Norm1);

            % flip data to have the acceleration phase at the end
            Norm2 = flip(Norm2);
            Emp3Dnorm{i} = Norm2';
        end
    end

    K = genDS(Emp3Dnorm, default, [], K, [], samp_freq_train, 'E');
    
    %% Preprocessing
    
    for i=1:length(Ftrain)
        Fn{i} = Ftrain{i}(any(Ftrain{i},2),2:4);        % remove only full rows of 0s
        Fn{i} = Fn{i}(all(~isnan(Fn{i}),2),:);          % remove rows of NANs    
        F3{i}(1,:) = Fn{i}(:,1)';
        F3{i}(2,:) = Fn{i}(:,2)';
        F3{i}(3,:) = Fn{i}(:,3)'; 

        F3{i} = round(F3{i},4);
    end

    %% Generate a DS for Full Cups   

    for i=1:length(F3)
        xT = F3{i}(:,end);
        Norm1 = [];
        for j=1:length(F3{i})
            dis = xT - F3{i}(:,j);
            disN = norm(dis);
            Norm1 = [Norm1; disN];

            % normalized over distance
            Norm2 = Norm1/max(Norm1);

            % flip data to have the acceleration phase at the end
            Norm2 = flip(Norm2);
            Full3Dnorm{i} = Norm2';
        end
    end
    genDS(Full3Dnorm, default, [], K, [], samp_freq_train, 'F');

    %% save figures

    if plots
        f1 = figure(1);
        filename = ['/output/train/E-e1e2-K' num2str(K) '-' datestr(now,'mm-dd-yyyy-HH-MM-SS')];
        saveas(f1, [pwd, filename]);

        f2 = figure(2);
        filename = ['/output/train/F-e1e2-K' num2str(K) '-' datestr(now,'mm-dd-yyyy-HH-MM-SS')];
        saveas(f2, [pwd, filename]);
    end

    %% labels to know which object

    % EPFL + QMUL
    Train = [];
    for i = 1:length(train)
        Train = [Train; train{i}];
    end
    Train = [Train; {' ', ' '}];

    Test = [];
    for i = 1:length(test)
        Test = [Test; test{i}];
    end
    Test = [Test; {' ', ' '}];


    %% Classification

    [trainTruePos, trainFalsePos, trainTrueNeg, trainFalseNeg, ....
        testTruePos, testFalsePos, testTrueNeg, testFalseNeg, ....
        F1_train, F1_test] = ....
        scriptBelief(Etrain, Ftrain, Etest, Ftest, freq, minVel, epsilon);
    
    % Add if statement to filter results
    if ((trainTruePos >= 0.4 && trainTrueNeg > 0.6) && (testTruePos >= 0.4 && testTrueNeg > 0.6))

        ConfTrain = {'Confusion Matrix', 'Train'; trainTruePos, trainFalsePos; trainFalseNeg, trainTrueNeg};
        ConfTest = {'Confusion Matrix', 'Test'; testTruePos, testFalsePos; testFalseNeg, testTrueNeg};
        F0 = {'Epsilon ',  ' ' ; epsilon, []};
        F1 = {'F1 measure Train', 'F1 measure Test'; F1_train, F1_test};

        t = table([Train; Test; ConfTrain; ConfTest; F0; F1], 'VariableNames', {'Train_Test_dataset'});
        filename = ['output/train/dataset-K' num2str(K) '-minVel' num2str(minVel) '-epsi' num2str(epsilon) '-' datestr(now,'mm-dd-yyyy-HH-MM-SS')];
        writetable(t, [filename '.txt']);
    end

    %% 
end
