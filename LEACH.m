%% Developed by Amin Nazari 
% 	aminnazari91@gmail.com 
%	0918 546 2272
%   Developed by: Nguyen Dao - DHBKHN

clc;
clear; 
close all;
warning off all;
tic;
global srp rrp sdp rdp r a Max_iter CH_idx
Max_iter=50; % Maximum numbef of iterations

%% Create sensor nodes, Set Parameters and Create Energy Model 
%%%%%%%%%%%%%%%%%%%%%%%%% Initial Parameters %%%%%%%%%%%%%%%%%%%%%%%
n=100;                                  %Number of Nodes in the field
ub = 100;
lb = 1;
[Area,Model]=setParameters(n);     		%Set Parameters Sensors and Network

%%%%%%%%%%%%%%%%%%%%%%%%% configuration Sensors %%%%%%%%%%%%%%%%%%%%
%CreateRandomSen(Model,Area);            %Create a random scenario
load Locations                          %Load sensor Location
Sensors=ConfigureSensors(Model,n,X,Y);
% Sensors=ConfigureSensors(Model,n,Area.x,Area.y);

%%%%%%%%%%%%%%%%%%%%%%%%% Parameters initialization %%%%%%%%%%%%%%%%
countCHs=0;         %counter for CHs
flag_first_dead=0;  %flag_first_dead
flag_50_dead=0;  %flag_50_dead
flag_90_dead=0;  %flag_90_dead
flag_all_dead=0;  %flag_100_dead
deadNum=0;          %Number of dead nodes

initEnergy=0;       %Initial Energy
for i=1:n
      initEnergy=Sensors(i).E+initEnergy;
end

SRP=zeros(1,Model.rmax);    %number of sent routing packets
RRP=zeros(1,Model.rmax);    %number of receive routing packets
SDP=zeros(1,Model.rmax);    %number of sent data packets 
RDP=zeros(1,Model.rmax);    %number of receive data packets 

Sum_DEAD=zeros(1,Model.rmax);
CLUSTERHS=zeros(1,Model.rmax);
AllSensorEnergy=zeros(1,Model.rmax);

%%%%%%%%%%%%%%%%%%%%%%%% Start Simulation %%%%%%%%%%%%%%%%%%%%%%%%%
srp=0;          %counter number of sent routing packets
rrp=0;          %counter number of receive routing packets
sdp=0;          %counter number of sent data packets 
rdp=0;          %counter number of receive data packets 

%Calculate Initial energy
TotalEnergy(1) = initEnergy;

% All sensor send location information to Sink .
[Sensors,minToSink,maxToSink]=disToSink(Sensors,Model);

%Save metrics
SRP(1)=srp;
RRP(1)=rrp;  
SDP(1)=sdp;
RDP(1)=rdp;

pause(0.001)    %pause simulation
hold off;       %clear figure

 %Plot sensors
% ploter(Sensors,Model);       
% Main loop program
for r=1:1:Model.rmax

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%
    %This section Operate for each epoch   
    member=[];              %Member of each cluster in per period
    countCHs=0;             %Number of CH in per period
    %counter for bit transmitted to Bases Station and Cluster Heads
    srp=0;          %counter number of sent routing packets
    rrp=0;          %counter number of receive routing packets
    sdp=0;          %counter number of sent     data packets to sink
    rdp=0;          %counter number of receive data packets by sink
    %initialization per round
    SRP(r+1)=srp;
    RRP(r+1)=rrp;  
    SDP(r+1)=sdp;
    RDP(r+1)=rdp;   
    pause(0.0001)    %pause simulation
    hold off;       %clear figure
    currentDeadNum = deadNum; 
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%% plot sensors %%%%%%%%%%%%%%%%%%%%%%%
    %  deadNum=ploter(Sensors,Model);
    
    %Save r'th period When the first node dies
    if (deadNum>=1)
        if(flag_first_dead==0)
            dead_round(1)=r;
            first_dead=r;
            flag_first_dead=1;
            pause(0.0001);
        end
    end
    if(deadNum>=50)    
        if(flag_50_dead==0)
            dead_round(2)=r;
            flag_50_dead=1;
        end  
    end
    if(deadNum>=90)    
        if(flag_90_dead==0)
            dead_round(3)=r;
            flag_90_dead=1;
        end  
    end
    % Select initial cluster head
