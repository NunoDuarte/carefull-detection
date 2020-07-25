function genDS(F, default, options, K, ~, type, dim)

if default
    %% User Parameters and Setting
    sim = 0; % simulate
    % Training parameters
    K = 6; % Number of Gaussian functions

    % A set of options that will be passed to the solver. Please type 
    % 'doc preprocess_demos' in the MATLAB command window to get detailed
    % information about other possible options.
    options.tol_mat_bias = 10^-5; % A very small positive scalar to avoid
                                  % instabilities in Gaussian kernel [default: 10^-15]

    options.display = 1;          % An option to control whether the algorithm
                                  % displays the output of each iterations [default: true]

    options.tol_stopping= 10^-10;  % A small positive scalar defining the stoppping
                                   % tolerance for the optimization solver [default: 10^-10]

    options.max_iter = 1000;       % Maximum number of iteration for the solver [default: i_max=1000]

    options.objective = 'likelihood';    % 'likelihood': use likelihood as criterion to
                                  % optimize parameters of GMM
                                  % 'mse': use mean square error as criterion to
                                  % optimize parameters of GMM
                                  % 'direction': minimize the angle between the
                                  % estimations and demonstrations (the velocity part)
                                  % to optimize parameters of GMM                              
                                  % [default: 'mse']
else
    sim = 0; % simulate
    options.tol_mat_bias = 10^-5; % A very small positive scalar to avoid
    options.display = 1;          % An option to control whether the algorithm
    options.tol_stopping= 10^-10;  % A small positive scalar defining the stoppping
    options.max_iter = 1000;       % Maximum number of iteration for the solver [default: i_max=1000]
    options.objective = 'likelihood';    % 'likelihood': use likelihood as criterion to
    
end

  
%% Run SEDS solver

[tmp , tmp, Data, index] = preprocess_demos(F, 0.02, 0.0001); %preprocessing datas

% Datanew = [];
% % Add this for QMUL data
% id = find(Data(1,:) == 0);
% for i=1:length(id)
%     if i == 1
%         [maxVel, idVel] = min(Data(2,1:id(1)));
%         count = 0;
%     else
%         [maxVel, idVel] = min(Data(2,id(i-1):id(i)));
%         count = id(i-1)-1;
%     end
%     
%     Datanew = [Datanew, Data(:,idVel+count:id(i))];
% end
% 
% Data = Datanew;
%% 
[Priors_0, Mu_0, Sigma_0] = initialize_SEDS(Data,K); %finding an initial guess for GMM's parameter
[Priors Mu Sigma]=SEDS_Solver(Priors_0,Mu_0,Sigma_0,Data,options); %running SEDS optimization solver

%% Save to files

if type == 'F'
    save('PriorsF.mat', 'Priors')
    save('MuF.mat', 'Mu')
    save('SigmaF.mat', 'Sigma')
    
elseif type == 'E'
    save('PriorsE.mat', 'Priors')
    save('MuE.mat', 'Mu')
    save('SigmaE.mat', 'Sigma')
end
    
%% Draw GMRs for all dimensions (x/y, .x/x, .y/y)
nbVar = size(Data,1);
expData(1,:) = linspace(min(Data(1,:)), max(Data(1,:)), 100);
[expData(2:nbVar,:), expSigma] = GMR(Priors, Mu, Sigma,  expData(1,:), [1], [2:nbVar]);

%%
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
    
    %% Simulation
    % A set of options that will be passed to the Simulator. Please type 
    % 'doc preprocess_demos' in the MATLAB command window to get detailed
    % information about each option.
    opt_sim.dt = 0.05;
    opt_sim.i_max = 3000;
    opt_sim.tol = 0.001;
    
    d = size(Data,1)/2; %dimension of data
    
    % x0_all = [];
    % for a=1:200:length(Data)
    %     x0_all =[x0_all, Data(1:d,a)]; %finding initial points of all demonstrations
    % end
    % % an example
    % var = 0.1;
    % testSim(1,:) = linspace(min(var(1,:)), max(var(1,:)), 100);
    % [testSim(2:nbVar,:), testSimSigma] = GMR(Priors, Mu, Sigma,  testSim(1,:), [1], [2:nbVar]);
    
    if sim
        %<comment>
        fprintf('\nNow we can run simulator starting from initial points of all demos.\n')
        fprintf('Press Enter to start simulator.\n')
        %</comment>
    
        %x0 = [0.43763; 0.09439];
        x0 = [0.06; -0.06; 0.1];
        % the action of the follower are still not correct since it goes back
        % before going forward. It probably has to do with the observed data
        fn_handle = @(x) GMR(Priors,Mu,Sigma,x,1:d,d+1:2*d);
        [x, xd, tmp, xT]=Simulation(x0,Data(1:d,200),fn_handle,opt_sim); %running the simulator
        % D = plot_results(x,xd,Data,xT,Mu,Sigma);
    end
