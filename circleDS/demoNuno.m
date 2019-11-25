addpath(genpath('.'));

X = Wlpolish6(:,1:3);
smoothing = 30;
time = 0.1:0.1:length(X(:,1))*0.1;
T = length(X(:,1));
[Xdata,Xvel,Rdata,Rvel,dt,T,N,m,begin] = prepareData(3,X,time,smoothing,T);

%% Plot the Data
plotData(Xdata,Xvel,Rdata,Rvel,T,m,'cartp');
legend('Data trajectory','Location','northeast');

%% Learn the parameters

j = 1; % default 1
[Priors, Mu, Sigma] = EM_init_kmeans([Xdata';Xvel'], j);
[Priors, Mu, Sigma] = EM([Xdata';Xvel'], Priors, Mu, Sigma);

%% Plot the data with the learned GMM as its parameters

figure; grid on; hold on; view(3);
title('Original data with \omega limit set found');
xlabel('x_1'); ylabel('x_2'); zlabel('x_3');

plotGMM(Mu(1:3,:), Sigma(1:3,1:3,:), [1 0.5 0.5], 4);
plot3(Xdata(:,1), Xdata(:,2), Xdata(:,3), 'r');
legend('Gaussian model','Data trajectories','Location','northeast');

%% Dimensionality reduction
k = 1;

