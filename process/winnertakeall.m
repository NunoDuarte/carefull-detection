 function [B_d] = winnertakeall(b, b_d)

    B_d = [0, 0];
    [b1_d, w] = max(b_d);
    if b(w) == 1
        for i=1:2
            B_d(i) = 0;
        end
        return 
    end

    if w == 1
       v = 2; 
    elseif w == 2
       v = 1;       
    end
    
    z = (b_d(w) + b_d(v))/2;
    
    for i=1:2
       B_d(i) = b_d(i) - z; 
    end
    
    S = 0;
    
    for i=1:2
       if b(i) ~= 0 ||  B_d(i) > 0
          S = S + B_d(i); 
       end
    end
    
    B_d(w) = B_d(w) - S;
    
end