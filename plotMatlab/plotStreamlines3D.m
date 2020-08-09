figure('name','Streamlines','position',[800   90   560   320])
% streamlines
quality='low';

if strcmpi(quality,'high')
    nx=600;
    ny=600;
elseif strcmpi(quality,'medium')
    nx=400;
    ny=400;
else
    nx=10;
    ny=10;
    nz = ny;
end

ax.XLim = D(1:2);
ax.YLim = D(3:4);
ax_x=linspace(ax.XLim(1),ax.XLim(2),nx); %computing the mesh points along each axis
ax_y=linspace(ax.YLim(1),ax.YLim(2),ny); %computing the mesh points along each axis
ax_z=linspace(ax.YLim(1),ax.YLim(2),ny); %computing the mesh points along each axis
[x_tmp, y_tmp, z_tmp]=meshgrid(ax_x,ax_y, ax_z); %meshing the input domain
x=[x_tmp(:) y_tmp(:) z_tmp(:)]';
z=zeros(1,nx*ny);

%GMR(Priors,Mu,Sigma,x,1:d,d+1:2*d);
xd = GMR(Priors,Mu,Sigma,x,1:d,d+1:2*d); %compute outputs
%streamslice(x_tmp,y_tmp, z_tmp, reshape(xd(1,:),ny,nx,nz),reshape(xd(2,:),ny,nx,nz),reshape(xd(3,:),ny,nx,nz),1,'method','cubic')
x=[x_tmp(:) y_tmp(:) z_tmp(:)];
quiver3(x(:,1),x(:,2),x(:,3),xd(1,:)',xd(2,:)',xd(3,:)',3,'color','blue', 'linewidth', 1.75, 'maxheadsize', 0.5, 'autoscale', 'on');
%streamslice(x_tmp,y_tmp, reshape(xd(1,:),ny,ny,nz),reshape(xd(2,:),ny,nx,nz),reshape(xd(3,:),ny,nx,nz),1,'method','cubic')

axis([ax.XLim ax.YLim ax.Ylim]);box on
% end 

hold on
plot3(Data(1,:),Data(2,:), Data(3,:), 'r.')
plot(0,0,'k*','markersize',15,'linewidth',3)
xlabel('$\xi_1 (mm)$','interpreter','latex','fontsize',15);
ylabel('$\xi_2 (mm)$','interpreter','latex','fontsize',15);
title('Streamlines of the model')