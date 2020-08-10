% understand how to work with autonomous DS (time-independent, state-only
% dependent Dynamical Systems)

%%

figure('name','Streamlines')

limit_axis = 1;

xmax = limit_axis;
xmin = -xmax;
ymax = limit_axis;
ymin = -ymax;


[x, y] = meshgrid(xmin:0.1:xmax, ymin:0.1:ymax);

d = 2; % 2D

%% Limit Cycle - circle
% define variables
alpha = 10;
r0 = 0.5;        % radius = sqrt(r0)

r = sqrt(x.^2 + y.^2);
phi = atan2(y,x);

r_dot = -1*alpha*(r-r0);
phi_dot = -pi/2; % rads per sec

% Limit Cycle Dynamical System in Polar Coordinates
xd_hat =  r_dot.*cos(phi) - r.*phi_dot.*sin(phi);
yd_hat =  r_dot.*sin(phi)  + r.*phi_dot.*cos(phi);

xd = xd_hat;
yd = yd_hat;

% % Dynamical System diffeomorphism (transformation matrix)
% x =  r_dot.*cos(phi) - r*phi_dot*sin(phi);
% y =  r_dot.*sin(phi)  + r*phi_dot*cos(phi);


%% Limit Cycle - ellipse
% define variables
% r = [3, -4];    % center of limit cycle
% r0 = [2, 25];        % radius of ellipse = sqrt(r0)
% 
% % Limit cycle one radius
% xd =  [y - r(2)] - [x - r(1)].*(([x - r(1)].^2)./r0(1) + ([y - r(2)].^2)./r0(2) - 1);
% yd = -[x - r(1)] - [y - r(2)].*(([x - r(1)].^2)./r0(1) + ([y - r(2)].^2)./r0(2) - 1);

%% Single Attractor
% Attractor with local attraction (higher the degree => the higher the
% attraction locally)
% xd = A(1)*[y + 4] - 0.8*x + (-5)*x.^3;
% yd = -A(2)*[x - 3];

% Limit cycles - stable attractor
% xd = A(1)*[y + 4] - 0.8*x;
% yd = -A(2)*[x - 3];

% Limit cycles - unstable attractor
% xd = A(1)*[y + 4] + 0.8*x;
% yd = -A(2)*[x - 3];

% local attraction that shifts the trajectory
% xd =  [y - r(2)] - [x].*([x - r(1)].^2 + [y - r(2)].^2 - r0(1));
% yd = -[x - r(1)] - [y].*([x - r(1)].^2 + [y - r(2)].^2 - r0(2));


%streamslice(x_tmp,y_tmp,reshape(xd(1,:),ny,nx),reshape(xd(2,:),ny,nx),1,'method','linear')
streamslice(x, y, xd, yd, 2);
axis([xmin, xmax, ymin, ymax]);
