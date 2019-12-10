function [E, F] = read(name)
    % reading data of Salman
    if strcmp(name,'Salman')
        % Empty
        E{1} = csvread('data/Salman/empty/0_right.csv');
        E{2} = csvread('data/Salman/empty/1_right.csv');
        E{3} = csvread('data/Salman/empty/3_right.csv');
        % 
        % Full
        F{1} = csvread('data/Salman/full/0_right.csv');
        F{2} = csvread('data/Salman/full/1_right.csv');
        F{3} = csvread('data/Salman/full/2_right.csv');
        F{4} = csvread('data/Salman/full/3_right.csv');
        % 
        % Half
        % H{1} = csvread('data/Salman/half/0_right.csv');
        % H{2} = csvread('data/Salman/half/1_right.csv');
        % H{3} = csvread('data/Salman/half/2_right.csv');
        % H{4} = csvread('data/Salman/half/5_right.csv');
        % H{5} = csvread('data/Salman/half/6_right.csv');
    
    % reading data of Leo
    elseif strcmp(name,'Leo')
        % % Empty
        E{1} = csvread('data/Leo/empty/0_right.csv');
        E{2} = csvread('data/Leo/empty/1_right.csv');
        E{3} = csvread('data/Leo/empty/2_right.csv');
        %
        % Full
        F{1} = csvread('data/Leo/full/1_right.csv');
        F{2} = csvread('data/Leo/full/2_right.csv');
        F{3} = csvread('data/Leo/full/3_right.csv');
        % 
        % 
        % Half
        % H{1} = csvread('data/Leo/half/0_right.csv');
        % H{2} = csvread('data/Leo/half/1_right.csv');
        % H{3} = csvread('data/Leo/half/2_right.csv');
        % H{4} = csvread('data/Leo/half/5_right.csv');
        % H{5} = csvread('data/Leo/half/6_right.csv');
        
    % reading data of Bernardo
    elseif strcmp(name,'Bernardo')
        % Empty
        E{1} = csvread('data/Bernardo/empty/0_right.csv');
        E{2} = csvread('data/Bernardo/empty/1_right.csv');
        E{3} = csvread('data/Bernardo/empty/2_right.csv');
        % 
        % Full
        F{1} = csvread('data/Bernardo/full/0_right.csv');
        F{2} = csvread('data/Bernardo/full/1_right.csv');
        F{3} = csvread('data/Bernardo/full/2_right.csv');
        F{4} = csvread('data/Bernardo/full/3_right.csv');
        F{5} = csvread('data/Bernardo/full/4_right.csv');
    elseif strcmp(name,'All')
        E{1} = csvread('data/Salman/empty/0_right.csv');
        E{2} = csvread('data/Salman/empty/1_right.csv');
        E{3} = csvread('data/Salman/empty/3_right.csv');
        E{4} = csvread('data/Leo/empty/0_right.csv');
        E{5} = csvread('data/Leo/empty/1_right.csv');
        E{6} = csvread('data/Leo/empty/2_right.csv');
        E{7} = csvread('data/Leo/empty/0_right.csv');
        E{8} = csvread('data/Leo/empty/1_right.csv');
        E{9} = csvread('data/Leo/empty/2_right.csv');
        %
        % Full
        F{1} = csvread('data/Leo/full/1_right.csv');
        F{2} = csvread('data/Leo/full/2_right.csv');
        F{3} = csvread('data/Leo/full/3_right.csv');
        F{4} = csvread('data/Leo/full/1_right.csv');
        F{5} = csvread('data/Leo/full/2_right.csv');
        F{6} = csvread('data/Leo/full/3_right.csv');% 
        F{7} = csvread('data/Salman/full/0_right.csv');
        F{8} = csvread('data/Salman/full/1_right.csv');
        F{9} = csvread('data/Salman/full/2_right.csv');
        F{10} = csvread('data/Salman/full/3_right.csv');    
    else
        error('Name not Recognized!');
    end
    
end