% xdot = A*x - slow
% xdot = 2A*x - fast

t = 20:-1:0;
testXn = (t.^2)*0.01;

%% Real Velocity of testX
dt = 0.01;
testX_d = 0.1*diff(testXn,1,2)/dt;

A = [-1, -2];
%% Belief DS

b1 = 0.5;
b2 = 0.5;
b = [b1, b2];
b1_d = 0;
b2_d = 0;
b_d = [b1_d, b2_d];
epsilon = 0.1; % adaptation rate

Xd = [];
B = [];
B = [B; b];
for j = 1:length(testXn) - 1
    Xd_i = [];
    for i = 1:2
        
        x0 = abs(testXn(:,j));
        
        xd = A(i)*x0; %running the simulator

        % error (real velocity - desired velocity)
        ed = testX_d(:,j) - xd(:,1);
        
        Xd_i = [Xd_i, xd(:,1)'];
        
        b_d(i) = epsilon * (ed'*xd(:,1) + (b(i) - 0.5)*norm(xd(:,1), 2)); 
    end
    Xd = [Xd; Xd_i];
    clear Xd_i
    
    B_d = winnertakeall(b, b_d);
    
    for i = 1:2
        b(i) = b(i) + B_d(i)*0.1;
        b(i) = max(0., min(1., b(i)));
    end
    b(2) = 1. - b(1);
    B = [B; b];
    
end
