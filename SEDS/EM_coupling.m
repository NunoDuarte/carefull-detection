%function EM_coupling

%% Load Data
GMR_actions_SEDS

%<comment>
fprintf('Model is loaded successfully.\n')
%</comment>

%% Coupling function
% Epsilon 1 - norm of 3d coordinates of arm 1

% expected value of the other arm
% norm of 3d coordinate frame of the arm

Dataold = Data;

% try not to provide the time variable has data!
for a=1:count
    
    demosN{a} = Dataold(2:end,200*(a-1)+1:200*(a-1)+200);
   
end

% norm vector
for a=1:count 
   
    N{a} = demosN{a};
    len = length(N{a});
    
    new = zeros(1,count);
    for i=1:len
        
        new(i) = norm(N{a}(:,i));
        Nnorm{1,a} = new;        
    end
end

%% test with the same data (just one dimension - y)
% Epsilon 2 - dimension y of arm 2

for a=1:count
    
    demosNorm{a} = [Nnorm{a}; Dataold(2:2,200*(a-1)+1:200*(a-1)+200)];
    
end    
%% User Parameters and Setting
% Training parameters
K = 4; %Number of Gaussian functions

%% Training of GMM by EM algorithm, initialized by k-means clustering.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% preprocessing is pretty much shifting the data to end in zero
% and adding the derivatives of both variables

% Note= in preprocess I needed to invert the data so it wouldn't look at I
% had norm of dimensions negative!
[tmp , tmp, Data, index] = preprocess_demos(demosNorm, 0.1, 0.0001); %preprocessing datas
[Priors, Mu, Sigma] = EM_init_kmeans(Data, K);
[Priors, Mu, Sigma] = EM(Data, Priors, Mu, Sigma);

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
% %</comment>
% fn_handle = @(x) GMR(Priors,Mu,Sigma,x,1:d,d+1:2*d);
% [x, xd, tmp, xT]=Simulation(x0_all,Data(1:d,200),fn_handle,opt_sim); %running the simulator
% %D = plot_results(x,xd,Data,xT,Mu,Sigma);
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
figure()
hold on; box on
plotGMM(Mu(1:2,:), Sigma(1:2,1:2,:), [0.6 1.0 0.6], 1,[0.6 1.0 0.6]);
plot(Data(1,:),Data(2,:),'r.')

plotGMM(expData([1,2],:), expSigma([1,2],[1,2],:), [0 0 .8], 2);
axis([min(Data(1,:))-0.01 max(Data(1,:))+0.01 min(Data(2,:))-0.01 max(Data(2,:))+0.01]);
%xlabel('x_1','fontsize',16); ylabel('x_2','fontsize',16);

xlabel('$\xi_1 (mm)$','interpreter','latex','fontsize',15);
ylabel('$\xi_2 (mm)$','interpreter','latex','fontsize',15);
title('Simulation Results')

%% -----------//------------

% % an example
% var = 0.1;
% expData(1,:) = linspace(min(var(1,:)), max(var(1,:)), 100);
% [expData(2:nbVar,:), expSigma] = GMR(Priors, Mu, Sigma,  expData(1,:), [1], [2:nbVar]);

%%
figure()
hold on; box on
plotGMM(Mu([1 3],:), Sigma([1 3],[1 3],:), [0.6 1.0 0.6], 1,[0.6 1.0 0.6]);
plot(Data(1,:),Data(3,:),'r.')
 
plotGMM(expData([1 3],:), expSigma([1 3],[1 3],:), [0 0 .8], 2);
axis([min(Data(1,:))-0.01 max(Data(1,:))+0.01 min(Data(3,:)) max(Data(3,:))]);

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

