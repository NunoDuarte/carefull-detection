% xdot = A*x - slow
% xdot = 2A*x - fast
clc
clear;

% Which Person to choose (Salman, Leo, Bernardo)
[E, F] = read('Leo');
% t = 20:-1:0;
% testXn = (t.^2)*0.01;

% %% Real Velocity of testX
% dt = 0.01;
% testX_d = 0.1*diff(testXn,1,2)/dt;

%% Belief System for 2 DS
% pick one trajectory
clear test3;
clear testXn;
clear testXnnorm;

testX = F{1}; 

% remove nonzeros
testXn(:,1) = nonzeros(testX(:,2));
testXn(:,2) = nonzeros(testX(:,3));
testXn(:,3) = nonzeros(testX(:,4));
test3{1}(1,:) = testXn(:,1)';
test3{1}(2,:) = testXn(:,2)';
test3{1}(3,:) = testXn(:,3)'; 

%% Center the Data in the Origin

testXn = test3{1};
testXn = testXn - testXn(:,end);
testXn = round(testXn,3);

% do the norm of all dimensions
for n = 1:length(testXn)   
    testXnnorm(n) = norm(testXn(:,n));    
end
testXnnorm = round(testXnnorm,3);

%% Real Velocity of testX
dt = 0.02; % frequency 

for i=2:length(testXn(1,:))
   testX_d(1,i-1) = (testXnnorm(1,i) - testXnnorm(1,i-1))/dt;
end

% NOTE:
% A(1) - slower -> testX_d (real velocity of trajectory) = 0.1*diff(...) 
% A(2) - faster -> testX_d (real velocity of trajectory) = 0.5*diff(...)
% b( for slower) = [1, 0]
% b( for faster) = [0, 1]

A = [-0.04, -0.14];
%% Belief DS

b1 = 0.5;
b2 = 0.5;
b = [b1, b2];
b1_d = 0;
b2_d = 0;
b_d = [b1_d, b2_d];
epsilon = 100; % adaptation rate

Xd = [];
B = [];
B = [B; b];
for j = 1:length(testXnnorm) - 1
    Xd_i = [];
    for i = 1:2
        
        x0 = testXnnorm(:,j);
        
        xd = A(i)*x0; %running the simulator

        % error (real velocity - desired velocity)
        ed = norm(norm(testX_d(:,j)) - norm(xd(:,1)));
        
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
