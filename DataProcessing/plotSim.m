% Plot the data simulated from HHI human leader movement

load('simD.mat');
load('simH.mat');

figure(1)
hold on;
for i=1:length(simD)
    plot(simD{i}(:,1), simD{i}(:,2), 'b')
   
end
hold off;

figure(2)
hold on;
for i=1:length(simH)
    plot(simH{i}(:,1), simH{i}(:,2), 'r')
   
end
    
hold off;


%%

load('outP.mat');
load('outH.mat');

figure(1)
hold on;
for i=1:length(outP)
    plot(outP{i}(:,1), outP{i}(:,2), 'b')
   
end
hold off;

figure(2)
hold on;
for i=1:length(outH)
    plot(outH{i}(:,1), outH{i}(:,2), 'r')
   
end
hold off;

%% Generate CDS from iCubSIM Data(with default parameters)
targetSize = [1, 200];
for i=1:length(outP)
        DataFy = outP{i}(:,1); 
        DataFz = outP{i}(:,2);

        Fy_new = [];
        Fz_new = [];    
        for a=1:length(DataFy)
            Fy_new = [Fy_new, DataFy(a)];
            Fz_new = [Fz_new, DataFz(a)];            

        end
  
        dataFy = imresize(Fy_new, targetSize); 
        dataFz = imresize(Fz_new, targetSize);      
        outPstd{i} = [dataFy; dataFz];
end
    
for i=1:length(outH)
        DataFy = outH{i}(:,1); 
        DataFz = outH{i}(:,2);

        Fy_new = [];
        Fz_new = [];    
        for a=1:length(DataFy)
            Fy_new = [Fy_new, DataFy(a)];
            Fz_new = [Fz_new, DataFz(a)];            

        end
  
        dataFy = imresize(Fy_new, targetSize); 
        dataFz = imresize(Fz_new, targetSize);      
        outHstd{i} = [dataFy; dataFz];
end

%%      
% Norm Leader coordinates
for a=1:length(outPstd)
   
    N{a} = outPstd{a};
    len = length(N{a});
    
    new = zeros(1,length(outPstd));
    for i=1:len        
        new(i) = N{a}(1:1,i);
        NnormL{1,a} = new;        
    end
end

% Norm Follower coordinates
for a=1:length(outPstd)
    
    N{a} = outPstd{a};
    len = length(N{a});
    
    new = zeros(1,length(outPstd));
    for i=1:len
        new(i) = N{a}(2:2,i);
        NnormF{1,a} = new;        
    end
end

% Choose the coupling function!!
% Do you want (L|x+z| v F|x+z|) || (L|x| v F|x|) || (L|z| v F|z|)

for a=1:length(outPstd)
    demosNorm{a} = [NnormL{a}; NnormF{a}];
end

externalCDS(demosNorm, 1, [], [], []); 

%%      
% Norm Leader coordinates
for a=1:length(outHstd)
   
    N{a} = outHstd{a};
    len = length(N{a});
    
    new = zeros(1,length(outHstd));
    for i=1:len        
        new(i) = N{a}(1:1,i);
        NnormL{1,a} = new;        
    end
end

% Norm Follower coordinates
for a=1:length(outHstd)
    
    N{a} = outHstd{a};
    len = length(N{a});
    
    new = zeros(1,length(outHstd));
    for i=1:len
        new(i) = N{a}(2:2,i);
        NnormF{1,a} = new;        
    end
end

% Choose the coupling function!!
% Do you want (L|x+z| v F|x+z|) || (L|x| v F|x|) || (L|z| v F|z|)

for a=1:length(outHstd)
    demosNorm{a} = [NnormL{a}; NnormF{a}];
end

externalCDS(demosNorm, 1, [], [], []); 

%% Follower behaviour for iCubSIM with simulation real human data

for i=1:length(iCubSimH)

    F2sim{i} = [-1*iCubSimD{i}(:,2)'; -1*iCubSimH{i}(:,2)'];
    
end

default = 1;    % do you default parameters?
intDSfollower(F2sim, default)

%% 

load('outP.mat');
load('outH.mat');

figure(1)
hold on;
for i=1:length(iCubSimH)
    plot(iCubSimD{i}(:,2), iCubSimH{i}(:,2), 'b')
   
end
hold off;

