
x = CircleUnit{1}(1,:)';
y = CircleUnit{1}(2,:)';

% Build design matrix
D = [x.*x x.*y y.*y x y ones(size(x)) ];

% Build scatter matrix
S = D'*D;

% Build 6x6 constraint matrix
C(6,6) = 0;
C(1,3) = -2;
C(2,2) = 1;
C(3,1) = -2;

% Solve generalised eigensystem
[gevec, geval] = eig(S,C);

% Find the only negative eigenvalue
[NegR, NegC] = find(geval < 0 & ~isinf(geval));

% Get fitted parameters
a = gevec(:, NegC);

%% Get back the ellipse function

% ellipse orientation
numerator = a(3) - a(1) - sqrt((a(1) - a(3))^2 + a(2)^2);
denominator = a(2);
theta = atan2(numerator, denominator);

% ellipse center
A33 = [a(1) a(2)/2; a(2)/2 a(3)];
K = -inv(A33)*[a(4)/2 a(5)/2]';

xc = K(1);
yc = K(2);

% major/minor axes
ct = cos(theta);
st = sin(theta);

l1 = a(1)*ct*ct + a(3)*st*st + a(2)*st*ct;
l2 = a(1)*st*st + a(3)*ct*ct - a(2)*st*ct;

% scale factor
mu = 1/(K'*A33*K - a(6));

r1 = 1/(sqrt(mu*l1));
r2 = 1/(sqrt(mu*l2));


%% Fit ellipse to data points

N = 100;
dx = 2*pi/N;

% rotation matrix
R = [cos(theta) -sin(theta); sin(theta) cos(theta)];

for i = 1:N
   
    t = i*dx;
    xsim = r1*cos(t);
    ysim = r2*sin(t);
    rotX = R*[xsim ysim]';
    X(i) = xc + rotX(1);
    Y(i) = yc + rotX(2);
    
end

figure(1)
hold off
plot(x,y,'ro')
hold on
plot(X,Y,'.b')







