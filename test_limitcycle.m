% understand how to work with autonomous DS (time-independent, state-only
% dependent Dynamical Systems)

% \dot{x} = A*x

A = [-2, -4; -4, -2];

%%
% 
% [x, y] = meshgrid(-1.5:0.1:1.5, -1.5:0.1:1.5);
% u = x + cos(4*x) + 3;         % x-component of vector field
% v = sin(4*x) - sin(2*y);      % y-component of vector field
% 
% streamslice(x, y, u, v, 1.5);

%%

figure('name','Streamlines')

[x, y] = meshgrid(-8:0.1:8, -8:0.1:8);

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