%% GENERATE CDS FROM ICUBSIM DATA
% Norm Leader coordinates
for a=1:length(iCubSimH)
   
    N{a} = iCubSimH{a}';
    len = length(N{a});
    
    new = zeros(1,length(iCubSimH));
    for i=1:len        
        new(i) = N{a}(1:1,i);
        NnormL{1,a} = new;        
    end
end

% Norm Follower coordinates
for a=1:length(iCubSimH)
    
    N{a} = iCubSimH{a}';
    len = length(N{a});
    
    new = zeros(1,length(iCubSimH));
    for i=1:len
        new(i) = N{a}(2:2,i);
        NnormF{1,a} = new;        
    end
end

% Choose the coupling function!!
% Do you want (L|x+z| v F|x+z|) || (L|x| v F|x|) || (L|z| v F|z|)

for a=1:length(iCubSimD)
    demosNorm{a} = [NnormL{a}; NnormF{a}];
end

externalCDS(demosNorm, 1, [], [], []); 

%%      
% Norm Leader coordinates
for a=1:length(iCubSimD)
   
    N{a} = iCubSimD{a}';
    len = length(N{a});
    
    new = zeros(1,length(iCubSimD));
    for i=1:len        
        new(i) = N{a}(1:1,i);
        NnormL{1,a} = new;        
    end
end

% Norm Follower coordinates
for a=1:length(iCubSimD)
    
    N{a} = iCubSimD{a}';
    len = length(N{a});
    
    new = zeros(1,length(iCubSimD));
    for i=1:len
        new(i) = N{a}(2:2,i);
        NnormF{1,a} = new;        
    end
end

% Choose the coupling function!!
% Do you want (L|x+z| v F|x+z|) || (L|x| v F|x|) || (L|z| v F|z|)

for a=1:length(iCubSimD)
    demosNorm{a} = [NnormL{a}; NnormF{a}];
end

externalCDS(demosNorm, 1, [], [], []); 

%% 
n = numel(H);
figure
hold on
xlabel('proximity^{leader} (m)');
ylabel('height^{leader} (m)');
xlim([-0.9 0])
ylim([-0.25 0])
pause
for i = 1:n
    plot(D(1:i,1),H(1:i,1))
    pause(0.1)
end

%% 

n = numel(H);
figure(1)
hold on
a = xlabel('$\xi^{\textnormal{leader}}_y (m)$');
set(a, 'FontSize', 15)
b = ylabel('$\xi^{\textnormal{follower}}_y (m) $');
set(b, 'FontSize', 15)
xlim([-0.7 0.1])
ylim([-0.35 0.05])
pause
for i = 1:n
    plot(D(1:i,1),D(1:i,2))
    pause(0.1)
end

%% REAL TIME PLOTTING OF COUPLING Y

n = numel(H);
figure(1)
hold on
a = xlabel('$\xi^{\textnormal{leader}}_y (m)$');
set(a, 'FontSize', 15)
b = ylabel('$\xi^{\textnormal{follower}}_y (m) $');
set(b, 'FontSize', 15)
xlim([-0.7 0.1])
ylim([-0.35 0.05])
pause
for j=1:n
    for i = j:j
        h1 = plot(D(i:i,1),D(i:i,2), 'k.', 'MarkerSize',12);
        pause(0.1)
        set(h1, 'Visible', 'off');      
    end
end

%%  REAL TIME PLOTTING OF COUPLING Z

n = numel(H);
figure(1)
hold on
a = xlabel('$\xi^{\textnormal{leader}}_z (m)$');
set(a, 'FontSize', 15)
b = ylabel('$\xi^{\textnormal{follower}}_z (m) $');
set(b, 'FontSize', 15)
xlim([-0.3 0.05])
ylim([-0.2 0.05])
pause
for j=1:n
    for i = j:j
        h1 = plot(H(i:i,1),H(i:i,2), 'k.', 'MarkerSize',12);
        pause(0.1)
        set(h1, 'Visible', 'off');      
    end
end

%%  REAL TIME PLOTTING OF LEADER

n = numel(H);
figure(1)
hold on
a = xlabel('$\xi^{\textnormal{leader}}_y (m)$');
set(a, 'FontSize', 15)
b = ylabel('$\xi^{\textnormal{leader}}_z (m) $');
set(b, 'FontSize', 15)
xlim([0 0.7])
ylim([-0.05 0.3])
pause
for j=1:n
    for i = j:j
        h1 = plot(-1*D(i:i,1),-1*H(i:i,1), 'k.', 'MarkerSize',12);
        pause(0.1)
        set(h1, 'Visible', 'off');      
    end
end

