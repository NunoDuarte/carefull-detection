
for i=1:length(E)
    % pick the elements of time vector not 0
    TimeVE = find(E{i}(:,4) ~= 0);
    % get the time information
    TE{i} = E{i}(TimeVE,1);

    for j=1:length(TE{i})-1
        
       diffTE{i}(j) = TE{i}(j+1) -  TE{i}(j); 
        
    end
    
end


for i=1:length(F)
    % pick the elements of time vector not 0
    TimeVF = find(F{i}(:,4) ~= 0);
    % get the time information
    TF{i} = F{i}(TimeVF,1);

    for j=1:length(TF{i})-1
        
       diffTF{i}(j) = TF{i}(j+1) -  TF{i}(j); 
        
    end
    
end

%% check frequencies in each segmented trajectory

mean(diffTE{4})

mean(diffTF{3})

