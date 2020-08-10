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
yd_hat =  r_dot.*sin(phi) + r.*phi_dot.*cos(phi);

xd = xd_hat;
yd = yd_hat;

% % Dynamical System diffeomorphism (transformation matrix)
% x =  r_dot.*cos(phi) - r*phi_dot*sin(phi);
% y =  r_dot.*sin(phi)  + r*phi_dot*cos(phi);


%% Limit Cycle - ellipse
% define variables
alpha = 10;
r0 = 0.5;        % radius = sqrt(r0)

r = sqrt(x.^2 + y.^2);
phi = atan2(y,x);

r_dot = -1*alpha*(r-r0);
phi_dot = -pi/2; % rads per sec

% Limit Cycle Dynamical System in Polar Coordinates
xd_hat =  r_dot.*cos(phi) - r.*phi_dot.*sin(phi);
yd_hat =  r_dot.*sin(phi) + r.*phi_dot.*cos(phi);

xd = xd_hat;
yd = yd_hat;

% % Dynamical System diffeomorphism (transformation matrix)
% x =  r_dot.*cos(phi) - r*phi_dot*sin(phi);
% y =  r_dot.*sin(phi)  + r*phi_dot*cos(phi);


%streamslice(x_tmp,y_tmp,reshape(xd(1,:),ny,nx),reshape(xd(2,:),ny,nx),1,'method','linear')
streamslice(x, y, xd, yd, 2); % 2 is for large density of streamlines
axis([xmin, xmax, ymin, ymax]);
