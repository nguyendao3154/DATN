% Created by Nguyen Dao - DHBKHN

function [Sensors] = EnergyCalculate(Sensors, Model, n)
    global srp rrp sdp rdp 
    sap=0;      % Send a packet
    rap=0;      % Receive a packet

for i = 1:n
    if (Sensors(i).type == 'N')
        if (Sensors(i).dis2ch > Model.do)

            Sensors(i).E = Sensors(i).E- ...
                (Model.ETX*Model.DpacketLen + Model.Emp*Model.DpacketLen*(Sensors(i).dis2ch^4));

            % Sent a packet
            if(Sensors(i).E>0)
                sap=sap+1;                 
            end

        else

            Sensors(i).E=Sensors(i).E- ...
                (Model.ETX*Model.DpacketLen + Model.Efs*Model.DpacketLen*(Sensors(i).dis2ch^2));

            % Sent a packet
            if(Sensors(i).E>0)
                sap=sap+1;                 
            end

        end
    end

    if (Sensors(i).type == 'C')
        if (Sensors(i).dis2sink > Model.do)

            Sensors(i).E = Sensors(i).E- ...
                (Model.ETX*Model.DpacketLen + Model.Emp*Model.DpacketLen*(Sensors(i).dis2sink^4));

            % Sent a packet
            if(Sensors(i).E>0)
                sap=sap+1;                 
            end

        else

            Sensors(i).E=Sensors(i).E- ...
                (Model.ETX*Model.DpacketLen + Model.Efs*Model.DpacketLen*(Sensors(i).dis2sink^2));

            % Sent a packet
            if(Sensors(i).E>0)
                sap=sap+1;                 
            end

        end

        Sensors(i).E = Sensors(i).E - (Model.ERX + Model.EDA)*Model.DpacketLen;

        if(Sensors(i).E > 0)
            rap=rap+1;
        end
    end

end

srp=srp+sap;
rrp=rrp+rap;
