function [E, F] = read(name, object)
    % reading data of Salman
    if strcmp(name,'Salman')
        if strcmp(object,'red-mug')
            % All Slow (super careful)
            E = [];
            % 
            % Full
            F{1} = csvread(['data/' name '/' object '/full/0_right.csv']);
            F{2} = csvread(['data/' name '/' object '/full/1_right.csv']);
            F{3} = csvread(['data/' name '/' object '/full/2_right.csv']);
            F{4} = csvread(['data/' name '/' object '/full/3_right.csv']);
            F{5} = csvread(['data/' name '/' object '/empty/0_right.csv']);
            F{6} = csvread(['data/' name '/' object '/empty/1_right.csv']);
            F{7} = csvread(['data/' name '/' object '/empty/3_right.csv']);
        end
        
    % reading data of David
    elseif strcmp(name,'David')
        if strcmp(object,'plastic-cup')
            E{1} = csvread(['data/' name '/' object '/empty/1_right.csv']);
            E{2} = csvread(['data/' name '/' object '/empty/2_right.csv']);
            E{3} = csvread(['data/' name '/' object '/empty/3_right.csv']);
            E{3}(130:end,:) = 0;
            E{4} = csvread(['data/' name '/' object '/full/4_right.csv']);
            E{5} = csvread(['data/' name '/' object '/full/2_right.csv']);

            %
            F{1} = csvread(['data/' name '/' object '/full/0_right.csv']);
            F{1}(250:end,:) = 0;
            F{2} = csvread(['data/' name '/' object '/full/1_right.csv']);
            F{3} = csvread(['data/' name '/' object '/full/3_right.csv']);
            F{4} = csvread(['data/' name '/' object '/empty/0_right.csv']);
            F{4}(100:end,:) = 0;
            F{5} = csvread(['data/' name '/' object '/empty/4_right.csv']);
        elseif strcmp(object, 'red-cup')
            E{1} = csvread(['data/' name '/' object '/empty/2_right.csv']);
            E{2} = csvread(['data/' name '/' object '/empty/3_right.csv']);
            %
            F{1} = csvread(['data/' name '/' object '/full/0_right.csv']);
            F{2} = csvread(['data/' name '/' object '/full/1_right.csv']);
            F{2}(120:end,:) = 0;
            F{3} = csvread(['data/' name '/' object '/empty/1_right.csv']);
        elseif strcmp(object, 'pasta')
            E{1} = csvread(['data/' name '/' object '/empty/0_right.csv']);
            E{2} = csvread(['data/' name '/' object '/empty/1_right.csv']);
            E{2}(90:end,:) = 0;
            %
            F{1} = csvread(['data/' name '/' object '/full/0_right.csv']);
            F{1}(60:end,:) = 0;
            F{2} = csvread(['data/' name '/' object '/full/1_right.csv']);
            F{2}(75:end,:) = 0;
            F{3} = csvread(['data/' name '/' object '/full/2_right.csv']);
            F{3}(170:end,:) = 0;
            F{4} = csvread(['data/' name '/' object '/full/3_right.csv']);            
            F{4}(115:end,:) = 0;
        end
        
    % reading data of Kunpeng
    elseif strcmp(name,'Kunpeng')
        if strcmp(object,'plastic-cup')
            E{1} = csvread(['data/' name '/' object '/empty/0_right.csv']);
            E{1}(135:end,:) = 0;
            E{2} = csvread(['data/' name '/' object '/empty/1_right.csv']);
            E{2}(130:end,:) = 0;
            E{3} = csvread(['data/' name '/' object '/empty/2_right.csv']);
            E{3}(150:end,:) = 0;
            E{4} = csvread(['data/' name '/' object '/empty/3_right.csv']);
            E{4}(100:end,:) = 0;
            E{5} = csvread(['data/' name '/' object '/empty/4_right.csv']);
            E{5}(120:end,:) = 0;
            %
            F{1} = csvread(['data/' name '/' object '/full/0_right.csv']);
            F{1}(100:end,:) = 0;
            F{2} = csvread(['data/' name '/' object '/full/1_right.csv']);
            F{2}(200:end,:) = 0;
            F{3} = csvread(['data/' name '/' object '/full/4_right.csv']);
            F{3}(200:end,:) = 0;

        elseif strcmp(object, 'red-cup')
            E{1} = csvread(['data/' name '/' object '/empty/0_right.csv']);
            E{1}(85:end,:) = 0;
            E{2} = csvread(['data/' name '/' object '/empty/1_right.csv']);
            E{3} = csvread(['data/' name '/' object '/empty/2_right.csv']);
            %
            F{1} = csvread(['data/' name '/' object '/full/1_right.csv']);
            F{1}(130:end,:) = 0;
            F{2} = csvread(['data/' name '/' object '/full/2_right.csv']);
            F{2}(150:end,:) = 0;
            F{3} = csvread(['data/' name '/' object '/full/3_right.csv']);
        elseif strcmp(object,'wine-glass')
            E{1} = csvread(['data/' name '/' object '/empty/0_right.csv']);
            E{1}(60:end,:) = 0;
            E{2} = csvread(['data/' name '/' object '/empty/1_right.csv']);
            E{2}(100:end,:) = 0;
            E{3} = csvread(['data/' name '/' object '/empty/2_right.csv']);
            E{3}(120:end,:) = 0;
            E{4} = csvread(['data/' name '/' object '/empty/3_right.csv']);
            E{4}(80:end,:) = 0;
            E{5} = csvread(['data/' name '/' object '/empty/4_right.csv']);
            E{5}(150:end,:) = 0;
            %
            F{1} = csvread(['data/' name '/' object '/full/0_right.csv']);
            F{1}(110:end,:) = 0;
            F{2} = csvread(['data/' name '/' object '/full/1_right.csv']);          
            F{2} = csvread(['data/' name '/' object '/full/3_right.csv']);
            F{3} = csvread(['data/' name '/' object '/full/4_right.csv']);
            F{3}(120:end,:) = 0;
        end     
        
    % reading data of Leo
    elseif strcmp(name,'Leo')
        if strcmp(object, 'red-cup')
            E{1} = csvread(['data/' name '/' object '/empty/0_right.csv']);
            E{1}(1100:end,:) = 0;
            E{2} = csvread(['data/' name '/' object '/empty/1_right.csv']);
            E{2}(1300:end,:) = 0;
            E{3} = csvread(['data/' name '/' object '/empty/2_right.csv']);
            %
            F{1} = csvread(['data/' name '/' object '/full/1_right.csv']);
            F{1}(1300:end,:) = 0;
            F{2} = csvread(['data/' name '/' object '/full/2_right.csv']);
            F{3} = csvread(['data/' name '/' object '/full/3_right.csv']);
            F{3}(2500:end,:) = 0;
        elseif strcmp(object,'plastic-cup')
            E{1} = csvread(['data/' name '/' object '/empty/0_right.csv']);
            E{1}(650:end,:) = 0;
            E{2} = csvread(['data/' name '/' object '/empty/1_right.csv']);
            E{3} = csvread(['data/' name '/' object '/empty/2_right.csv']);
            E{3}(1100:end,:) = 0;
            %
            F{1} = csvread(['data/' name '/' object '/full/1_right.csv']);
            F{2} = csvread(['data/' name '/' object '/full/2_right.csv']);
