
A = Empty1;

length(A)

%   0   0.5   1   2   2.5   3   4 
L = 0:0.001:1;
B = zeros(7, length(L));

for i=1:2:length(A)
    
    for j=1:size(A,1)
        
        if A(j,i) ~= -1
            if j == 1               
                switch A(j,i)
                    case 0
                        numR = round(A(j,i+1), 3);
                        ind = find(L == numR);
                        
                        B(1,1:ind) = B(1,1:ind) + 1;
                        
                    case 0.5
                        numR = round(A(j,i+1), 3);
                        ind = find(L == numR);
                        
                        B(2,1:ind) = B(2,1:ind) + 1;                        
                        
                    case 1
                        numR = round(A(j,i+1), 3);
                        ind = find(L == numR);
                        
                        B(3,1:ind) = B(3,1:ind) + 1;                        
                        
                    case 2
                        numR = round(A(j,i+1), 3);
                        ind = find(L == numR);
                        
                        B(4,1:ind) = B(4,1:ind) + 1;                        
                        
                    case 2.5
                        numR = round(A(j,i+1), 3);
                        ind = find(L == numR);
                        
                        B(5,1:ind) = B(5,1:ind) + 1;                        
                        
                    case 3
                        numR = round(A(j,i+1), 3);
                        ind = find(L == numR);
                        
                        B(6,1:ind) = B(6,1:ind) + 1;                        
                        
                    case 4
                        numR = round(A(j,i+1), 3);
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
                        numR = round(A(j,i+1), 3);
                        ind = find(L == numR);
                        
                        B(1,indP:ind) = B(1,indP:ind) + 1;
                        
                    case 0.5
                        numR = round(A(j,i+1), 3);
                        ind = find(L == numR);
                        
                        B(2,indP:ind) = B(2,indP:ind) + 1;                        
                        
                    case 1
                        numR = round(A(j,i+1), 3);
                        ind = find(L == numR);
                        
                        B(3,indP:ind) = B(3,indP:ind) + 1;                        
                        
                    case 2
                        numR = round(A(j,i+1), 3);
                        ind = find(L == numR);
                        
                        B(4,indP:ind) = B(4,indP:ind) + 1;                        
                        
                    case 2.5
                        numR = round(A(j,i+1), 3);
                        ind = find(L == numR);
                        
                        B(5,indP:ind) = B(5,indP:ind) + 1;                        
                        
                    case 3
                        numR = round(A(j,i+1), 3);
                        ind = find(L == numR);
                        
                        B(6,indP:ind) = B(6,indP:ind) + 1;                        
                        
                    case 4
                        numR = round(A(j,i+1), 3);
                        ind = find(L == numR);
                        
                        B(7,indP:ind) = B(7,indP:ind) + 1;                        
                        
                    otherwise
                        error('wrong value');
                end                
            end
        end           
    end
    
    
end