end
% 
% %% Streamlines
% if dim == '3D'
%     % 3D
%     figure('name','Streamlines','position',[800   90   560   320])
% 
%     quality='low';
%     % plot real data
%     plot3(Data(1,:), Data(2,:), Data(3,:), 'r.')
% 
%     if strcmpi(quality,'high')
%         nx=600;
%         ny=600;
%     elseif strcmpi(quality,'medium')
%         nx=400;
%         ny=400;
%     else
%         nx=10;
%         ny=10;
%         nz = ny;
%     end
% 
%     hold on
% 
%     ax.XLim = xlim;
%     ax.YLim = ylim;
%     ax.ZLim = zlim;
%     ax_x=linspace(ax.XLim(1),ax.XLim(2),nx); %computing the mesh points along each axis
%     ax_y=linspace(ax.YLim(1),ax.YLim(2),ny); %computing the mesh points along each axis
%     ax_z=linspace(ax.ZLim(1),ax.ZLim(2),nz); %computing the mesh points along each axis
%     [x_tmp, y_tmp, z_tmp]=meshgrid(ax_x,ax_y, ax_z); %meshing the input domain
%     x=[x_tmp(:) y_tmp(:) z_tmp(:)]';
% 
%     xd = GMR(Priors,Mu,Sigma,x,1:d,d+1:2*d); %compute outputs
%     x=[x_tmp(:) y_tmp(:) z_tmp(:)];
%     % streamlines
%     q = quiver3(x(:,1),x(:,2),x(:,3),xd(1,:)',xd(2,:)',xd(3,:)',3,'color','blue');
% 
%     % Get the magnitude of the Velocity
%     xdnorm = vecnorm(xd);
%     xdmax = max(xdnorm);
%     xdmin = min(xdnorm);
%     
%     %% Color Map
%     %// Compute the magnitude of the vectors
%     mags = sqrt(sum(cat(2, q.UData(:), q.VData(:), ...
%                 reshape(q.WData, numel(q.UData), [])).^2, 2));
% 
%     %// Get the current colormap
%     currentColormap = colormap(jet);
% 
%     %// Now determine the color to make each arrow using a colormap
%     [~, ~, ind] = histcounts(mags, size(currentColormap, 1));
% 
%     %// Now map this to a colormap to get RGB
%     cmap = uint8(ind2rgb(ind(:), currentColormap) * 255);
%     cmap(:,:,4) = 255;
%     cmap = permute(repmat(cmap, [1 3 1]), [2 1 3]);
% 
%     %// We repeat each color 3 times (using 1:3 below) because each arrow has 3 vertices
%     set(q.Head, ...
%         'ColorBinding', 'interpolated', ...
%         'ColorData', reshape(cmap(1:3,:,:), [], 4).');   %'
% 
%     %// We repeat each color 2 times (using 1:2 below) because each tail has 2 vertices
%     set(q.Tail, ...
%         'ColorBinding', 'interpolated', ...
%         'ColorData', reshape(cmap(1:2,:,:), [], 4).');
% 
%     h = colorbar;
%     set(h, 'ylim', [xdmin xdmax])
%     caxis([xdmin, xdmax]);
%     
% elseif dim == '2D'
%     %%
%     % plotting the result
%     figure('name','Results from Simulation','position',[265   200   520   720])
%     sp(1)=subplot(3,1,1);
%     hold on; box on
%     plotGMM(Mu(1:2,:), Sigma(1:2,1:2,:), [0.6 1.0 0.6], 1,[0.6 1.0 0.6]);
%     plot(Data(1,:),Data(2,:),'r.') 
%     xlabel('$\xi_1 (mm)$','interpreter','latex','fontsize',15);
%     ylabel('$\xi_2 (mm)$','interpreter','latex','fontsize',15);
%     title('Simulation Results')
% 
%     sp(2)=subplot(3,1,2);
%     hold on; box on
%     plotGMM(Mu([1 3],:), Sigma([1 3],[1 3],:), [0.6 1.0 0.6], 1,[0.6 1.0 0.6]);
%     plot(Data(1,:),Data(3,:),'r.')
%     xlabel('$\xi_1 (mm)$','interpreter','latex','fontsize',15);
%     ylabel('$\dot{\xi}_1 (mm/s)$','interpreter','latex','fontsize',15);
% 
%     sp(3)=subplot(3,1,3);
%     hold on; box on
%     plotGMM(Mu([2 4],:), Sigma([2 4],[2 4],:), [0.6 1.0 0.6], 1,[0.6 1.0 0.6]);
%     plot(Data(2,:),Data(4,:),'r.')
%     xlabel('$\xi_2 (mm)$','interpreter','latex','fontsize',15);
%     ylabel('$\dot{\xi}_2 (mm/s)$','interpreter','latex','fontsize',15);
% 
%     for i=1:3
%         axis(sp(i),'tight')
%         ax=get(sp(i));
%         axis(sp(i),...
%             [ax.XLim(1)-(ax.XLim(2)-ax.XLim(1))/10 ax.XLim(2)+(ax.XLim(2)-ax.XLim(1))/10 ...
%             ax.YLim(1)-(ax.YLim(2)-ax.YLim(1))/10 ax.YLim(2)+(ax.YLim(2)-ax.YLim(1))/10]);
%         plot(sp(i),0,0,'k*','markersize',15,'linewidth',3)
%         if i==1
%             D = axis(sp(i));
%         end
%     end
% 
%     figure('name','Streamlines','position',[800   90   560   320])
%     % Plot colormap
%     ax.XLim = D(1:2);
%     ax.YLim = D(3:4);
%     limits = [ax.XLim(1) ax.XLim(2) ax.YLim(1) ax.YLim(2)];  
%     axlim = limits;
%     nx = 20; ny = 20;
%     ax_x=linspace(axlim(1),axlim(2),nx); %computing the mesh points along each axis
%     ax_y=linspace(axlim(3),axlim(4),ny); %computing the mesh points along each axis
%     [x_tmp, y_tmp]=meshgrid(ax_x,ax_y); %meshing the input domain
%     x=[x_tmp(:), y_tmp(:)]';
%     
%     d = 2; % 2D
%     xd = GMR(Priors,Mu([1 2 4 5],:),Sigma([1 2 4 5],[1 2 4 5],:),x,1:d,d+1:2*d); 
%     % or xd = GMR(Priors,Mu,Sigma,x,1:d/2,d/2+1:d); %compute outputs
%     % or xd = GMR(Priors,Mu,Sigma,x,1,d);,l 
%     
%     
%     % Get the magnitude of the Velocity
%     xdnorm = vecnorm(xd);
%     z_tmp = xdnorm;
%     h = pcolor(x_tmp,y_tmp,reshape(xdnorm,nx,ny));
%     
%     set(h,'linestyle','none');
%     load whiteCopperColorMap;
%     colormap(cm);
%     colorbar;
%     caxis([min(z_tmp), max(z_tmp)]);
% %     
%     % plotting streamlines
%     plotStreamLines(Priors,Mu([1 2 4 5],:),Sigma([1 2 4 5],[1 2 4 5],:),D)
%     hold on
%     plot(Data(1,:),Data(2,:),'r.')
%     plot(0,0,'k*','markersize',15,'linewidth',3)
%     xlabel('$\xi_1 (mm)$','interpreter','latex','fontsize',15);
%     ylabel('$\xi_2 (mm)$','interpreter','latex','fontsize',15);
%     title('Streamlines of the model')
%     set(gca,'position',[0.1300    0.1444    0.7750    0.7619])
    

%end

end
