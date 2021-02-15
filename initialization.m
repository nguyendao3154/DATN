%Developed by Nguyen Dao - DHBKHN
% This function initialize the first population of search agents
function Positions=initialization(SearchAgents_no,dim,ub,lb,Sensors)

    Boundary_no= size(ub,2); % numnber of boundaries
    
    % If the boundaries of all variables are equal and user enter a signle
    % number for both ub and lb
    if Boundary_no==1
        for i = 1:SearchAgents_no
            Positions(i,1)=Sensors(i).xd;
            Positions(i,2)=Sensors(i).yd;
        end
    end
    
    % If each variable has a different lb and ub
    if Boundary_no>1
        for i=1:SearchAgents_no
            ub_i=ub(i);
            lb_i=lb(i);
            Positions(i,1)=Sensors(i).xd;
            Positions(i,2)=Sensors(i).yd;
        end
    end