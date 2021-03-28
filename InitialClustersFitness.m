% Developed by Nguyen Dao - DHBKHN
% Find intital Alpha, Beta, Delta

function [Sensors, AlphaWolf, BetaWolf, DeltaWolf] = InitialClustersFitness(Sensors, Model, minToSink, maxToSink)
    global CH_idx;
    udpate_F1 = true;
    for i=1:Model.n 
        Sensors(i).F1 = 0;
    end

for i=1:Model.n 
    %Formula 12
    if(Sensors(i).E > 0)
        Sensors(i).F1 = Model.a1*Sensors(i).E/Model.Eo + ...
        (1-Model.a1)*((Sensors(maxToSink).dis2sink-Sensors(i).dis2sink)/ ...
        (Sensors(maxToSink).dis2sink-Sensors(minToSink).dis2sink));
    else
        Sensors(i).F1 = 0;
    end
    
    if(udpate_F1 == true)
        AlphaWolf = i;
        BetaWolf = i
        DeltaWolf = i
        udpate_F1 = false;
    end 

        if (Sensors(i).F1 > Sensors(AlphaWolf).F1)
            AlphaWolf = i;
        end

        if (Sensors(i).F1 < Sensors(AlphaWolf).F1 && Sensors(i).F1 > Sensors(BetaWolf).F1)
            BetaWolf = i;
        end

        if (Sensors(i).F1 < Sensors(BetaWolf).F1 && Sensors(i).F1 > Sensors(DeltaWolf).F1)
            DeltaWolf = i;
        end

    C(i) = Sensors(i).F1;
end
[B, CH_idx] = maxk(C,10);
