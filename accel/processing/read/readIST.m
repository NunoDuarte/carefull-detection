function [E, F] = readIST(name)
    % reading data of IST dataset 3
    if strcmp(name,'full')
        % give-full
        E = [];
        % 
        % Full
        F{1} = load(['data/IST/1/1-full_r.mat']).data;
        F{2} = load(['data/IST/1/2-full_r.mat']).data;
        F{3} = load(['data/IST/1/3-full_r.mat']).data;
        F{4} = load(['data/IST/2/1-full_r.mat']).data;
        F{5} = load(['data/IST/2/3-full_r.mat']).data;
        F{6} = load(['data/IST/3/2-full_r.mat']).data;
        F{7} = load(['data/IST/3/3-full_r.mat']).data;
        F{8} = load(['data/IST/4/1-full_r.mat']).data;
        F{9} = load(['data/IST/4/2-full_r.mat']).data;
        F{10} = load(['data/IST/6/1-full_r.mat']).data;
        F{11} = load(['data/IST/6/2-full_r.mat']).data;
        F{12} = load(['data/IST/6/3-full_r.mat']).data;
        
    % reading data of give-empty
    elseif strcmp(name,'empty')
        
        E{1} = load(['data/IST/1/1-empty_r.mat']).data;
        E{2} = load(['data/IST/1/2-empty_r.mat']).data;
        E{3} = load(['data/IST/1/3-empty_r.mat']).data;
        E{4} = load(['data/IST/2/1-empty_r.mat']).data;
        E{5} = load(['data/IST/2/2-empty_r.mat']).data;
        E{6} = load(['data/IST/2/3-empty_r.mat']).data;
        E{7} = load(['data/IST/3/1-empty_r.mat']).data;
        E{8} = load(['data/IST/3/2-empty_r.mat']).data;
        E{9} = load(['data/IST/3/3-empty_r.mat']).data;
        E{10} = load(['data/IST/4/1-empty_r.mat']).data;
        E{11} = load(['data/IST/4/2-empty_r.mat']).data;
        E{12} = load(['data/IST/6/1-empty_r.mat']).data;
        
        F = [];
        
    % reading data of give-empty
    elseif strcmp(name,'half')
        E = [];
        % 
        % Half
        F{1} = load(['data/IST/1/1-half_r.mat']).data;
        F{2} = load(['data/IST/1/2-half_r.mat']).data;
        F{3} = load(['data/IST/1/3-half_r.mat']).data;
        F{4} = load(['data/IST/2/1-half_r.mat']).data;
        F{5} = load(['data/IST/3/1-half_r.mat']).data;
        F{6} = load(['data/IST/3/2-half_r.mat']).data;
        F{7} = load(['data/IST/3/3-half_r.mat']).data;
        F{8} = load(['data/IST/4/1-half_r.mat']).data;
        F{9} = load(['data/IST/4/2-half_r.mat']).data;
        F{10} = load(['data/IST/4/3-half_r.mat']).data;
        F{11} = load(['data/IST/6/1-half_r.mat']).data;
        F{12} = load(['data/IST/6/2-half_r.mat']).data;
        
    else
        error('Name not Recognized!');
    end
    
end