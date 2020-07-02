
decimal = 4;

A = Empty1;

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
                        
                        B(2,1:ind) = B(2,1:ind) + 1;                        
                        
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
                        
                        B(2,indP:ind) = B(2,indP:ind) + 1;                        
                        
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

figure()

for i=1:size(B,1)
    
    hold on;
    switch i
        case 1
            plot(B(i, :), 'b');
        case 2
            plot(B(i, :), 'p');
        case 3
            plot(B(i, :), 'c');
        case 4
            plot(B(i, :), 'g');
        case 5
            plot(B(i, :), 'y');
        case 6
            plot(B(i, :), 'r');            
        case 7
            plot(B(i, :), 'k');            
            
    end
end
            
            
            