[Sensors,AlphaWolf,BetaWolf,DeltaWolf] = InitialClustersFitness(Sensors, Model, minToSink, maxToSink);
           
% Initialize GWO parameters
[Positions,Alpha_pos,Beta_pos,Delta_pos,Prey_pos] =  InitialGWO(Sensors,AlphaWolf,BetaWolf,DeltaWolf,n,ub,lb);
[TotalCH,Sensors] = FormCluster(Sensors,Model,CH_idx)
% [TotalCH,Sensors]=SelectCH(Sensors,Model,CH_idx);
%             [Sensors]=JoinToNearestCH(Sensors,Model,TotalCH);
%             [TotalCH,Sensors]=ReSelectCH(Sensors,Model);
%             [Sensors]=JoinToNearestCH(Sensors,Model,TotalCH);
% ploter(Sensors,Model);
[Model, d_tch, d_tbs] = CalculateOptimalSet(Model, Sensors);
[Model,Sensors,minF2,Alpha_pos,Beta_pos,Delta_pos,Prey_pos,TotalCH]=GWO(n,Max_iter,lb,ub,Sensors,Model,TotalCH);

% ploter(Sensors,Model);                  %Plot sensorss
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% steady-state phase %%%%%%%%%%%%%%%%%
[Sensors] = EnergyCalculate(Sensors, Model, n);

    if(deadNum > currentDeadNum)
        Model.F3 = 0;
        
    end
    
TotalEnergy(r+1) = 0;
for i=1:Model.n
TotalEnergy(r+1) = TotalEnergy(r+1) + Sensors(i).E;   
end
%% STATISTICS
     
    Sum_DEAD(r+1)=deadNum;
    
    SRP(r+1)=srp;
    RRP(r+1)=rrp;  
    SDP(r+1)=sdp;
    RDP(r+1)=rdp;
    
    CLUSTERHS(r+1)=countCHs;
    
    alive=0;
    SensorEnergy=0;
    for i=1:n
        if Sensors(i).E>0
            alive=alive+1;
            SensorEnergy=SensorEnergy+Sensors(i).E;
        end
    end
    AliveSensors(r)=alive; %#ok
    
    SumEnergyAllSensor(r+1)=SensorEnergy; %#ok
    
    AvgEnergyAllSensor(r+1)=SensorEnergy/alive; %#ok
    
    ConsumEnergy(r+1)=(initEnergy-SumEnergyAllSensor(r+1))/n; %#ok
    
    En=0;
    deadNum = 0;
    for i=1:n
        if Sensors(i).E>0
            En=En+(Sensors(i).E-AvgEnergyAllSensor(r+1))^2;
        else 
            deadNum=deadNum+1;
        end
    end
    
    Enheraf(r+1)=En/alive; %#ok
    
    % title(sprintf('Round=%d,Dead nodes=%d', r+1, deadNum)) 
%    plot(AliveSensors); 
    %plot(TotalEnergy); 
%    title(sprintf('Alive nodes'))
   pause(0.00001);
   %dead
   if(n==deadNum)
        dead_round(4)=r;
       lastPeriod=r;  
       break;
       
   end
 
end % for r=0:1:rmax
%bar(dead_round);
save('GWOdeadround.mat','dead_round');
disp('End of Simulation');
toc;
disp('Create Report...');
close all;
plot(TotalEnergy);
saveas(gcf,'GWOenergy.fig');
close all;
plot(AliveSensors); 
saveas(gcf,'GWO_Alivenodes.fig');
