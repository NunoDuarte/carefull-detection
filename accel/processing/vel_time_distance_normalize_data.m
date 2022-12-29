% for the glitch of the Command Window
%MATLAB_JAVA = '/usr/lib/jvm/java-8-openjdk/jre matlab -desktop -nosplash';
% Add this to ~/.bashrc
% export MATLAB_JAVA=/usr/lib/jvm/java-8-openjdk/jre
clear
clc

addpath(genpath('processing/'))
addpath('data')

% Which Person to choose (Salman, Leo, Bernardo)
[E, ~] = read('Leo', 'plastic-cup');
[~, F] = read('Leo', 'red-cup');

[E, F, ~, ~, ~, ~] = scriptAllData(1);

% plotting?
plotting = 0;

%% Remove Non-Zeros - Empty

if plotting
    [plotx, ploty, plotz] = deal(0);
end

for i=1:length(E)

    En{i}(:,1) = nonzeros(E{i}(:,2));
    En{i}(:,2) = nonzeros(E{i}(:,3));
    En{i}(:,3) = nonzeros(E{i}(:,4));
    
    % pick the elements of time vector not 0
    TimeVE = find(E{i}(:,4) ~= 0);
    % get the time information
    TE{i} = E{i}(TimeVE,1);
    % normalize
    TE{i} = TE{i} - TE{i}(1);
    TE{i} = TE{i}/TE{i}(end);
    
    E3{i}(1,:) = En{i}(:,1)';
    E3{i}(2,:) = En{i}(:,2)';
    E3{i}(3,:) = En{i}(:,3)';       
    E3{i} = round(E3{i},4);
    
    if plotting
        plotx = [plotx, E3{i}(1,:)];
        ploty = [ploty, E3{i}(2,:)];
        plotz = [plotz, E3{i}(3,:)];             
    end

end

if plotting
    figure();
    plot3(ploty, plotx, plotz, '.');
end

%% Generate a DS for Empty Cups
% do you want the default parameters?
default = 1;    

for i=1:length(E3)
    xT = E3{i}(:,end);
    Norm1 = [];
    for j=1:length(E3{i})
        dis = xT - E3{i}(:,j);
        disN = norm(dis,2);
        Norm1 = [Norm1; disN];
       
    end
    % normalized over distance
    Norm2 = Norm1/max(Norm1);
    Emp3Dnorm{i} = [Norm2';TE{i}(:,1)'];

end


%% Velocidate/Tempo

%samp_freq = 1/30; % for QMUL data
dt = 1/120; % for EPFL data
d = size(Emp3Dnorm{1},1); %dimensionality of demosntrations
Data= [];
Data_pos_E = [];
Data_vel_E = [];
Data_acc_E = [];
for i=1:length(Emp3Dnorm)
    clear tmp tmp_d
    % de-noising data (not necessary)
    for j=1:d
        tmp(j,:) = smooth(Emp3Dnorm{i}(j,:),25); 
    end
    
%   tmp_d = diff(tmp,1,2)./repmat(diff(Emp3Dnorm{i}(2,:)),d,1);
    tmp_d = diff(tmp,1,2)/dt;
    tmp_d = -1*tmp_d;     
    tmp_dd = diff(tmp_d,1,2)/dt;

    oL = length(tmp_d);
    ds_tmp_d = interp1(1:oL, [tmp_d(1,:)], linspace(1,oL,100));
    oL = length(tmp);
    ds_tmp(1,:) = interp1(1:oL, tmp(1,:), linspace(1,oL,100));
    ds_tmp(2,:) = interp1(1:oL, tmp(2,:), linspace(1,oL,100));
    oL = length(tmp_dd);
    ds_tmp_dd = interp1(1:oL, [tmp_dd(1,:)], linspace(1,oL,100));
    
    % saving demos next to each other
    Data = [Data [ds_tmp;ds_tmp_d]];
    Data_pos_E = [Data_pos_E; ds_tmp(1,:)];
    Data_vel_E = [Data_vel_E; ds_tmp_d];
    Data_acc_E = [Data_acc_E; ds_tmp_dd];
    % Data(4,:) is the derivative of time (which means nothing)
end

    
figure(1);
hold on
plot(Data(2,:), Data(3,:), 'r.');

%% Velocidate/Distance
   
figure(2);
hold on
plot(Data(1,:), Data(3,:), 'r.');


%% Remove Non Zeros

if plotting
    [plotx, ploty, plotz] = deal(0);
end

