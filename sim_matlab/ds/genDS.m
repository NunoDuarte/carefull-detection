function K = genDS(F, default, options, K, ~, samp_freq, type)

    if default
        %% User Parameters and Setting
        % Training parameters
        K = 2; % Number of Gaussian functions
        options.tol_mat_bias = 10^-3; % A very small positive scalar to avoid
                                      % instabilities in Gaussian kernel [default: 10^-15]
        options.display = 1;          % An option to control whether the algorithm
                                      % displays the output of each iterations [default: true]
        options.tol_stopping= 10^-10;  % A small positive scalar defining the stoppping
                                       % tolerance for the optimization solver [default: 10^-10]
        options.max_iter = 1000;       % Maximum number of iteration for the solver [default: i_max=1000]
        options.objective = 'likelihood';    % 'likelihood': use likelihood as criterion to
        options.plot = 1;               % plot the GMMs

    else
        options.tol_mat_bias = 10^-3; % A very small positive scalar to avoid
        options.display = 1;          % An option to control whether the algorithm
        options.tol_stopping= 10^-10;  % A small positive scalar defining the stoppping
        options.max_iter = 1000;       % Maximum number of iteration for the solver [default: i_max=1000]
        options.objective = 'likelihood';    % 'likelihood': use likelihood as criterion to
        options.plot = 0;               % do NOT plot the GMMs

    end

    %% Run SEDS solver

    [tmp , tmp, Data, index] = preprocess_demos(F, samp_freq, 0.0001); %preprocessing data

    % THIS IS TO EXTRACT JUST THE ACCELERATION PHASE
    Datanew = [];
    Data(abs(Data)<10e-10)=0;  %% round really small numbers
    id = find(Data(1,:) == 0);
    for i=1:length(id)
        % extract the data until it reaches the maximum velocity 
        if i == 1
            [~, idVel] = max(Data(2,1:id(1)));
            count = 0;
        else
            [~, idVel] = max(Data(2,id(i-1):id(i)));
            count = id(i-1)-1;
        end

        Datanew = [Datanew, Data(:,idVel+count:id(i))];
    end
    Data = Datanew;
    
    %% 
    [Priors_0, Mu_0, Sigma_0] = initialize_SEDS(Data,K); %finding an initial guess for GMM's parameter
    [Priors Mu Sigma]=SEDS_Solver(Priors_0,Mu_0,Sigma_0,Data,options); %running SEDS optimization solver

    %% Save to files

    if type == 'F'
        save('param/PriorsF.mat', 'Priors')
        save('param/MuF.mat', 'Mu')
        save('param/SigmaF.mat', 'Sigma')

    elseif type == 'E'
        save('param/PriorsE.mat', 'Priors')
        save('param/MuE.mat', 'Mu')
        save('param/SigmaE.mat', 'Sigma')
    end

    %% Draw GMRs for all dimensions (x/y, .x/x, .y/y)
    nbVar = size(Data,1);
    expData(1,:) = linspace(min(Data(1,:)), max(Data(1,:)), 100);
    [expData(2:nbVar,:), expSigma] = GMR(Priors, Mu, Sigma,  expData(1,:), [1], [2:nbVar]);

    %%
    if options.plot
        if nbVar == 2
            % plotting the result
            figure()
            hold on; box on
            [h1, h2] = plotGMM(Mu(1:2,:), Sigma(1:2,1:2,:), [0.6 1.0 0.6], 1,[0.6 1.0 0.6]);

            [h3  , h4] = plotGMM(expData([1:2],:), expSigma([1],[1],:), [0 0 .8], 2);
            axis([min(Data(1,:))-0.01 max(Data(1,:))+0.01 min(Data(2,:))-0.01 max(Data(2,:))+0.01]);
            h3 = plot(Data(1,:),Data(2,:), 'r.');
            legend([h1 h4 h3], 'Gaussian Mixture Components', 'Mean Regression Signal', 'Recorded Demonstrations');
            xlabel('$\xi_x (m)$','interpreter','latex','fontsize',15);
            ylabel('$\dot{\xi}_x (m/s)$','interpreter','latex','fontsize',15);

        elseif nbVar > 2
            % plotting the result
            figure()
            hold on; box on
            [h1, h2] = plotGMM(Mu(1:2,:), Sigma(1:2,1:2,:), [0.6 1.0 0.6], 1,[0.6 1.0 0.6]);

            [h3  , h4] = plotGMM(expData([1:2],:), expSigma([1],[1],:), [0 0 .8], 2);
            axis([min(Data(1,:))-0.01 max(Data(1,:))+0.01 min(Data(2,:))-0.01 max(Data(2,:))+0.01]);
            h3 = plot(Data(1,:),Data(2,:), 'r.');
            legend([h1 h4 h3], 'Gaussian Mixture Components', 'Mean Regression Signal', 'Recorded Demonstrations');
            xlabel('$\xi_y (m)$','interpreter','latex','fontsize',15);
            ylabel('$\xi_z (m)$','interpreter','latex','fontsize',15);
            % -----------//------------

            figure()
            hold on; box on
            plotGMM(Mu([1 3],:), Sigma([1 3],[1 3],:), [0.6 1.0 0.6], 1,[0.6 1.0 0.6]);
            plot(Data(1,:),Data(3,:),'r.')

            plotGMM(expData([1 3],:), expSigma([1 3],[1 3],:), [0 0 .8], 2);
            axis([min(Data(1,:))-0.01 max(Data(1,:))+0.01 min(Data(3,:)) max(Data(3,:))]);
            xlabel('$\xi_y (m)$','interpreter','latex','fontsize',15);
            ylabel('$\dot{\xi}_y (m/s)$','interpreter','latex','fontsize',15);

            % -----------//------------

            figure()
            hold on; box on
            plotGMM(Mu([2 4],:), Sigma([2 4],[2 4],:), [0.6 1.0 0.6], 1,[0.6 1.0 0.6]);
            plot(Data(2,:),Data(4,:),'r.')

            plotGMM(expData([2 4],:), expSigma([2 3],[2 3],:), [0 0 .8], 2);
            axis([min(Data(2,:))-0.01 max(Data(2,:))+0.01 min(Data(4,:))-0.01 max(Data(4,:))+0.01]);
            xlabel('$\xi_z (m)$','interpreter','latex','fontsize',15);
            ylabel('$\dot{\xi}_z (m/s)$','interpreter','latex','fontsize',15);

        end
    end
end
