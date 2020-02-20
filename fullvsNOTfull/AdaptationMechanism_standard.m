%%  This is a standard formulation of the Adaptation Mechanism to 
% classify the action between 2 DS

% parameters to SEDS
opt_sim.dt = 0.02;
opt_sim.i_max = 1;
opt_sim.tol = 0.001;
opt_sim.plot = 0;
d = 1; % dimension of data
xT = 0; 

% initiliaze variables
b1 = 0.5;
b2 = 0.5;
b = [b1, b2];
b1_d = 0;
b2_d = 0;
b_d = [b1_d, b2_d];

% adaptation rate
epsilon = 300; 

% initialize vectors to save output
DX_desired = [];
B = [];
Er = [];

% 1st initial belief [0.5, 0.5]
B = [B; b];

for j = 1:length(Data)
    
    ee = [0 0];
    
    for i = 1:2
    
        % input to DS
        x = Data(1,j);              % distance to meeting point
        dx_real(j) = Data(2,j);     % current velocity at current distance

        % DS output
        fn_handle = @(xx) GMR(Priors{i},Mu{i},Sigma{i},xx,1:d,d+1:2*d);
        [~, dx_desired, ~, ~]=Simulation(x,xT,fn_handle,opt_sim); % output desired velocity

        % error (real velocity - desired velocity (pick 1st output))
        ed = abs(dx_real(j) - dx_desired(:,1));
        
        % save output
        DX_desired = [DX_desired; dx_desired(:,1)'];
        
        ee(i) = ed;        
        
        b_d(i) = epsilon * (ed'*dx_desired(:,1) + (b(i) - 0.5) * norm(dx_desired(:,1), 2)); 

    end
    
    % save output
    Er = [Er;ee];
        
    % update belief system
    B_d = winnertakeall(b, b_d);
    for i = 1:2
        b(i) = b(i) + B_d(i)*0.1;
        b(i) = max(0., min(1., b(i)));
    end
    b(2) = 1. - b(1);
    
    % save output
    B = [B; b];    
    
end