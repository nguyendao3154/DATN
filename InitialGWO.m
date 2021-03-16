 % Developed by Nguyen Dao - DHBKHN
 
 function [Positions,Alpha_pos,Beta_pos,Delta_pos,Prey_pos] =  InitialGWO(Sensors,AlphaWolf,BetaWolf,DeltaWolf,n,ub,lb)

 global Alpha_pos Alpha_score Beta_pos Beta_score Delta_pos Delta_score Prey_pos a Alpha_weight Beta_weight Delta_weight;

 % initialize alpha, beta, and delta_pos
 Alpha_pos(1)=Sensors(AlphaWolf).xd; % the initial position of the leader wolf
 Alpha_pos(2)=Sensors(AlphaWolf).yd;
 Alpha_score=Sensors(AlphaWolf).F1; 
 
 Beta_pos(1)=Sensors(BetaWolf).xd; % the initial position of the second-best wolf
 Beta_pos(2)=Sensors(BetaWolf).yd;
 Beta_score=Sensors(BetaWolf).F1; 

 Delta_pos(1)=Sensors(DeltaWolf).xd; % the initial position of the third-best wolf
 Delta_pos(2)=Sensors(DeltaWolf).yd;
 Delta_score=Sensors(DeltaWolf).F1; 
 
%Initialize the positions of search agents
 Positions=initialization(n,ub,lb,Sensors);
%  Convergence_curve=zeros(1,Max_iter);
 
Alpha_weight = Alpha_score/(Alpha_score+Beta_score+Delta_score);
Beta_weight = Beta_score/(Alpha_score+Beta_score+Delta_score);
Delta_weight = Delta_score/(Alpha_score+Beta_score+Delta_score);

Prey_pos = (Alpha_weight.*Alpha_pos) + (Beta_weight.*Beta_pos) + (Delta_weight.*Delta_pos); %Calculate the initial position of prey according to Equation 5
 