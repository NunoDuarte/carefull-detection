addpath('../SEDS')
addpath('DS')
addpath('data')
addpath('../../Khansari/SEDS/SEDS_lib')
addpath('../../Khansari/SEDS/GMR_lib')

% Which Person to choose (Salman, Leo, Bernardo)
[E, F] = read('All', 'plastic-cup');

%% Remove Non-Zeros - Empty
ploty = [];
plotx = [];
plotz = [];
for i=1:length(E)

    En{i}(:,1) = nonzeros(E{i}(:,2));
    En{i}(:,2) = nonzeros(E{i}(:,3));
    En{i}(:,3) = nonzeros(E{i}(:,4));
    E3{i}(1,:) = En{i}(:,1)';
    E3{i}(2,:) = En{i}(:,2)';
    E3{i}(3,:) = En{i}(:,3)';         
    plotx = [plotx, E3{i}(1,:)];
    ploty = [ploty, E3{i}(2,:)];
    plotz = [plotz, E3{i}(3,:)];
    E3{i} = round(E3{i},4);
end
figure()
plot3(ploty, plotx, plotz, '.');


%%
plotting = 1;    % do you want to plot the 3D versions?
[Emp3D, Emp2Do, Emp2D] = processData(E3, plotting);

%% Generate a DS for Empty Cups
default = 1;    % do you default parameters?

for i=1:length(Emp3D)
    Norm1 = [];
    for j=1:length(Emp3D{i})
    
        norm1 = Emp3D{i}(:,j);
        Norm1 = [Norm1; norm(norm1,2)];
        Emp3Dnorm{i} = Norm1';
    end
end
F = Emp3Dnorm;

% don't forget to change the function back to just a simple file

if default
    %% User Parameters and Setting
    sim = 0; % simulate
    % Training parameters
    K = 4; % Number of Gaussian functions

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
end


%% Run SEDS solver

[tmp , tmp, Data, index] = preprocess_demos(F, 0.02, 0.0001); %preprocessing datas


%% Draw GMRs for all dimensions (x/y, .x/x, .y/y)
nbVar = size(Data,1);
expData(1,:) = linspace(min(Data(1,:)), max(Data(1,:)), 100);
[expData(2:nbVar,:), expSigma] = GMR(Priors, Mu, Sigma,  expData(1,:), [1], [2:nbVar]);


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
    
    
end

%%
% plotting the result
figure('name','Results from Simulation','position',[265   200   520   720])
sp(1)=subplot(3,1,1);
hold on; box on
plotGMM(Mu(1:2,:), Sigma(1:2,1:2,:), [0.6 1.0 0.6], 1,[0.6 1.0 0.6]);
plot(Data(1,:),Data(2,:),'r.') 
xlabel('$\xi_1 (mm)$','interpreter','latex','fontsize',15);
ylabel('$\xi_2 (mm)$','interpreter','latex','fontsize',15);
title('Simulation Results')
    
i = 1
axis(sp(i),'tight')
ax=get(sp(i));
axis(sp(i),...
    [ax.XLim(1)-(ax.XLim(2)-ax.XLim(1))/10 ax.XLim(2)+(ax.XLim(2)-ax.XLim(1))/10 ...
    ax.YLim(1)-(ax.YLim(2)-ax.YLim(1))/10 ax.YLim(2)+(ax.YLim(2)-ax.YLim(1))/10]);
plot(sp(i),0,0,'k*','markersize',15,'linewidth',3)
if i==1
    D = axis(sp(i));
end

%%

figure('name','Streamlines','position',[800   90   560   320])
% Plot colormap
ax.XLim = D(1:2);
ax.YLim = D(3:4);
limits = [ax.XLim(1) ax.XLim(2) ax.YLim(1) ax.YLim(2)];  
axlim = limits;
nx = 20; ny = 20;
ax_x=linspace(axlim(1),axlim(2),nx); %computing the mesh points along each axis
ax_y=linspace(axlim(3),axlim(4),ny); %computing the mesh points along each axis
[x_tmp, y_tmp]=meshgrid(ax_x,ax_y); %meshing the input domain
x=[x_tmp(:), y_tmp(:)]';

d = 2; % 2D
    
xd = GMR(Priors,Mu,Sigma,x,1,d); %compute outputs
    

quiver(x_tmp, y_tmp, reshape(xd(1,:),ny,nx), reshape(xd(2,:),ny,nx), 'color','black')

%% Keep range the same

range_factor = range(x_tmp')/range(y_tmp);
x_range = -1*min(x_tmp(:)')/max(x_tmp(:)');
y_range = -1*max(y_tmp(:)')/min(y_tmp(:)');

%% quiver with fixed range
quiver(x_tmp, y_tmp, reshape(xd(1,:),ny,nx)*x_range, reshape(xd(2,:),ny,nx)*y_range, 'color','black')
