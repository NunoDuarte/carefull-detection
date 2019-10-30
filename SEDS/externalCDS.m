%function externalCDS(demosNorm, default, K, dt, tol_cutting) 

if default 
    sim = 1; % simulate
    %% User Parameters and Setting
    % Training parameters
%     K = 2; % Number of Gaussian functions
%     dt = 0.1; % 
%     tol_cutting = 0.0001; % trim data
    K = 3; % Number of Gaussian functions
    dt = 0.001; % 
    tol_cutting = 0.001; % trim data
    
else
    sim = 0;
end

%% Training of GMM by EM algorithm, initialized by k-means clustering.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% preprocessing is pretty much shifting the data to end in zero
% and adding the derivatives of both variables

% Note= in preprocess I needed to invert the data so it wouldn't look that at I
% had norm of dimensions negative!
%[tmp , tmp, Data, index] = preprocess_demos(demosNorm, dt, tol_cutting); %preprocessing datas

%% This is to take into account the behaviour of the arm in altitude scale
Data=[];
dt = 0.1;
d = size(demosNorm{1},1); %dimensionality of demosntrations
for i=1:length(demosNorm)
    clear tmp tmp_d
    
    % de-noising data (not necessary)
    for j=1:d
        tmp(j,:) = smooth(demosNorm{i}(j,:),25); 
    end
    
    % computing the first time derivative
    if length(dt)==1
        tmp_d = diff(tmp,1,2)/dt;
    else
        tmp_d = diff(tmp,1,2)./repmat(diff(dt{i}),d,1);
    end

    Data = [Data [tmp;tmp_d zeros(d,1)]];
end

%%
[Priors, Mu, Sigma] = EM_init_kmeans(Data, K);
[Priors, Mu, Sigma] = EM(Data, Priors, Mu, Sigma);

%% Simulation

% A set of options that will be passed to the Simulator. Please type 
% 'doc preprocess_demos' in the MATLAB command window to get detailed
% information about each option.
opt_sim.dt = dt;
opt_sim.i_max = 3000;    
opt_sim.tol = tol_cutting;

d = size(Data,1)/2; %dimension of data

x0_all = [];
for a=1:200:length(Data)
    x0_all =[x0_all, Data(1:d,a)]; %finding initial points of all demonstrations
end

%<comment>
fprintf('\nNow we can run simulator starting from initial points of all demos.\n')
fprintf('Press Enter to start simulator.\n')

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
%xlabel('x_1','fontsize',16); ylabel('x_2','fontsize',16);

xlabel('$\xi_1 (m)$','interpreter','latex','fontsize',15);
ylabel('$\xi_2 (m)$','interpreter','latex','fontsize',15);

% -----------//------------

figure()
hold on; box on
plotGMM(Mu([1 3],:), Sigma([1 3],[1 3],:), [0.6 1.0 0.6], 1,[0.6 1.0 0.6]);
plot(Data(1,:),Data(3,:),'r.')

plotGMM(expData([1 3],:), expSigma([1 3],[1 3],:), [0 0 .8], 2);
axis([min(Data(1,:))-0.01 max(Data(1,:))+0.01 min(Data(3,:)) max(Data(3,:))]);

xlabel('$\xi_1 (m)$','interpreter','latex','fontsize',15);
ylabel('$\dot{\xi}_1 (m/s)$','interpreter','latex','fontsize',15);

% -----------//------------

figure()
hold on; box on
plotGMM(Mu([2 4],:), Sigma([2 4],[2 4],:), [0.6 1.0 0.6], 1,[0.6 1.0 0.6]);
plot(Data(2,:),Data(4,:),'r.')

plotGMM(expData([2 4],:), expSigma([2 3],[2 3],:), [0 0 .8], 2);
axis([min(Data(2,:))-0.01 max(Data(2,:))+0.01 min(Data(4,:))-0.01 max(Data(4,:))+0.01]);

xlabel('$\xi_2 (m)$','interpreter','latex','fontsize',15);
ylabel('$\dot{\xi}_2 (m/s)$','interpreter','latex','fontsize',15);

% -----------//------------

%% Simulation
% A set of options that will be passed to the Simulator. Please type 
% 'doc preprocess_demos' in the MATLAB command window to get detailed
% information about each option.
opt_sim.dt = dt;
opt_sim.i_max = 3000;
opt_sim.tol = tol_cutting;

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
    x0 = [-0.867747965689736; -0.040348046814583];
    %x0 = [0.693438571834904;0.103397617292089];
    %x0 = [0.557550355449729;0.0987146225656092];
    %x0 = [0.386377103034900;0.0809400708239847];
    %x0 = [0.173539611599384;0.0430032553750822];
    %x0 = [0.0412476510824008;-0.0249994471543020];
    %x0 = [-0.3; -0.4];
    % the action of the follower are still not correct since it goes back
    % before going forward. It probably has to do with the observed data
    fn_handle = @(x) GMR(Priors,Mu,Sigma,x,1:d,d+1:2*d);
    [x, xd, tmp, xT]=Simulation(x0,Data(1:d,200),fn_handle,opt_sim); %running the simulator
    % D = plot_results(x,xd,Data,xT,Mu,Sigma);
end

%end





