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

%             E{1} = csvread(['data/' name '/' object '/empty/0_right.csv']);
%             E{1}(135:end,:) = 0;
%             E{1} = csvread(['data/' name '/' object '/empty/1_right.csv']);
%             E{1}(130:end,:) = 0;
            E{1} = csvread(['data/' name '/' object '/empty/4_right.csv']);
            E{1}(110:end,:) = 0;        
            E{2} = csvread(['data/' name '/' object '/empty/2_right.csv']);
            E{2}(150:end,:) = 0;
%             E{2} = csvread(['data/' name '/' object '/empty/3_right.csv']);
%             E{2}(100:end,:) = 0;
            %
%             F{1} = csvread(['data/' name '/' object '/full/0_right.csv']);
%             F{1}(100:end,:) = 0;
            F{1} = csvread(['data/' name '/' object '/full/4_right.csv']);
            F{1}(80:end,:) = 0;
            F{2} = csvread(['data/' name '/' object '/full/1_right.csv']);
            F{2}(100:end,:) = 0;    

        elseif strcmp(object,'trash-plastic-cup')
            E{1} = csvread(['data/trash/' name '-new/' object '/empty/0_right.csv']);
            E{2} = csvread(['data/trash/' name '-new/' object '/empty/1_right.csv']);
            E{3} = csvread(['data/trash/' name '-new/' object '/empty/2_right.csv']);
            E{4} = csvread(['data/trash/' name '-new/' object '/empty/3_right.csv']);
            E{5} = csvread(['data/trash/' name '-new/' object '/empty/4_right.csv']);
            %
            F{1} = csvread(['data/trash/' name '-new/' object '/full/0_right.csv']);
            F{2} = csvread(['data/trash/' name '-new/' object '/full/1_right.csv']);
            F{3} = csvread(['data/trash/' name '-new/' object '/full/2_right.csv']);
            F{4} = csvread(['data/trash/' name '-new/' object '/full/3_right.csv']);
            F{5} = csvread(['data/trash/' name '-new/' object '/full/4_right.csv']);
            F{6} = csvread(['data/trash/' name '-new/' object '/full/5_right.csv']);

        elseif strcmp(object, 'trash-red-cup')
            E{1} = csvread(['data/trash/' name '-new/' object '/empty/0_right.csv']);
            E{2} = csvread(['data/trash/' name '-new/' object '/empty/1_right.csv']);
            E{3} = csvread(['data/trash/' name '-new/' object '/empty/2_right.csv']);
            E{4} = csvread(['data/trash/' name '-new/' object '/empty/3_right.csv']);
            E{5} = csvread(['data/trash/' name '-new/' object '/empty/4_right.csv']);
            E{6} = csvread(['data/trash/' name '-new/' object '/empty/5_right.csv']);
            %
            F{1} = csvread(['data/trash/' name '-new/' object '/full/0_right.csv']);
            F{2} = csvread(['data/trash/' name '-new/' object '/full/1_right.csv']);
            F{3} = csvread(['data/trash/' name '-new/' object '/full/2_right.csv']);
            F{4} = csvread(['data/trash/' name '-new/' object '/full/3_right.csv']);
            
        elseif strcmp(object, 'red-cup')
            E{1} = csvread(['data/' name '/' object '/empty/0_right.csv']);
            E{1}(35:end,:) = 0;
            E{2} = csvread(['data/' name '/' object '/empty/1_right.csv']);
            E{2}(70:end,:) = 0;
            E{3} = csvread(['data/' name '/' object '/empty/2_right.csv']);

            %
            F{1} = csvread(['data/' name '/' object '/full/1_right.csv']);
            F{1}(90:end,:) = 0;
            F{2} = csvread(['data/' name '/' object '/full/2_right.csv']);
            F{2}(100:end,:) = 0;
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
            E{2}(750:end,:) = 0;
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
            F{1}(700:end,:) = 0;
            F{2} = csvread(['data/' name '/' object '/full/2_right.csv']);
            F{2}(1100:end,:) = 0;        
        
        elseif strcmp(object,'new-plastic-cup')
            E{1} = csvread(['data/zApproach/' name '/plastic-cup' '/empty/0_right.csv']);
            E{2} = csvread(['data/zApproach/' name '/plastic-cup' '/empty/1_right.csv']);
            E{3} = csvread(['data/zApproach/' name '/plastic-cup' '/empty/2_right.csv']);
            E{4} = csvread(['data/zApproach/' name '/plastic-cup' '/empty/3_right.csv']);
            %
            F{1} = csvread(['data/zApproach/' name '/plastic-cup' '/full/0_right.csv']);
            F{2} = csvread(['data/zApproach/' name '/plastic-cup' '/full/1_right.csv']);
            F{3} = csvread(['data/zApproach/' name '/plastic-cup' '/full/2_right.csv']);

        elseif strcmp(object, 'new-red-cup')
            E{1} = csvread(['data/zApproach/' name '/red-cup' '/empty/0_right.csv']);
            E{2} = csvread(['data/zApproach/' name '/red-cup' '/empty/1_right.csv']);
            E{3} = csvread(['data/zApproach/' name '/red-cup' '/empty/2_right.csv']);
            E{4} = csvread(['data/zApproach/' name '/red-cup' '/empty/3_right.csv']);
            %
            F{1} = csvread(['data/zApproach/' name '/red-cup' '/full/0_right.csv']);
            F{2} = csvread(['data/zApproach/' name '/red-cup' '/full/1_right.csv']);
            F{3} = csvread(['data/zApproach/' name '/red-cup' '/full/2_right.csv']);
            F{4} = csvread(['data/zApproach/' name '/red-cup' '/full/3_right.csv']);
            
        elseif strcmp(object,'red-mug')
            E{1} = csvread(['data/' name '/' object '/empty/0_right.csv']);
            E{2} = csvread(['data/' name '/' object '/empty/2_right.csv']);
            E{3} = csvread(['data/' name '/' object '/empty/3_right.csv']);
            E{4} = csvread(['data/' name '/' object '/empty/4_right.csv']);
            E{5} = csvread(['data/' name '/' object '/empty/5_right.csv']);
            %
