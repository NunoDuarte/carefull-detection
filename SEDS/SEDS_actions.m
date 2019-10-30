%function SEDS_actions

%% Load Data
GMR_actions_SEDS

%<comment>
fprintf('Model is loaded successfully.\n')
%</comment>

%% convert data into cells

%% User Parameters and Setting
% Training parameters
K = 3; %Number of Gaussian functions

% A set of options that will be passed to the solver. Please type 
% 'doc preprocess_demos' in the MATLAB command window to get detailed
% information about other possible options.
options.tol_mat_bias = 10^-6; % A very small positive scalar to avoid
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
%% Process data to cells
% I need to convert my data into cells 
% 1. 2by2 - no time (time is given by dt)

Dataold = Data;
% try not to provide the time variable has data!
for a=1:count
    
    demosN{a} = Dataold([2 3],200*(a-1)+1:200*(a-1)+200);
   
end

% Dataold = Data;
% demosN{1} = Dataold(2:end-1,1:200); % just 2 DOF
% demosN{2} = Dataold(2:end-1,201:400);
% demosN{3} = Dataold(2:end-1,401:600);

%% Run SEDS solver

[tmp , tmp, Data, index] = preprocess_demos(demosN, 0.1, 0.0001); %preprocessing datas
[Priors_0, Mu_0, Sigma_0] = initialize_SEDS(Data,K); %finding an initial guess for GMM's parameter
[Priors Mu Sigma]=SEDS_Solver(Priors_0,Mu_0,Sigma_0,Data,options); %running SEDS optimization solver

%% Simulation

% A set of options that will be passed to the Simulator. Please type 
% 'doc preprocess_demos' in the MATLAB command window to get detailed
% information about each option.
opt_sim.dt = 0.05;
opt_sim.i_max = 3000;
opt_sim.tol = 0.001;

d = size(Data,1)/2; %dimension of data

x0_all = [];
for a=1:200:length(Data)
    x0_all =[x0_all, Data(1:d,a)]; %finding initial points of all demonstrations
end

%<comment>
fprintf('\nNow we can run simulator starting from initial points of all demos.\n')
fprintf('Press Enter to start simulator.\n')
pause
%</comment>
% fn_handle = @(x) GMR(Priors,Mu,Sigma,x,1:d,d+1:2*d);
% [x, xd, tmp, xT]=Simulation(x0_all,Data(1:d,200),fn_handle,opt_sim); %running the simulator
%D = plot_results(x,xd,Data,xT,Mu,Sigma);

% 
nbVar = size(Data,1);
expData(1,:) = linspace(min(Data(1,:)), max(Data(1,:)), 100);
[expData(2:nbVar,:), expSigma] = GMR(Priors, Mu, Sigma,  expData(1,:), [1], [2:nbVar]);

%<comment>
fprintf('We continue our evaluation by plotting streamlines of the model.\n')
fprintf('Press Enter to proceed.\n')
pause
%</comment>

%%
% plotting the result
figure('name','Results from Simulation','position',[265   200   520   720])
figure()
hold on; box on
[h1, h2] = plotGMM(Mu(1:2,:), Sigma(1:2,1:2,:), [0.6 1.0 0.6], 1,[0.6 1.0 0.6]);

[h3  , h4] = plotGMM(expData([1,2],:), expSigma([1,2],[1,2],:), [0 0 .8], 2);
axis([min(Data(1,:))-0.01 max(Data(1,:))+0.01 min(Data(2,:))-0.01 max(Data(2,:))+0.01]);
h3 = plot(Data(1,:),Data(2,:), 'r.');
legend([h1 h4 h3], 'Gaussian Mixture Components', 'Mean Regression Signal', 'Recorded Demonstrations');
%xlabel('x_1','fontsize',16); ylabel('x_2','fontsize',16);

xlabel('$\xi_1 (mm)$','interpreter','latex','fontsize',15);
ylabel('$\xi_2 (mm)$','interpreter','latex','fontsize',15);
%legend('Demonstrations', '$nu$', '$conv$', 'reproduction');
%title('Simulation Results')

% -----------//------------

figure()
hold on; box on
plotGMM(Mu([1 3],:), Sigma([1 3],[1 3],:), [0.6 1.0 0.6], 1,[0.6 1.0 0.6]);
plot(Data(1,:),Data(3,:),'r.')

plotGMM(expData([1 3],:), expSigma([1 3],[1 3],:), [0 0 .8], 2);
axis([min(Data(1,:))-0.01 max(Data(1,:))+0.01 min(Data(3,:))-0.01 max(Data(3,:))+0.01]);

xlabel('$\xi_1 (mm)$','interpreter','latex','fontsize',15);
ylabel('$\dot{\xi}_1 (mm/s)$','interpreter','latex','fontsize',15);

% -----------//------------

figure()
hold on; box on
plotGMM(Mu([2 4],:), Sigma([2 4],[2 4],:), [0.6 1.0 0.6], 1,[0.6 1.0 0.6]);
plot(Data(2,:),Data(4,:),'r.')

plotGMM(expData([2 4],:), expSigma([2 3],[2 3],:), [0 0 .8], 2);
axis([min(Data(2,:))-0.01 max(Data(2,:))+0.01 min(Data(4,:))-0.01 max(Data(4,:))+0.01]);

xlabel('$\xi_2 (mm)$','interpreter','latex','fontsize',15);
ylabel('$\dot{\xi}_2 (mm/s)$','interpreter','latex','fontsize',15);

% -----------//------------

for i=1:size(x,3)
    plot(sp(1),x(1,:,i),x(2,:,i),'linewidth',2)
    plot(sp(2),x(1,:,i),xd(1,:,i),'linewidth',2)
    plot(sp(3),x(2,:,i),xd(2,:,i),'linewidth',2)
    plot(sp(1),x(1,1,i),x(2,1,i),'ok','markersize',5,'linewidth',5)
    plot(sp(2),x(1,1,i),xd(1,1,i),'ok','markersize',5,'linewidth',5)
    plot(sp(3),x(2,1,i),xd(2,1,i),'ok','markersize',5,'linewidth',5)
end

for i=1:3
    axis(sp(i),'tight')
    ax=get(sp(i));
    axis(sp(i),...
        [ax.XLim(1)-(ax.XLim(2)-ax.XLim(1))/10 ax.XLim(2)+(ax.XLim(2)-ax.XLim(1))/10 ...
        ax.YLim(1)-(ax.YLim(2)-ax.YLim(1))/10 ax.YLim(2)+(ax.YLim(2)-ax.YLim(1))/10]);
    plot(sp(i),0,0,'k*','markersize',15,'linewidth',3)
    if i==1
        D = axis(sp(i));
    end
end

% plotting streamlines
figure('name','Streamlines','position',[800   90   560   320])
plotStreamLines(Priors,Mu,Sigma,D)
hold on
plot(Data(1,:),Data(2,:),'r.')
plot(0,0,'k*','markersize',15,'linewidth',3)
xlabel('$\xi_1 (mm)$','interpreter','latex','fontsize',15);
ylabel('$\xi_2 (mm)$','interpreter','latex','fontsize',15);
title('Streamlines of the model')
set(gca,'position',[0.1300    0.1444    0.7750    0.7619])




