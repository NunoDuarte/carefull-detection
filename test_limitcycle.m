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

xtest = 0;
ytest = 0.5;

xunit = [];
yunit = [];

figure(1)
for i=1:200
    hold on;
    
    plot(xtest,ytest, '.r');    
    
    r = sqrt(xtest.^2 + ytest.^2);
    phi = atan2(ytest,xtest);

    r_dot = -1*alpha*(r-r0);
    phi_dot = -pi/2; % rads per sec
    
    % Limit Cycle Dynamical System in Polar Coordinates
    xd_hat =  r_dot.*cos(phi) - r.*phi_dot.*sin(phi);
    yd_hat =  r_dot.*sin(phi) + r.*phi_dot.*cos(phi);

    xd = xd_hat;
    yd = yd_hat;
    
    xtest = xtest + xd*0.02;
    ytest = ytest + yd*0.02;
    
    xunit = [xunit, xtest];
    yunit = [yunit, ytest];
end

CircleUnit{1} = [xunit; yunit];

%% Limit Cycle - Polar Coordinates with Transformation Matrix
% define variables
alpha = 30;
r0 = 0.8;        % radius = sqrt(r0)
theta = -pi/3;      % angle rotation (radians)
a = 1;         % scaling coefficients
b = 2;
x1 = 0;        % translation coefficients
x2 = 0;      % radius = sqrt(r0)

xtest = 0;
ytest = 0.9;

xunit = [];
yunit = [];

figure(1)
for i=1:200
    hold on;
    
    plot(xtest,ytest, '.r');    

    % diffeomorphism
    x_hat = a.*cos(theta).*(xtest - x1) + a.*sin(theta).*(ytest - x2); 
    y_hat = -b.*sin(theta).*(xtest - x1) + b.*cos(theta).*(ytest - x2);

    r = sqrt(x_hat.^2 + y_hat.^2);
    phi = atan2(y_hat,x_hat);

    r_dot = -1*alpha*(r-r0);
    phi_dot = pi/2; % rads per sec

    % Limit Cycle Dynamical System in Polar Coordinates
    xd_hat =  r_dot.*cos(phi) - r.*phi_dot.*sin(phi);
    yd_hat =  r_dot.*sin(phi) + r.*phi_dot.*cos(phi);

    % Dynamical System diffeomorphism (transformation matrix)
    xd = cos(theta).*a^(-1).*xd_hat - sin(theta).*b^(-1).*yd_hat;
    yd = sin(theta).*a^(-1).*xd_hat + cos(theta).*b^(-1).*yd_hat;
    
    xtest = xtest + xd*0.02;
    ytest = ytest + yd*0.02;
    
    xunit = [xunit, xtest];
    yunit = [yunit, ytest];
    
end

CircleUnit{1} = [xunit; yunit];
