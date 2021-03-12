% Developed by Nguyen Dao - DHBKHN
% Find intital Alpha, Beta, Delta

function [Sensors, AlphaWolf, BetaWolf, DeltaWolf] = InitialClustersFitness(Sensors, Model, minToSink, maxToSink)

for i=1:Model.n 
    %Formula 12
    if(Sensors(i).E > 0)
        Sensors(i).F1 = Model.a1*Sensors(i).E/Model.Eo + ...
        (1-Model.a1)*((Sensors(maxToSink).dis2sink-Sensors(i).dis2sink)/ ...
        (Sensors(maxToSink).dis2sink-Sensors(minToSink).dis2sink));
    else
        Sensors(i).F1 = 0;
    end
    
    if (i == 1)
        AlphaWolf = 1;
        BetaWolf = 1;
        DeltaWolf = 1;
    else

        if (Sensors(i).F1 > Sensors(AlphaWolf).F1)
            AlphaWolf = i;
        end

        if (Sensors(i).F1 < Sensors(AlphaWolf).F1 && Sensors(i).F1 > Sensors(BetaWolf).F1)
            BetaWolf = i;
        end

        if (Sensors(i).F1 < Sensors(BetaWolf).F1 && Sensors(i).F1 > Sensors(DeltaWolf).F1)
            DeltaWolf = i;
        end

    end

end
