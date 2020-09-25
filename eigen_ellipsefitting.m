
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







