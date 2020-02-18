openfig('EF-allEPFL.fig');

h = zeros(3, 1);
h(1) = plot(NaN,NaN,'og','MarkerSize',12, 'MarkerEdgeColor','black','MarkerFaceColor',[0.6 1 .6]);
h(2) = plot(NaN,NaN,'-b');
h(3) = plot(NaN,NaN,'.b');
h(4) = plot(NaN,NaN,'or','MarkerSize',12, 'MarkerEdgeColor','black','MarkerFaceColor',[1 0.6 .6]);
h(5) = plot(NaN,NaN,'-r');
h(6) = plot(NaN,NaN,'.r');
legend(h, 'GMM - Full','GMR - Full','Data - Full', 'GMM - Empty','GMR - Empty','Data - Empty');