%         elseif strcmp(object,'red-mug')
%             E{1} = csvread(['data/' name '/' object '/empty/0_right.csv']);
%             E{2} = csvread(['data/' name '/' object '/empty/2_right.csv']);
%             E{3} = csvread(['data/' name '/' object '/empty/3_right.csv']);
%             E{4} = csvread(['data/' name '/' object '/empty/4_right.csv']);
%             E{5} = csvread(['data/' name '/' object '/empty/5_right.csv']);
%             %
% %             F{1} = csvread(['data/' name '/' object '/half/0_right.csv']);
%             F{1} = csvread(['data/' name '/' object '/half/1_right.csv']);
%             F{2} = csvread(['data/' name '/' object '/half/2_right.csv']);
%             F{3} = csvread(['data/' name '/' object '/half/3_right.csv']);
%             F{3}(120:end,:) = 0;
%             F{4} = csvread(['data/' name '/' object '/half/4_right.csv']);
        elseif strcmp(object,'champagne')
            E{1} = csvread(['data/' name '/' object '/empty/1_right.csv']);
            E{2} = csvread(['data/' name '/' object '/empty/2_right.csv']);
            E{2}(130:end,:) = 0;
            E{3} = csvread(['data/' name '/' object '/empty/3_right.csv']);
            E{3}(90:end,:) = 0;
            E{4} = csvread(['data/' name '/' object '/empty/4_right.csv']);
            %
            F{1} = csvread(['data/' name '/' object '/full/0_right.csv']);
            F{2} = csvread(['data/' name '/' object '/full/1_right.csv']);
            F{3} = csvread(['data/' name '/' object '/full/3_right.csv']);
            F{4} = csvread(['data/' name '/' object '/full/4_right.csv']);
        elseif strcmp(object,'wine-glass')
            E{1} = csvread(['data/' name '/' object '/empty/0_right.csv']);
            E{2} = csvread(['data/' name '/' object '/empty/1_right.csv']);
            E{3} = csvread(['data/' name '/' object '/empty/2_right.csv']);
            E{4} = csvread(['data/' name '/' object '/empty/4_right.csv']);
            E{4}(150:end,:) = 0;
            E{5} = csvread(['data/' name '/' object '/empty/5_right.csv']);
            %
            F{1} = csvread(['data/' name '/' object '/full/0_right.csv']);
            F{2} = csvread(['data/' name '/' object '/full/1_right.csv']);
            F{3} = csvread(['data/' name '/' object '/full/2_right.csv']);
            F{4} = csvread(['data/' name '/' object '/full/3_right.csv']);
        end
         
    % reading data of Bernardo
    elseif strcmp(name,'Bernardo')
        if strcmp(object, 'bowl')
            % Empty
            E{1} = csvread(['data/' name '/' object '/empty/0_right.csv']);
            E{2} = csvread(['data/' name '/' object '/empty/1_right.csv']);
            E{2}(750:end,:) = 0;
            E{3} = csvread(['data/' name '/' object '/empty/2_right.csv']);
            E{4} = csvread(['data/' name '/' object '/full/0_right.csv']);
            E{4}(1000:end,:) = 0;
            E{5} = csvread(['data/' name '/' object '/full/1_right.csv']);
            E{6} = csvread(['data/' name '/' object '/full/2_right.csv']);
            E{7} = csvread(['data/' name '/' object '/full/3_right.csv']);
            E{8} = csvread(['data/' name '/' object '/full/4_right.csv']);        
            E{8}(1500:end,:) = 0;
            %
            % Full (All fast)
            F = [];

        end
        
    % reading data of Athanasios
    elseif strcmp(name,'Athanasios')
         if strcmp(object, 'champagne')
            E{1} = csvread(['data/' name '/' object '/empty/0_right.csv']);
            E{1}(90:end,:) = 0;
            E{2} = csvread(['data/' name '/' object '/empty/1_right.csv']);
            E{3} = csvread(['data/' name '/' object '/empty/3_right.csv']);
            E{3}(90:end,:) = 0;
            E{4} = csvread(['data/' name '/' object '/empty/4_right.csv']);
            E{5} = csvread(['data/' name '/' object '/empty/5_right.csv']);
            E{5}(70:end,:) = 0;
            %
            F{1} = csvread(['data/' name '/' object '/full/0_right.csv']);
            F{1}(150:end,:) = 0;
            F{2} = csvread(['data/' name '/' object '/full/1_right.csv']);
            F{2}(90:end,:) = 0;
         elseif strcmp(object, 'red-cup')
            E{1} = csvread(['data/' name '/' object '/empty/0_right.csv']);
            E{2} = csvread(['data/' name '/' object '/empty/3_right.csv']);
            E{2}(85:end,:) = 0;
            %
            F{1} = csvread(['data/' name '/' object '/full/0_right.csv']);
            F{1}(70:end,:) = 0;
            F{2} = csvread(['data/' name '/' object '/full/1_right.csv']);
            F{2}(100:end,:) = 0;
            F{3} = csvread(['data/' name '/' object '/full/2_right.csv']);
         end

    elseif strcmp(name,'All')
            
    else
        error('Name not Recognized!');
    end
    
end