for i=1:length(F)
    Fn{i}(:,1) = nonzeros(F{i}(:,2));
    Fn{i}(:,2) = nonzeros(F{i}(:,3));
    Fn{i}(:,3) = nonzeros(F{i}(:,4));
    F3{i}(1,:) = Fn{i}(:,1)';
    F3{i}(2,:) = Fn{i}(:,2)';
    F3{i}(3,:) = Fn{i}(:,3)'; 
    
    % pick the elements of time vector not 0
    TimeVF = find(F{i}(:,4) ~= 0);
    % get the time information
    TF{i} = F{i}(TimeVF,1);
    % normalize
    TF{i} = TF{i} - TF{i}(1);
    TF{i} = TF{i}/TF{i}(end);
    
    F3{i} = round(F3{i},4);
    
    if plotting
        plotx = [plotx, F3{i}(1,:)];
        ploty = [ploty, F3{i}(2,:)];
        plotz = [plotz, F3{i}(3,:)];             
    end

end

if plotting
    figure();
    plot3(ploty, plotx, plotz, '.');
end

%% Generate a DS for Full Cups
% do you default parameters?
default = 1;    

for i=1:length(F3)
    xT = F3{i}(:,end);
    Norm1 = [];
    for j=1:length(F3{i})
        dis = xT - F3{i}(:,j);
        disN = norm(dis);
        Norm1 = [Norm1; disN];
        
        % normalized over distance
        Norm2 = Norm1/max(Norm1);
    end
    % normalized over distance
    Norm2 = Norm1/max(Norm1);
    Full3Dnorm{i} = [Norm2';TF{i}(:,1)'];
end


%% Velocidate/Tempo

d = size(Full3Dnorm{1},1); %dimensionality of demosntrations
Data= [];
Data_pos_F = [];
Data_vel_F = [];
Data_acc_F = [];
for i=1:length(Full3Dnorm)
    clear tmp tmp_d
    % de-noising data (not necessary)
    for j=1:d
        tmp(j,:) = smooth(Full3Dnorm{i}(j,:),25); 
    end
    
%    tmp_d = diff(tmp,1,2)./repmat(diff(Full3Dnorm{i}(2,:)),d,1);
     tmp_d = diff(tmp,1,2)/dt;     
     tmp_d = -1*tmp_d; 
     tmp_dd = diff(tmp_d,1,2)/dt;

    oL = length(tmp_d);
    ds_tmp_d = interp1(1:oL, [tmp_d(1,:)], linspace(1,oL,100));
    oL = length(tmp);
    ds_tmp(1,:) = interp1(1:oL, tmp(1,:), linspace(1,oL,100));
    ds_tmp(2,:) = interp1(1:oL, tmp(2,:), linspace(1,oL,100));
    oL = length(tmp_dd);
    ds_tmp_dd = interp1(1:oL, [tmp_dd(1,:)], linspace(1,oL,100));

    % saving demos next to each other
    Data = [Data [ds_tmp;ds_tmp_d]];
    Data_pos_F = [Data_pos_F; ds_tmp(1,:)];
    Data_vel_F = [Data_vel_F; ds_tmp_d];
    Data_acc_F = [Data_acc_F; ds_tmp_dd];
      
    % Data(4,:) is the derivative of time (which means nothing)
end


figure(1);
plot(Data(2,:), Data(3,:), 'g.');
ylim([0, 2]);
xlabel('$t (s)$','interpreter','latex','fontsize',15);
ylabel('$\dot{x} (m/s)$','interpreter','latex','fontsize',15);

%% Velocidate/Distance

figure(2);
plot(Data(1,:), Data(3,:), 'g.');
ylim([0, 2]);
xlabel('$x (m)$','interpreter','latex','fontsize',15);
ylabel('$\dot{x} (m/s)$','interpreter','latex','fontsize',15);

% %% convert to csv
% FileData = load('vel-t-m-data-sepaE.mat');
% csvwrite('vel-t-m-data-sepaE.csv', FileData.Data_separated);

%% Get avg and std of velocities

figure();
avg_vE = mean(Data_vel_E);
avg_vF = mean(Data_vel_F);

std_vE = std(Data_vel_E);
std_vF = std(Data_vel_E);

curve1 = avg_vE + std_vE;
curve2 = avg_vE - std_vE;
xE = mean(Data_pos_E)

x2 = [xE, fliplr(xE)];
inBetween = [curve1, fliplr(curve2)];
fill(x2, inBetween, 'g');
hold on;
plot(xE, avg_vE, 'r', 'LineWidth', 2);

figure();
hold on;

curve1 = avg_vF + std_vF;
curve2 = avg_vF - std_vF;
xF = mean(Data_pos_F)

x2 = [xF, fliplr(xF)];
inBetween = [curve1, fliplr(curve2)];
fill(x2, inBetween, 'g');
hold on;
plot(xF, avg_vF, 'r', 'LineWidth', 2);

%% convert to csv
csvwrite('avgstd_vel_E.csv', [avg_vE; std_vE; xE]);
csvwrite('avgstd_vel_F.csv', [avg_vF; std_vF; xF]);


