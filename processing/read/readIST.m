function [E, F] = readIST(name)
    % reading data of IST dataset 3
    if strcmp(name,'full')
        % give-full
        E = [];
        % 
        % Full
        F{1} = readmatrix(['data/IST/give-' name '/1_right-4.csv']);
        F{2} = readmatrix(['data/IST/give-' name '/1_right-6.csv']);
        F{3} = readmatrix(['data/IST/give-' name '/2_right-5.csv']);
        F{4} = readmatrix(['data/IST/give-' name '/5_right-1.csv']);
        F{5} = readmatrix(['data/IST/give-' name '/5_right-2.csv']);
        F{6} = readmatrix(['data/IST/give-' name '/8_right-2.csv']);
        F{7} = readmatrix(['data/IST/give-' name '/8_right-6.csv']);
        F{8} = readmatrix(['data/IST/give-' name '/10_right-1.csv']);
        F{9} = readmatrix(['data/IST/give-' name '/14_right-1.csv']);
        F{10} = readmatrix(['data/IST/give-' name '/17_right-3.csv']);
        F{11} = readmatrix(['data/IST/give-' name '/30_right-3.csv']);
        F{12} = readmatrix(['data/IST/give-' name '/33_right-3.csv']);
        
    % reading data of give-empty
    elseif strcmp(name,'empty')
        
        E{1} = readmatrix(['data/IST/give-' name '/1_right-1.csv']);
        E{2} = readmatrix(['data/IST/give-' name '/3_right-1.csv']);
        E{3} = readmatrix(['data/IST/give-' name '/6_right-1.csv']);
        E{4} = readmatrix(['data/IST/give-' name '/6_right-2.csv']);
        E{5} = readmatrix(['data/IST/give-' name '/6_right-5.csv']);
        E{6} = readmatrix(['data/IST/give-' name '/7_right-6.csv']);
        E{7} = readmatrix(['data/IST/give-' name '/8_right-4.csv']);
        E{8} = readmatrix(['data/IST/give-' name '/9_right-2.csv']);
        E{9} = readmatrix(['data/IST/give-' name '/11_right-6.csv']);
        E{10} = readmatrix(['data/IST/give-' name '/12_right-1.csv']);
        E{11} = readmatrix(['data/IST/give-' name '/12_right-3.csv']);
        E{12} = readmatrix(['data/IST/give-' name '/13_right-2.csv']);
        E{13} = readmatrix(['data/IST/give-' name '/14_right-2.csv']);
        
        F = [];
        
    % reading data of give-empty
    elseif strcmp(name,'half')
        E = [];
        % 
        % Full
        F{1} = readmatrix(['data/IST/give-' name '/0_right-1.csv']);     
        F{2} = readmatrix(['data/IST/give-' name '/0_right-3.csv']);     
        F{3} = readmatrix(['data/IST/give-' name '/2_right-2.csv']);     
        F{4} = readmatrix(['data/IST/give-' name '/7_right-1.csv']);     
        F{5} = readmatrix(['data/IST/give-' name '/10_right-2.csv']);     
        F{6} = readmatrix(['data/IST/give-' name '/10_right-6.csv']);     
        F{7} = readmatrix(['data/IST/give-' name '/11_right-1.csv']);     
        F{8} = readmatrix(['data/IST/give-' name '/12_right-2.csv']);     
        F{9} = readmatrix(['data/IST/give-' name '/23_right-3.csv']);     
        F{10} = readmatrix(['data/IST/give-' name '/26_right-3.csv']);     
        
    else
        error('Name not Recognized!');
    end
    
end