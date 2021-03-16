function [CH,Sensors]=ReSelectCH(Sensors,Model)
    %  @file    GWO.m
 %  @author  Nguyen Dao DHBKHN.
 %  @version 1.0
 %  @date    March 16, 2021
   
     CH=[];
     countCHs=0;
     n=Model.n;
     
     for i=1:1:n
         if(Sensors(i).E>0)          
             temp_rand=rand;     
             if (Sensors(i).G<=0)            
                 %Election of Cluster Heads  
                 % if(i == minF2)    
                 if (Sensors(i).type=='C')
                                   
                     countCHs=countCHs+1; 
                     CH(countCHs).id=i; %#ok                
                     
                 end    
             end   
         end 
     end 