%             F{1} = csvread(['data/' name '/' object '/half/0_right.csv']);
            F{1} = csvread(['data/' name '/' object '/half/1_right.csv']);
            F{2} = csvread(['data/' name '/' object '/half/2_right.csv']);
            F{3} = csvread(['data/' name '/' object '/half/3_right.csv']);
            F{3}(120:end,:) = 0;
            F{4} = csvread(['data/' name '/' object '/half/4_right.csv']);
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
            E{5} = csvread(['data/' name '/' object '/full/2_right.csv']);
            E{6} = csvread(['data/' name '/' object '/full/3_right.csv']);
            E{7} = csvread(['data/' name '/' object '/full/4_right.csv']);        
            E{7}(1500:end,:) = 0;
            
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
            E{2}(:,2:3) = -1*E{2}(:,2:3);
            %
            F{1} = csvread(['data/' name '/' object '/full/0_right.csv']);
            F{1}(70:end,:) = 0;
            F{2} = csvread(['data/' name '/' object '/full/1_right.csv']);
            F{2}(100:end,:) = 0;
            F{3} = csvread(['data/' name '/' object '/full/2_right.csv']);

        elseif strcmp(object, 'trash-red-cup')
            E{1} = csvread(['data/trash/' name '-new/' object '/empty/0_right.csv']);
            E{2} = csvread(['data/trash/' name '-new/' object '/empty/1_right.csv']);
            E{3} = csvread(['data/trash/' name '-new/' object '/empty/2_right.csv']);
            E{4} = csvread(['data/trash/' name '-new/' object '/empty/3_right.csv']);
            %
            F{1} = csvread(['data/trash/' name '-new/' object '/full/0_right.csv']);
            F{2} = csvread(['data/trash/' name '-new/' object '/full/1_right.csv']);
            F{3} = csvread(['data/trash/' name '-new/' object '/full/2_right.csv']);

         end

    elseif strcmp(name,'All')
            E{1} = csvread(['data/' 'Leo' '/' 'red-cup' '/empty/1_right.csv']);             
            E{1}(750:end,:) = 0;       
            E{2} = csvread(['data/' 'Bernardo' '/' 'bowl' '/empty/0_right.csv']);
            E{3} = csvread(['data/' 'Bernardo' '/' 'bowl' '/empty/1_right.csv']);
            E{3}(750:end,:) = 0;            
            E{4} = csvread(['data/' 'Bernardo' '/' 'bowl' '/full/1_right.csv']);
            E{5} = csvread(['data/' 'Bernardo' '/' 'bowl' '/full/2_right.csv']);     
            E{6} = csvread(['data/' 'Bernardo' '/' 'bowl' '/empty/2_right.csv']);
            E{7} = csvread(['data/' 'Bernardo' '/' 'bowl' '/full/0_right.csv']);
            E{7}(1000:end,:) = 0;
            E{8} = csvread(['data/' 'Bernardo' '/' 'bowl' '/full/3_right.csv']);
