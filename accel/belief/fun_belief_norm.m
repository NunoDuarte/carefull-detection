function [Classification, trainClass] = fun_belief_norm(Data, Sigma, samp_freq, minVel, epsi)

    %% Belief System for 2 DS    
    for k = 1:length(Data)
        % for each trajectory
        testX = Data{k};

        % preprocess data
        testXn = testX(any(testX,2),2:4);          % remove only full rows of 0s
        testXn = testXn(all(~isnan(testXn),2),:);  % remove rows of NANs    
        test3{1}(1,:) = testXn(:,1)';
        test3{1}(2,:) = testXn(:,2)';
        test3{1}(3,:) = testXn(:,3)'; 

        for i=1:length(test3)
            xT = test3{i}(:,end);
            Norm1 = [];
            for j=1:length(test3{i})
                dis = xT - test3{i}(:,j);
                disN = norm(dis,2);
                Norm1 = [Norm1; disN];

                % normalized over distance
                Norm2 = Norm1/max(Norm1);

                % flip data to have the acceleration phase at the end
                Norm2 = flip(Norm2);
                Emp3Dnorm{i} = Norm2';
            end
        end

        [~ , ~, dataProcess, index] = preprocess_demos(Emp3Dnorm, samp_freq, 0.0001); 

        % flip again to start at (0,0);
        dataProcess = flip(dataProcess')';
        
        %% Load Eigen Vectors

        % pick 1st gaussian
        [Ve,De] = eig(Sigma{1}(:,:,1));
        Ee1=Ve(:,1); 
        Ee2=Ve(:,2);
        Ed = sqrt(diag(De));

        % pick 1st gaussian
        [Vf,Df] = eig(Sigma{2}(:,:,1));
        Fe1=Vf(:,1); 
        Fe2=Vf(:,2);
        Fd = sqrt(diag(Df));

        e2{1} = Ve(:,2);
        e2{2} = Vf(:,2);
        %% Classifier Loop for Eigen matching

        % initialization
        b1 = 0.5;
        b2 = 0.5;
        b = [b1, b2];
        b1_d = 0;
        b2_d = 0;
        b_d = [b1_d, b2_d];
        epsilon = epsi; % adaptation rate

        d = 1; %dimension of data
        xT = 0;
        Xd = zeros(length(dataProcess),2);

        B = [];
        B = [B; b];
        Er = [];

        K = 0; % out many values to average
        for j = 1:length(dataProcess)-K-1   
            ee = [0 0];
            if abs(dataProcess(2,j)) > minVel
                for i = 1:2

                    outD(j) = abs((dataProcess(2,j+1)-dataProcess(2,j))/(dataProcess(1,j+1)-dataProcess(1,j)));

                    % rate of change for careful/not careful
                    xd = abs((e2{i}(2)/e2{i}(1)));

                    % error (real velocity - desired velocity)
                    ed = -1*abs(outD(j) - xd(:,1));
                    ee(i) = ed;   

                    %Xd(j,i) = xd(:,1)';
                    %Xd = [Xd, xd(:,1)'];
                    b_d(i) = epsilon * (ed' + (b(i) - 0.5)*norm(xd(:,1), 2)); 

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
        end

        % save to variable
        trainClass(:,k) = b';
        
        % clear variables
        clear testXn
        clear test3
        
        % calculate the response time
        [row, col] = find(B == 1);
        if row ~= 0
            h1 = row(1); % pick first one
        else
            h1 = length(B);  % pick last one
        end
        h2 = h1/length(B); % get percentage of response time
        response(:,k) = h2;
        
        % calculate time of handovers
        time(:,k) = length(B)*(1/120)
        
    end

    resp_avg = mean(response);  % average of response time
    time_avg = mean(time);      % average of handover time
    
    clc
    sumtrainClass = sum(trainClass,2);
    Classification = [sumtrainClass(1)/length(Data); sumtrainClass(2)/length(Data)];
    
end
