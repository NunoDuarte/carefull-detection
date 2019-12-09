function intDSfollower(F, default, options, K, sim)

if default
    %% User Parameters and Setting
    sim = 1; % simulate
    % Training parameters
    K = 3; % Number of Gaussian functions

    % A set of options that will be passed to the solver. Please type 
    % 'doc preprocess_demos' in the MATLAB command window to get detailed
    % information about other possible options.
    options.tol_mat_bias = 10^-5; % A very small positive scalar to avoid
                                  % instabilities in Gaussian kernel [default: 10^-15]

    options.display = 1;          % An option to control whether the algorithm
                                  % displays the output of each iterations [default: true]

    options.tol_stopping=10^-10;  % A small positive scalar defining the stoppping
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
end

  
%% Run SEDS solver

[tmp , tmp, Data, index] = preprocess_demos(F, 0.1, 0.0001); %preprocessing datas

%% This is to take into account the behaviour of the arm in altitude scale
% Data=[];
% dt = 0.1;
% d = size(F2{1},1); %dimensionality of demosntrations
% for i=1:length(F2)
%     clear tmp tmp_d
%     
%     % de-noising data (not necessary)
%     for j=1:d
%         tmp(j,:) = smooth(F2{i}(j,:),25); 
%     end
%     
%     % computing the first time derivative
%     if length(dt)==1
%         tmp_d = diff(tmp,1,2)/dt;
%     else
%         tmp_d = diff(tmp,1,2)./repmat(diff(dt{i}),d,1);
%     end
% 
%     Data = [Data [tmp;tmp_d zeros(d,1)]];
% end

%% 
[Priors_0, Mu_0, Sigma_0] = initialize_SEDS(Data,K); %finding an initial guess for GMM's parameter
[Priors Mu Sigma]=SEDS_Solver(Priors_0,Mu_0,Sigma_0,Data,options); %running SEDS optimization solver

% Draw GMRs for all dimensions (x/y, .x/x, .y/y)
nbVar = size(Data,1);
expData(1,:) = linspace(min(Data(1,:)), max(Data(1,:)), 100);
[expData(2:nbVar,:), expSigma] = GMR(Priors, Mu, Sigma,  expData(1,:), [1], [2:nbVar]);

%%
% plotting the result
figure()
hold on; box on
[h1, h2] = plotGMM(Mu(1:2,:), Sigma(1:2,1:2,:), [0.6 1.0 0.6], 1,[0.6 1.0 0.6]);

[h3  , h4] = plotGMM(expData([1,2],:), expSigma([1,2],[1,2],:), [0 0 .8], 2);
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
    x0 = [-0.06; 0.1];
    % the action of the follower are still not correct since it goes back
    % before going forward. It probably has to do with the observed data
    fn_handle = @(x) GMR(Priors,Mu,Sigma,x,1:d,d+1:2*d);
    [x, xd, tmp, xT]=Simulation(x0,Data(1:d,200),fn_handle,opt_sim); %running the simulator
    % D = plot_results(x,xd,Data,xT,Mu,Sigma);
end

%% Streamlines 3D
figure('name','Streamlines','position',[800   90   560   320])

quality='low';
% plot real data
plot3(Data(1,:), Data(2,:), Data(3,:), 'r.')

if strcmpi(quality,'high')
    nx=600;
    ny=600;
elseif strcmpi(quality,'medium')
    nx=400;
    ny=400;
else
    nx=10;
    ny=10;
    nz = ny;
end

hold on

ax.XLim = xlim;
ax.YLim = ylim;
ax.ZLim = zlim;
ax_x=linspace(ax.XLim(1),ax.XLim(2),nx); %computing the mesh points along each axis
ax_y=linspace(ax.YLim(1),ax.YLim(2),ny); %computing the mesh points along each axis
ax_z=linspace(ax.ZLim(1),ax.ZLim(2),nz); %computing the mesh points along each axis
[x_tmp, y_tmp, z_tmp]=meshgrid(ax_x,ax_y, ax_z); %meshing the input domain
x=[x_tmp(:) y_tmp(:) z_tmp(:)]';

xd = GMR(Priors,Mu,Sigma,x,1:d,d+1:2*d); %compute outputs
x=[x_tmp(:) y_tmp(:) z_tmp(:)];
% streamlines
quiver3(x(:,1),x(:,2),x(:,3),xd(1,:)',xd(2,:)',xd(3,:)',3,'color','blue');

end

