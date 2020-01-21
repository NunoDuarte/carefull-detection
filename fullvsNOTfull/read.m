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
        
    % reading data of Leo
    elseif strcmp(name,'Leo')
        % % Empty
        E{1} = csvread('data/Leo/empty/0_right.csv');
        E{1}(1100:end,:) = 0;
        E{2} = csvread('data/Leo/empty/1_right.csv');
        E{2}(1300:end,:) = 0;
        E{3} = csvread('data/Leo/empty/2_right.csv');
        %
        % Full
        F{1} = csvread('data/Leo/full/1_right.csv');
        F{1}(1300:end,:) = 0;
        F{2} = csvread('data/Leo/full/2_right.csv');
        F{3} = csvread('data/Leo/full/3_right.csv');
        F{3}(2500:end,:) = 0;

    % reading data of Leo plastic cup
    elseif strcmp(name,'Leo-plastic')
        % Empty
        E{1} = csvread('data/Leo-plastic/empty/0_right.csv');
        E{1}(650:end,:) = 0;
        E{2} = csvread('data/Leo-plastic/empty/1_right.csv');
        E{3} = csvread('data/Leo-plastic/empty/2_right.csv');
        E{3}(1100:end,:) = 0;
        %
        % Full
        F{1} = csvread('data/Leo-plastic/full/1_right.csv');
%         F{1}(1300:end,:) = 0;
        F{2} = csvread('data/Leo-plastic/full/2_right.csv');
%         F{3} = csvread('data/Leo-plastic/full/3_right.csv');
%         F{3}(2500:end,:) = 0;
         
    % reading data of Bernardo
    elseif strcmp(name,'Bernardo')
        % Empty
        E{1} = csvread('data/Bernardo/empty/0_right.csv');
        E{2} = csvread('data/Bernardo/empty/1_right.csv');
        E{2}(750:end,:) = 0;
        E{3} = csvread('data/Bernardo/empty/2_right.csv');
        %
        % Full
        F{1} = csvread('data/Bernardo/full/0_right.csv');
        F{1}(1000:end,:) = 0;
        F{2} = csvread('data/Bernardo/full/1_right.csv');
        F{3} = csvread('data/Bernardo/full/2_right.csv');
        F{4} = csvread('data/Bernardo/full/3_right.csv');
        F{5} = csvread('data/Bernardo/full/4_right.csv');        
        F{5}(1500:end,:) = 0;

    elseif strcmp(name,'All')

        E{1} = csvread('data/Leo/empty/0_right.csv');
        E{1}(1100:end,:) = 0;
        E{2} = csvread('data/Leo/empty/1_right.csv');
        E{2}(1300:end,:) = 0;
        E{3} = csvread('data/Leo/empty/2_right.csv');
        E{4} = csvread('data/Bernardo/empty/0_right.csv');
        E{5} = csvread('data/Bernardo/empty/1_right.csv');
        %
        % Full
        F{1} = csvread('data/Leo/full/1_right.csv');
        F{1}(1300:end,:) = 0;
        F{2} = csvread('data/Leo/full/2_right.csv');
        F{3} = csvread('data/Leo/full/3_right.csv');
        F{3}(2500:end,:) = 0;
        F{4} = csvread('data/Bernardo/full/0_right.csv');
        F{5} = csvread('data/Bernardo/full/1_right.csv');
        F{6} = csvread('data/Bernardo/full/2_right.csv');
        F{7} = csvread('data/Bernardo/full/3_right.csv');
        F{8} = csvread('data/Bernardo/full/4_right.csv');
        F{9} = csvread('data/Bernardo/empty/2_right.csv');
    else
        error('Name not Recognized!');
    end
    
end