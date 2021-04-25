function [Area,Model]=setParameters(n)
%% Developed by Amin Nazari 
% 	aminnazari91@gmail.com 
%	0918 546 2272
% Developed by Nguyen Dao - DHBKHN
global Max_iter
%%%%%%%%%%%%%%%%%%%%%%%%% Set Inital PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%
%Field Dimensions - x and y maximum (in meters)
Area.x=n;
Area.y=n;

%Sink Motion pattern 
Sinkx=0.5*Area.x;
Sinky=Sinkx;

%Optimal Election Probability of a node to become cluster head
p=0.1;

%%%%%%%%%%%%%%%%%%%%%%%%% Energy Model (all values in Joules)%%%%%%%%%%%
%Initial Energy 
Eo=0.05;

%Eelec=Etx=Erx
ETX=50*0.000000001;
ERX=50*0.000000001;

%Transmit Amplifier types
Efs=10*0.000000000001;
Emp=0.0013*0.000000000001;

%Data Aggregation Energy
EDA=5*0.000000001;

%Computation of do
do=sqrt(Efs/Emp);

%%%%%%%%%%%%%%%%%%%%%%%%% Run Time Parameters %%%%%%%%%%%%%%%%%%%%%%%%%
%maximum number of rounds
rmax=250;

%Data packet size
DpacketLen=4000;

%Hello packet size
HpacketLen=100;

%Number of Packets sended in steady-state phase
NumPacket=10;

%Redio Range
RR=0.5*Area.x*sqrt(2);

%Number of clusters
NumOfClusters = 10;

%Weight
a1 = 0.5;
a2 = 0.5;
a3 = 0.5;
%%%%%%%%%%%%%%%%%%%%%%%%% END OF PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%% Save in Model %%%%%%%%%%%%%%%%%%%%%%%%%%%%
Model.n=n;
Model.Sinkx=Sinkx;
Model.Sinky=Sinky;
Model.p=p;
Model.Eo=Eo;
Model.ETX=ETX;
Model.ERX=ERX;
Model.Efs=Efs;
Model.Emp=Emp;
Model.EDA=EDA;
Model.do=do;
Model.rmax=rmax;
Model.DpacketLen=DpacketLen;
Model.HpacketLen=HpacketLen;
Model.NumPacket=NumPacket;
Model.RR=RR;
Model.a1=a1;
Model.a2=a2;
Model.a3=a3;
Model.F3=0;
Model.NumOfClusters=NumOfClusters; 
end