
decimal = 4;

A = Full;

%   0   0.5   1   2   2.5   3   4 
L = 0:0.0001:1;
L = round(L,decimal);
B = zeros(7, length(L));

for i=1:2:length(A)
    
    for j=1:size(A,1)
        
        if A(j,i) ~= -1
            if j == 1   
                switch A(j,i)
                    case 0
                        numR = round(A(j,i+1), decimal);
                        ind = find(L == numR);
                        
                        B(1,1:ind) = B(1,1:ind) + 1;
                        
                    case 0.5
                        numR = round(A(j,i+1), decimal);
                        ind = find(L == numR);
                        
                        B(1,1:ind) = B(1,1:ind) + 1;                        
                        
                    case 1
                        numR = round(A(j,i+1), decimal);
                        ind = find(L == numR);
                        
                        B(3,1:ind) = B(3,1:ind) + 1;                        
                        
                    case 2
                        numR = round(A(j,i+1), decimal);
                        ind = find(L == numR);
                        
                        B(4,1:ind) = B(4,1:ind) + 1;                        
                        
                    case 2.5
                        numR = round(A(j,i+1), decimal);
                        ind = find(L == numR);
                        
                        B(5,1:ind) = B(5,1:ind) + 1;                        
                        
                    case 3
                        numR = round(A(j,i+1), decimal);
                        ind = find(L == numR);
                        
                        B(6,1:ind) = B(6,1:ind) + 1;                        
                        
                    case 4
                        numR = round(A(j,i+1), decimal);
                        ind = find(L == numR);
                        
                        B(7,1:ind) = B(7,1:ind) + 1;                        
                        
                    otherwise
                        A(j,i)
                        error('wrong value');
                end 

            else
                indP = ind;
                switch A(j,i)
                    case 0
                        numR = round(A(j,i+1), decimal);
                        ind = find(L == numR);
                        
                        B(1,indP:ind) = B(1,indP:ind) + 1;
                        
                    case 0.5
                        numR = round(A(j,i+1), decimal);
                        ind = find(L == numR);
                        
                        B(1,indP:ind) = B(1,indP:ind) + 1;                        
                        
                    case 1
                        numR = round(A(j,i+1), decimal);
                        ind = find(L == numR);
                        
                        B(3,indP:ind) = B(3,indP:ind) + 1;                        
                        
                    case 2
                        numR = round(A(j,i+1), decimal);
                        ind = find(L == numR);
                        
                        B(4,indP:ind) = B(4,indP:ind) + 1;                        
                        
                    case 2.5
                        numR = round(A(j,i+1), decimal);
                        ind = find(L == numR);
                        
                        B(5,indP:ind) = B(5,indP:ind) + 1;                        
                        
                    case 3
                        numR = round(A(j,i+1), decimal);
                        ind = find(L == numR);
                        
                        B(6,indP:ind) = B(6,indP:ind) + 1;                        
                        
                    case 4
                        numR = round(A(j,i+1), decimal);
                        ind = find(L == numR);
                        
                        B(7,indP:ind) = B(7,indP:ind) + 1;                        
                        
                    otherwise
                        error('wrong value');
                end                
            end
        end           
    end
    
% find all elements where there is double count    
find( sum(B,1) == length(A)/2 + 1)
    
end

%%

Bnorm = B/17;

for i=1:size(Bnorm,1)
    
    Bnorm_smooth(i,:) = smooth(Bnorm(i,:),0.1);
    
end

%% Not Smoothed

figure()
for i=1:size(B,1)
    
    hold on;
    switch i
        case 1
            plot(Bnorm(i, :), 'b');
        case 2
            plot(Bnorm(i, :), 'color', [0.4940, 0.1840, 0.5560]);
        case 3
            plot(Bnorm(i, :), 'c');
        case 4
            plot(Bnorm(i, :), 'g');
        case 5
            plot(Bnorm(i, :), 'color', [0.9290, 0.6940, 0.1250]);
        case 6
            plot(Bnorm(i, :), 'r');            
        case 7
            plot(Bnorm(i, :), 'k');            
            
    end
end

legend('Cup', 'Hand', 'Task', 'Other Cup', 'Other Hand', 'Face', 'Final Point');
            
xlim([0,10000]);
ylim([0,1]);
            
%% Smoothed

figure()
for i=1:size(B,1)
    
    hold on;
    switch i
        case 1
            plot(Bnorm_smooth(i, :), 'b');
        case 2
            plot(Bnorm_smooth(i, :), 'color', [0.4940, 0.1840, 0.5560]);
        case 3
            plot(Bnorm_smooth(i, :), 'c');
        case 4
            plot(Bnorm_smooth(i, :), 'g');
        case 5
            plot(Bnorm_smooth(i, :), 'color', [0.9290, 0.6940, 0.1250]);
        case 6
            plot(Bnorm_smooth(i, :), 'r');            
        case 7
            plot(Bnorm_smooth(i, :), 'k');            
            
    end
end

legend('Cup', 'Hand', 'Task', 'Other Cup', 'Other Hand', 'Face', 'Final Point');
            
xlim([0,10000]);
ylim([0,1]);
xlabel('time normalized');
xticklabels({'t = 0', '0.2', '0.4', '0.6', '0.8', 't = 1'})
ylabel('percentage %');

            