% Grey Wolf Optimizer
% Developed by Nguyen Dao - DHBKHN
function [Convergence_curve,Sensors,minF2]=GWO(n,Max_iter,lb,ub,Sensors,Model,Prey_pos)
    
    global Alpha_pos Alpha_score Beta_pos Beta_score Delta_pos Delta_score a r idx;
    % Main loop
    a = 2;
    for iter_gwo = 1:1:Max_iter % t < Max number of iterations

        %Update position of alpha, beta and delta wolf
        for j = 1 : 2 % x and y coordinate
            r1=rand(); % r1 is a random number in [0,1]
            r2=rand(); % r2 is a random number in [0,1]

            A1(j)=2*a*r1-a; % Equation 2
            C1=2*r2; % Equation 4

            D_alpha(j)=abs(C1*Prey_pos(j)-Alpha_pos(j)); % Equation 3
            Alpha_pos(j)=Prey_pos(j)-A1(j)*D_alpha(j); % Equation 1

            Flag4ub=Alpha_pos(j)>ub;
            Flag4lb=Alpha_pos(j)<lb;
            Alpha_pos(j)=(Alpha_pos(j).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;

            r1=rand();
            r2=rand();

            A2(j)=2*a*r1-a; % Equation 2
            C2=2*r2; % Equation 4

            D_beta(j)=abs(C2*Prey_pos(j)-Beta_pos(j)); % Equation 3
            Beta_pos(j)=Prey_pos(j)-A2(j)*D_beta(j); % Equation 1
            
            Flag4ub=Beta_pos(j)>ub;
            Flag4lb=Beta_pos(j)<lb;
            Beta_pos(j)=(Beta_pos(j).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;

            r1=rand();
            r2=rand();
            
            A3(j)=2*a*r1-a; % Equation 2
            C3=2*r2; % Equation 4
            
            D_delta(j)=abs(C3*Prey_pos(j)-Delta_pos(j)); % Equation 3
            Delta_pos(j)=Prey_pos(j)-A3(j)*D_delta(j); % Equation 1

            Flag4ub=Delta_pos(j)>ub;
            Flag4lb=Delta_pos(j)<lb;
            Delta_pos(j)=(Delta_pos(j).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;

            % Calculate weight
            Alpha_weight(j) = (D_alpha(j)*A1)/(D_alpha(j)*A1 + D_beta(j)*A2 + D_delta(j)*A3);
            Beta_weight(j) = (D_beta(j)*A2)/(D_alpha(j)*A1 + D_beta(j)*A2 + D_delta(j)*A3);
            Delta_weight(j) = (D_delta(j)*A3)/(D_alpha(j)*A1 + D_beta(j)*A2 + D_delta(j)*A3);

            % Calculate the position of prey
            Prey_pos(j) = (Alpha_weight(j)*Alpha_pos(j))+(Beta_weight(j)*Beta_pos(j))+(Delta_weight(j)*Delta_pos(j)) ; % Equation 5
        end   

        % Calculate fitness F2 of search agents including omegas
        for i=1 : n % For each grey wolf

            % Calculate distance to prey
            Sensors(i).dis2prey=sqrt((Sensors(i).xd-Prey_pos(1))^2 + ...
                (Sensors(i).yd-Prey_pos(2))^2 );

            if i == 1
                minToPrey = 1;
                maxToPrey = 1;
            else

                if Sensors(i).dis2prey < Sensors(minToPrey).dis2prey
                    minToPrey = i;
                end

                if Sensors(i).dis2prey > Sensors(maxToPrey).dis2prey
                    maxToPrey = i;
                end

            end

            % Calcualte maximum and minimum residual engergy
            if i == 1
                minEnergy = 1;
                maxEnergy = 1;
            else

                if Sensors(i).E < Sensors(minEnergy).E
                    minEnergy = i;
                end

                if Sensors(i).E > Sensors(maxEnergy).E
                    maxEnergy = i;
                end

            end

        end

        for i = 1:n
            % Calculate fitness F2
            if (Sensors(i).E > 0)
                Sensors(i).F2 = Model.a2*(Model.Eo-Sensors(i).E)/(Sensors(maxEnergy).E - Sensors(minEnergy).E) + ...
                (1-Model.a2)*(Sensors(i).dis2prey-Sensors(minToPrey).dis2prey)/(Sensors(maxToPrey).dis2prey-Sensors(minToPrey).dis2prey);
            end

            % Get the smallest F2
            if i == 1
                minF2 = 1;
            else

                if Sensors(i).F2 < Sensors(minF2).F2
                    minF2 = i;
                end
            end
            C(i) = Sensors(i).F2;
        end

        [B, idx] = mink(C,10);

        a=2-iter_gwo*((2)/Max_iter); % a decreases linearly fron 2 to 0
        Convergence_curve(iter_gwo)=Alpha_score;
        % All sensor send location information to Prey .

    end
% end
    