%             E{6} = csvread(['data/' 'Kunpeng' '/' 'red-cup' '/empty/0_right.csv']);
%             E{6}(35:end,:) = 0;
            
            
            F{1} = csvread(['data/' 'Leo' '/' 'red-cup' '/full/2_right.csv']);
            F{2} = csvread(['data/' 'Salman' '/' 'red-mug' '/full/0_right.csv']);
            F{3} = csvread(['data/' 'Salman' '/' 'red-mug' '/full/1_right.csv']);
            F{4} = csvread(['data/' 'Salman' '/' 'red-mug' '/full/2_right.csv']);
            F{5} = csvread(['data/' 'Salman' '/' 'red-mug' '/full/3_right.csv']);
            F{6} = csvread(['data/' 'Salman' '/' 'red-mug' '/empty/0_right.csv']);
            F{7} = csvread(['data/' 'Salman' '/' 'red-mug' '/empty/1_right.csv']);
            F{8} = csvread(['data/' 'Salman' '/' 'red-mug' '/empty/3_right.csv']);
            F{9} = csvread(['data/' 'Leo' '/' 'red-cup' '/full/1_right.csv']);
            F{9}(1300:end,:) = 0;
            F{10} = csvread(['data/' 'Leo' '/' 'red-cup' '/full/3_right.csv']);
            F{10}(2500:end,:) = 0;   
%             E{1} = csvread(['data/' 'Bernardo' '/' 'bowl' '/empty/0_right.csv']);
%             E{2} = csvread(['data/' 'Bernardo' '/' 'bowl' '/empty/1_right.csv']);
%             E{2}(750:end,:) = 0;
%             E{3} = csvread(['data/' 'Bernardo' '/' 'bowl' '/empty/2_right.csv']);
%             E{4} = csvread(['data/' 'Bernardo' '/' 'bowl' '/full/0_right.csv']);
%             E{4}(1000:end,:) = 0;
%             E{5} = csvread(['data/' 'Bernardo' '/' 'bowl' '/full/1_right.csv']);
%             E{5} = csvread(['data/' 'Bernardo' '/' 'bowl' '/full/2_right.csv']);
%             E{6} = csvread(['data/' 'Bernardo' '/' 'bowl' '/full/3_right.csv']);
%             E{7} = csvread(['data/' 'Bernardo' '/' 'bowl' '/full/4_right.csv']);        
%             E{7}(1500:end,:) = 0;            
%             E{8} = csvread(['data/' 'Leo' '/' 'red-cup' '/empty/0_right.csv']);
%             E{8}(1100:end,:) = 0;
%             E{9} = csvread(['data/' 'Leo' '/' 'red-cup' '/empty/1_right.csv']);             
%             E{9}(750:end,:) = 0;
%             E{10} = csvread(['data/' 'Leo' '/' 'red-cup' '/empty/2_right.csv']);
%             
%             F{1} = csvread(['data/' 'Leo' '/' 'red-cup' '/full/2_right.csv']);
%             F{2} = csvread(['data/' 'Salman' '/' 'red-mug' '/full/0_right.csv']);
%             F{3} = csvread(['data/' 'Salman' '/' 'red-mug' '/full/1_right.csv']);
%             F{4} = csvread(['data/' 'Salman' '/' 'red-mug' '/full/2_right.csv']);
%             F{5} = csvread(['data/' 'Salman' '/' 'red-mug' '/full/3_right.csv']);
%             F{6} = csvread(['data/' 'Salman' '/' 'red-mug' '/empty/0_right.csv']);
%             F{7} = csvread(['data/' 'Salman' '/' 'red-mug' '/empty/1_right.csv']);
%             F{8} = csvread(['data/' 'Salman' '/' 'red-mug' '/empty/3_right.csv']);
%             F{9} = csvread(['data/' 'Leo' '/' 'red-cup' '/full/1_right.csv']);
%             F{9}(1300:end,:) = 0;
%             F{10} = csvread(['data/' 'Leo' '/' 'red-cup' '/full/3_right.csv']);
%             F{10}(2500:end,:) = 0;   
            
    elseif strcmp(name,'All-left')
            E{1} = csvread(['data/' 'Kunpeng' '/' 'red-cup' '/empty/0_right.csv']);
            E{1}(35:end,:) = 0;
            
            F{1} = csvread(['data/' 'Salman' '/' 'red-mug' '/empty/1_right.csv']);
            F{2} = csvread(['data/' 'Salman' '/' 'red-mug' '/empty/3_right.csv']);
    else
        error('Name not Recognized!');
    end
    
end