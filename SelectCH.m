
function [CH,Sensors]=SelectCH(Sensors,Model,CH_idx)
   %  @file    GWO.m
%  @author  Nguyen Dao DHBKHN.
%  @version 1.0
%  @date    Jan 28, 2021
    CH=[];
    countCHs=0;
    n=Model.n;
    
    for i=1:1:n
        if(Sensors(i).E>0)          
            temp_rand=rand;      
            % if(i == minF2)    
            for j=1:length(CH_idx)
                if (i==CH_idx(j))               
                countCHs=countCHs+1; 
                CH(countCHs).id=i; %#ok                
                end
            end
        end
    end
end