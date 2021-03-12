function [Sensors,minToPrey,distance_ToPrey]=disToPrey(Sensors,n,Prey_pos)
    %% Developed by Nguyen Dao - DHBKHN
    
        for i=1:n
            
            distance_ToPrey=sqrt((Sensors(i).xd-Prey_pos(1))^2 + ...
                (Sensors(i).yd-Prey_pos(2))^2 );

            if i == 1
                minToPrey = 1;
            else

                if distance_ToPrey < Sensors(minToPrey).dis2prey
                    minToPrey = i;
                end

            end

            Sensors(i).dis2prey=distance_ToPrey;
            
        end
        
    end