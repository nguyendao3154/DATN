% Grey Wolf Optimizer
% Developed by Nguyen Dao - DHBKHN
function [Model,Sensors,minF2,Alpha_pos,Beta_pos,Delta_pos,Prey_pos,TotalCH]=GWO(n,Max_iter,lb,ub,Sensors,Model,TotalCH)
    
    global Alpha_pos Alpha_score Beta_pos Beta_score Delta_pos Delta_score a r CH_idx Prey_pos;
    % Main loop
    for i = 1:(n+1)
        Wolf(i).xd = Sensors(i).xd;
        Wolf(i).yd = Sensors(i).yd;
        Wolf(i).E = Sensors(i).E;
        Wolf(i).F2 = inf;
        C(i) = inf;
    end
    a = 2;
    for iter_gwo = 1:Max_iter % t < Max number of iterations

        %Update position of alpha, beta and delta wolf
        for j = 1 : 2 % x and y coordinate
            r1=rand(); % r1 is a random number in [0,1]
            r2=rand(); % r2 is a random number in [0,1]

            A1(j)=2*a*r1-a; % Equation 2
            C1=2*r2; % Equation 4

            D_alpha(j)=abs(C1*Prey_pos(j)-Alpha_pos(j)); % Equation 3
            Alpha_pos(j)=Prey_pos(j)-A1(j)*D_alpha(j); % Equation 1

            if(Alpha_pos(j)>ub)
                Alpha_pos(j)=ub;
                D_alpha(j)=abs(C1*Prey_pos(j)-Alpha_pos(j)); % Equation 3
                A1(j) = (Prey_pos(j) - Alpha_pos(j))/D_alpha(j);  
            end
            if(Alpha_pos(j)<lb)
                Alpha_pos(j)=lb;
                D_alpha(j)=abs(C1*Prey_pos(j)-Alpha_pos(j)); % Equation 3
                A1(j) = (Prey_pos(j) - Alpha_pos(j))/D_alpha(j); 
            end

            r1=rand();
            r2=rand();

            A2(j)=2*a*r1-a; % Equation 2
            C2=2*r2; % Equation 4

            D_beta(j)=abs(C2*Prey_pos(j)-Beta_pos(j)); % Equation 3
            Beta_pos(j)=Prey_pos(j)-A2(j)*D_beta(j); % Equation 1
            
            if(Beta_pos(j)>ub)
                Beta_pos(j)=ub;
                D_beta(j)=abs(C2*Prey_pos(j)-Beta_pos(j)); % Equation 3
                A1(j) = (Prey_pos(j) - Beta_pos(j))/D_beta(j);  
            end
            if(Beta_pos(j)<lb)
                Beta_pos(j)=lb;
                D_beta(j)=abs(C2*Prey_pos(j)-Beta_pos(j)); % Equation 3
                A1(j) = (Prey_pos(j) - Beta_pos(j))/D_beta(j); 
            end

            r1=rand();
            r2=rand();
            
            A3(j)=2*a*r1-a; % Equation 2
            C3=2*r2; % Equation 4
            
            D_delta(j)=abs(C3*Prey_pos(j)-Delta_pos(j)); % Equation 3
            Delta_pos(j)=Prey_pos(j)-A3(j)*D_delta(j); % Equation 1

            if(Delta_pos(j)>ub)
                Delta_pos(j)=ub;
                D_delta(j)=abs(C3*Prey_pos(j)-Delta_pos(j)); % Equation 3
                A3(j) = (Prey_pos(j) - Delta_pos(j))/D_delta(j);  
            end
            if(Delta_pos(j)<lb)
                Delta_pos(j)=lb;
                D_delta(j)=abs(C3*Prey_pos(j)-Delta_pos(j)); % Equation 3
                A3(j) = (Prey_pos(j) - Delta_pos(j))/D_delta(j); 
            end

            % Calculate weight
            Alpha_weight(j) = (D_alpha(j)*A1)/(D_alpha(j)*A1 + D_beta(j)*A2 + D_delta(j)*A3);
            Beta_weight(j) = (D_beta(j)*A2)/(D_alpha(j)*A1 + D_beta(j)*A2 + D_delta(j)*A3);
            Delta_weight(j) = (D_delta(j)*A3)/(D_alpha(j)*A1 + D_beta(j)*A2 + D_delta(j)*A3);

            % Calculate the position of prey
            Prey_pos(j) = (Alpha_weight(j)*Alpha_pos(j))+(Beta_weight(j)*Beta_pos(j))+(Delta_weight(j)*Delta_pos(j)) ; % Equation 5
        end   
        update_dis = true; 
        update_energy = true;
        update_min_F2 = true;
        % Calculate fitness F2 of search agents including omegas
        for i=1 : n % For each grey wolf

            % Calculate distance to prey
            Wolf(i).dis2prey=sqrt((Wolf(i).xd-Prey_pos(1))^2 +(Wolf(i).yd-Prey_pos(2))^2 );

            
            if (Wolf(i).E > 0)
                if(update_dis == true)
                    minToPrey = i;
                    maxToPrey = i;
                    update_dis = false;
                end
                if Wolf(i).dis2prey < Wolf(minToPrey).dis2prey
                    minToPrey = i;
                end
                if Wolf(i).dis2prey > Wolf(maxToPrey).dis2prey
                    maxToPrey = i;
                end
            end         

            % Calcualte maximum and minimum residual engergy
            
            if (Wolf(i).E > 0)
                if(update_energy == true)
                    minEnergy = i;
                    maxEnergy = i;
                    update_energy = false;
                end
                if Wolf(i).E < Wolf(minEnergy).E
                    minEnergy = i;
                end   
                if Wolf(i).E > Wolf(maxEnergy).E
                    maxEnergy = i;
                end

            end
        end

        for i = 1:n
            % Calculate fitness F2
            if (Wolf(i).E > 0)
                % Wolf(i).F2 = Model.a2*(Model.Eo-Wolf(i).E)/(Wolf(maxEnergy).E - Wolf(minEnergy).E) + ...
                Wolf(i).F2 =(1-Model.a2)*(Wolf(i).dis2prey-Wolf(minToPrey).dis2prey)/(Wolf(maxToPrey).dis2prey-Wolf(minToPrey).dis2prey);

                % Get the smallest F2
                if(update_min_F2 == true)
                    minF2 = i;
                    update_min_F2 = false;
                end

                if Wolf(i).F2 < Wolf(minF2).F2
                    minF2 = i;
                end
                C(i) = Wolf(i).F2;
            end
        end

        [B, CH_idx] = mink(C,10);

        [TempCH,Wolf]=SelectCH(Wolf,Model,CH_idx);
        [Wolf]=JoinToNearestCH(Wolf,Model,TempCH);
        [TempCH,Wolf]=ReSelectCH(Wolf,Model);
        [Wolf]=JoinToNearestCH(Wolf,Model,TempCH);
        
        [Model, d_tch, d_tbs, update_cluster_flag] = CalculateOptimalSet(Model, Wolf);

       if(update_cluster_flag == true)
            [TotalCH,Sensors]=SelectCH(Sensors,Model,CH_idx);
            [Sensors]=JoinToNearestCH(Sensors,Model,TotalCH);
            [TotalCH,Sensors]=ReSelectCH(Sensors,Model);
            [Sensors]=JoinToNearestCH(Sensors,Model,TotalCH);
            update_cluster_flag = false;
       end

        a=2-r*((2)/Max_iter); % a decreases linearly fron 2 to 0
        % All sensor send location information to Prey .

    end
end
    