if false
    % Get rotation matrix from PCA performed on covariance matrix of gaussian:
    [Rrot,~] = eig(Sigma(1:N,1:N,k));
    Rrot = Rrot(:,N:-1:1);
    
    % Plot projected (rotated) data
    if true
        figure; hold on; grid on;
        subplot(1,2,1); hold on; grid on;
        title('Original data'); xlabel('x_1'); ylabel('x_2'); zlabel('x_3');
        subplot(1,2,2); hold on; grid on;
        title('Projected data'); xlabel('e_1'); ylabel('e_2'); zlabel('e_3');
        
        for i = 1:sum(T)
            Xplot = (Rrot \ (Xdata(i,:)' - Mu(1:N,1)))';
            if N == 2
                subplot(1,2,1); plot(Xdata(i,1), Xdata(i,2), 'r.'); grid on; hold on;
                subplot(1,2,2); plot(Xplot(1), Xplot(2), 'r.'); grid on; hold on;
            else
                subplot(1,2,1); view(3); plot3(Xdata(i,1), Xdata(i,2), Xdata(i,3), 'r.'); grid on; hold on;
                subplot(1,2,2); view(3); zlim([-0.5 0.5]); hold on; plot3(Xplot(1), Xplot(2), Xplot(3), 'r.'); grid on; hold on;
            end
        end
    end
else
    % If you are not performing dimensionality reduction
    Rrot = eye(N);
end

% Find Euler angle (or rotation angle if N = 2)
if(N == 3)
    theta0 = rotm2eul(Rrot)
elseif(N == 2)
    theta0 = acos(Rrot(1,1))
end

% Get rotated data and save original data
Xdata_ = Xdata;
Xdata = (Rrot \ (Xdata' - Mu(1:N,k)))';

%% 
% 
% figure; grid on; hold on; view(3);
% title('Original data with \omega limit set found');
% xlabel('x_1'); ylabel('x_2'); zlabel('x_3');
% 
% plotGMM(Mu(1:3,:), Sigma(1:3,1:3,:), [1 0.5 0.5], 4);
% plot3(Xdata(:,1), Xdata(:,2), Xdata(:,3), 'r');
% legend('Gaussian model','Data trajectories','Location','northeast');

%% 

N = 3
Xdata = Xdata_;
Xdata = (Rrot \ (Xdata' - Mu(1:N,k)))';
initial_parameters = [];
% Set initial rho0 to variance of Gaussian model
initial_parameters.rho0 = 3*mean(diag(Sigma(1:N,1:N,1)));
% Set initial values of other parameters
initial_parameters.M = 3;
% Select which parameters to optimize in first objective (M, rho0, (always 0 for R,) a, x0):
initial_parameters.first = [0 1 0 1 0];
% Select which parameters to optimize in second objective (M, (always 0 for rho0,) R, a, x0):
initial_parameters.second = [0 0 1 1 0];        % e.g. [1 1 1 1 0] excludes x0
[params] = optimizePars(initial_parameters,Xdata,dt,begin,1);

% Get parameters learned
rho0 = params.rho0;
M = params.M;
R = params.R;
a = params.a;
% Add the mean of the Gaussian model to x0
if isfield(initial_parameters,'x0') && isempty(initial_parameters.x0)
    x0 = -Mu(1:N,k)';
else
    x0 = (Rrot * params.x0' - Mu(1:N,k))';
end
params.x0 = x0;
params.Rrot = Rrot;
disp(params);

%% Plot learned dynamics with original data and new trajectories
% Get unrotated data
Xdata = Xdata_;

% Plot original data
figure; title('Dynamical flow in cartesian coordinates'); hold on; grid on;
if N == 2
    plot(Xdata(:,1),Xdata(:,2),'r.'); hold on;
else
    view(3);
    plot3(Xdata(1:T(1),1),Xdata(1:T(1),2),Xdata(1:T(1),3),'r'); hold on;
    for i = 2:m
        plot3(Xdata(sum(T(1:i-1))+1:sum(T(1:i)),1),...
            Xdata(sum(T(1:i-1))+1:sum(T(1:i)),2),...
            Xdata(sum(T(1:i-1))+1:sum(T(1:i)),3),'r'); hold on;
    end
end

% Plot streamlines / arrows to show dynamics
ylabel('x_2'); yl = ylim;
xlabel('x_1'); xl = xlim;
if N > 2
    zlabel('x_3'); zl = zlim;
    ngrid = 7;
end

if N == 2
    [Xs,Ys] = meshgrid(linspace(xl(1),xl(2),20),linspace(yl(1),yl(2),20));
    X_plot = [Xs(:), Ys(:)];
else
    [Xs,Ys,Zs] = meshgrid(linspace(xl(1),xl(2),ngrid),...
        linspace(yl(1),yl(2),ngrid),linspace(zl(1),zl(2),ngrid));
    X_plot = [Xs(:), Ys(:), Zs(:)];
end
Y = zeros(size(X_plot));
for i= 1:size(X_plot,1)
    [r2,dr2] = DS(X_plot(i,:),params);
    Y(i,1:N) = sph2cartvelocities(r2,dr2);
end

if N == 2
    streamslice(Xs,Ys,reshape(Y(:,1),20,20),...
        reshape(Y(:,2),20,20),'method','cubic');
else
    quiver3(X_plot(:,1),X_plot(:,2),X_plot(:,3),Y(:,1),Y(:,2),Y(:,3),'color','black');
end

%% Test dynamics for T time steps
X0 = Xdata(1,:);
X_s = []; Xvel_s = [];
for j = 1:size(X0,1)
    X = X0(j,:);
    for i = 1:100
        X_prev = X;
        [r2,dr2] = DS(X,params);
        next_r = r2 + dr2*dt;
        X = (Rrot*(hyper2cart(next_r)./a)')' - x0;
        X_s = [X_s; X];
        Xvel_s = [Xvel_s; sph2cartvelocities(r2,dr2)];
        if N == 2
            plot(X(1),X(2),'k.'); hold on; grid on;
        else
            plot3(X(1),X(2),X(3),'k.'); hold on; grid on;
        end
    end
end
%% % 
X0 = [-0.91, -0.61, 0.935];
X_s = []; Xvel_s = [];
for j = 1:size(X0,1)
    X = X0(j,:);
    for i = 1:T(1)
        X_prev = X;
        [r2,dr2] = DS(X,params);
        next_r = r2 + dr2*dt;
        X = (Rrot*(hyper2cart(next_r)./a)')' - x0;
        X_s = [X_s; X];
        Xvel_s = [Xvel_s; sph2cartvelocities(r2,dr2)];
        if N == 2
            plot(X(1),X(2),'k.'); hold on; grid on;
        else
            plot3(X(1),X(2),X(3),'k.'); hold on; grid on;
        end
    end
end
% % 
% %% Test dynamics for T time steps
% X0 = [-0.91, -0.61, 0.935];
% Xvel_DS = []; Rad_s = []; X_s = []; Rad_vel = [];
% for j = 1:size(X0,1)
%     X = X0(j,:);
%     for i = 1:100
%         Rad = r(X) + dr(r(X)) * dt;
%         Rad_s = [Rad_s; Rad];
%         Rad_vel = [Rad_vel; dr(r(X))];
%         X = (a*hyper2cart(Rad)')' - x0;
%         X_s = [X_s; X];
%         Xvel_DS = [Xvel_DS; sph2cartvelocities(r(X),dr(r(X)))];
%         if N == 2
%             plot(X(1),X(2),'k.'); hold on; grid on;
%         else
%             plot3(X(1),X(2),X(3),'k.'); hold on; grid on;
%         end
%     end
% end
% 
% %%  Test dynamics for T time steps for N = 2
% figure();
% N = 2
% X0 = [-1.11, -0.71, 0.935];
% Xvel_DS = []; Rad_s = []; X_s = []; Rad_vel = [];
% 
%     X = X0(j,:);
%     h=animatedline(X(1),X(2));
%     for i = 1:100
%         Rad = r(X) + dr(r(X)) * dt;
%         Rad_s = [Rad_s; Rad];
%         Rad_vel = [Rad_vel; dr(r(X))];
%         X = (a*hyper2cart(Rad)')' - x0;
%         X_s = [X_s; X];
%         Xvel_DS = [Xvel_DS; sph2cartvelocities(r(X),dr(r(X)))];
%         addpoints(h,X(1),X(2));
%         %plot(X(1),X(2),'k.'); hold on; grid on;
%     end
% 
