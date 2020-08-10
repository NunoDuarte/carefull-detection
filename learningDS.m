% understand how to work with autonomous DS (time-independent, state-only
% dependent Dynamical Systems)

% \dot{x} = A*x

A = [-2, -4; -4, -2];

%xd = A*x;

% %%
% 
% figure('name','Streamlines')
% 
% % Plot colormap
% limits = [-80 80 -20 20];    
% axlim = limits;
% nx = 200; ny = 200;
% ax_x=linspace(axlim(1),axlim(2),nx); %computing the mesh points along each axis
% ax_y=linspace(axlim(3),axlim(4),ny); %computing the mesh points along each axis
% [x_tmp, y_tmp]=meshgrid(ax_x,ax_y); %meshing the input domain
% x=[x_tmp(:), y_tmp(:)]';
% 
% d = 2; % 2D
% xd = A*x;
% %xd = GMR(Priors,Mu([1 2 4 5],:),Sigma([1 2 4 5],[1 2 4 5],:),x,1:d,d+1:2*d); 
% 
% streamslice(x_tmp,y_tmp,reshape(xd(1,:),ny,nx),reshape(xd(2,:),ny,nx),1,'method','linear')
% 
% % % Get the magnitude of the Velocity
% % xdnorm = vecnorm(xd);
% % z_tmp = xdnorm;
% % h = pcolor(x_tmp,y_tmp,reshape(xdnorm,nx,ny));
% 
% % set(h,'linestyle','none');
% % colorbar;
% 
% %%
% [x,y] = meshgrid(0:0.1:1,0:0.1:1);
% u = x;
% v = -y;
% 
% figure
% % quiver(x,y,u,v)
% 
% startx = 0.1:0.1:1;
% starty = ones(size(startx));
% streamline(x,y,u,v,startx,starty)

%%
% 
% [x, y] = meshgrid(-1.5:0.1:1.5, -1.5:0.1:1.5);
% u = x + cos(4*x) + 3;         % x-component of vector field
% v = sin(4*x) - sin(2*y);      % y-component of vector field
% 
% streamslice(x, y, u, v, 1.5);

%%

figure('name','Streamlines')

limit_axis = 3;

xmax = limit_axis;
xmin = -xmax;
ymax = limit_axis;
ymin = -ymax;


[x, y] = meshgrid(xmin:0.1:xmax, ymin:0.1:ymax);

d = 2; % 2D
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
r = [0, 0];    % center of limit cycle
r0 = 1.5;        % radius = sqrt(r0)

% Limit cycle one radius
xd =  [y - r(2)] - [x - r(1)].*([x - r(1)].^2 + [y - r(2)].^2 - r0);
yd = -[x - r(1)] - [y - r(2)].*([x - r(1)].^2 + [y - r(2)].^2 - r0);    

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
