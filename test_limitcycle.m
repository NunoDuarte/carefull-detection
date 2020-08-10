% understand how to work with autonomous DS (time-independent, state-only
% dependent Dynamical Systems)

%%

% attractor
% xd = A(1)*[x - 27];
% yd = A(2)*[y - 30];

% attractor curved
% xd = A(1)*[x + 20] + A(2)*[y - x];
% yd = A(2)*[y - x];

% Limit cycles
u = -2;
xd = -A(1)*[y + 4] + u*x;
yd = A(2)*[x - 3] + u*y;

% Limit cycle one radius
xd =  [y + 4] - [x - 3].*([x - 3].^2 + [y + 4].^2 - 4);
yd = -[x - 3] - [y + 4].*([x - 3].^2 + [y + 4].^2 - 4);

%% Limit Cycle - circle
% define variables
r = [0.5, 0.8];    % center of limit cycle
r0 = 0.5;        % radius = sqrt(r0)

% Limit cycle one radius
xd =  [y - r(2)] - [x - r(1)].*([x - r(1)].^2 + [y - r(2)].^2 - r0);
yd = -[x - r(1)] - [y - r(2)].*([x - r(1)].^2 + [y - r(2)].^2 - r0);

xtest = 1
ytest = 1

figure(1)
for i=1:100
    hold on;
    xd =  [ytest - r(2)] - [xtest - r(1)].*([xtest - r(1)].^2 + [ytest - r(2)].^2 - r0);
    yd = -[xtest - r(1)] - [ytest - r(2)].*([xtest - r(1)].^2 + [ytest - r(2)].^2 - r0);
    
    xtest = xtest + xd*0.1;
    ytest = ytest + yd*0.1;
    
    plot(ytest,xtest, '.r');
end

%% Limit Cycle - Polar Coordinates
% define variables
alpha = 10;
r0 = 0.5;        % radius = sqrt(r0)

xtest = 1;
ytest = 1;

figure(1)
for i=1:1000
    hold on;
    
    plot(ytest,xtest, '.r');    
    
    r = sqrt(xtest.^2 + ytest.^2);
    phi = atan2(ytest,xtest);

    r_dot = -1*alpha*(r-r0);
    phi_dot = pi/2; % rads per sec
    
    % Limit Cycle Dynamical System in Polar Coordinates
    xd_hat =  r_dot.*cos(phi) - r.*phi_dot.*sin(phi);
    yd_hat =  r_dot.*sin(phi) + r.*phi_dot.*cos(phi);

    xd = xd_hat;
    yd = yd_hat;
    
    xtest = xtest + xd*0.01;
    ytest = ytest + yd*0.01;
    

end
