
x_0 = MuE(1);
y_0 = MuE(2);

[V,D] = eig(SigmaE);
e1=V(:,1); 
e2=V(:,2);
d = sqrt(diag(D));

% plot([0; e1(1)], [0; e1(2)], 'k--');
% plot([0; e2(1)], [0; e2(2)], 'k--');

hold on;
quiver(x_0,y_0,V(1,2),V(2,2),d(2),'k','LineWidth',5);
quiver(x_0,y_0,V(1,1),V(2,1),d(1),'r','LineWidth',5);
hold off;