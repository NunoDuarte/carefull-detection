%% Empty
a = DataE;
a = round(a,2);

figure()
plot(a(1,:),a(2,:),'.')

size = max(a(1,:)) - min(a(1,:));
A = zeros(2,size*100);

i = 1
for j=0:0.01:0.17
    ind = a(1,:) == j;
    A(1,i) = mean(a(2,ind));
    A(2,i) = std(a(2,ind));
    i = i+1;
end

%% Full

a = DataF;
a = round(a,2);

figure()
plot(a(1,:),a(2,:),'.')

size = max(a(1,:)) - min(a(1,:));
B = zeros(2,size*100);

i = 1
for j=0:0.01:0.17
    ind = a(1,:) == j;
    B(1,i) = mean(a(2,ind));
    B(2,i) = std(a(2,ind));
    i = i+1;
end

%%
x = 0:0.01:0.17;
yE = A(1,1:18);
yF = B(1,1:18);
eE = A(2,1:18);
eF = B(2,1:18);
y = [yE' yF'];
e = [eE' eF'];
hBar = bar(x,y);
set ( gca, 'xdir', 'reverse' )

% hold on;
% er = errorbar(x,yE,eE/2,eE/2);    
% ef = errorbar(x,yF,eF/2,eF/2);   
% er.Color = [0 0 0];                            
% er.LineStyle = 'none';  
% ef.Color = [0 0 0];                            
% ef.LineStyle = 'none';  
% hold off;
for k1 = 1:2
    ctr(k1,:) = bsxfun(@plus, hBar(k1).XData, hBar(k1).XOffset');   % Note: ‘XOffset’ Is An Undocumented Feature, This Selects The ‘bar’ Centres
    ydt(k1,:) = hBar(k1).YData;  

end
hold on
errorbar(ctr, ydt, e'/2, '.k') % Individual Bar Heights

legend show

%%

% meanA = [1.9000    5.1333    9.6167];
% meanB =[2.1069    4.8297    8.8746];
% meanC =[1.6632    6.1078    9.9431];
% SD_A =[0.1549    0.3983    0.2137];
% SD_B =[0.5744    1.0037    0.9494];
% SD_C =[0.7757    1.6038    1.5165];
% meanABC = [meanA; meanB; meanC]';
% SD_ABC = [SD_A; SD_B; SD_C];
% figure
% hBar = bar(meanABC, 0.8);                                           % Return ‘bar’ Handle
% for k1 = 1:length(meanABC)
%     ctr(k1,:) = bsxfun(@plus, hBar(k1).XData, hBar(k1).XOffset');   % Note: ‘XOffset’ Is An Undocumented Feature, This Selects The ‘bar’ Centres
%     ydt(k1,:) = hBar(k1).YData;                                     % Individual Bar Heights
% end
% hold on
% errorbar(ctr, ydt, SD_ABC, '.r') 
