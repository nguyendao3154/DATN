function [Sensors,minToSink,maxToSink]=disToSink(Sensors,Model)
%% Developed by Amin Nazari 
% 	aminnazari91@gmail.com 
%	0918 546 2272
    n=Model.n;
    update_dis = true;
    for i=1:n
        distance_ToSink=sqrt((Sensors(i).xd-Sensors(n+1).xd)^2 + ...
            (Sensors(i).yd-Sensors(n+1).yd)^2 );
            Sensors(i).dis2sink=distance_ToSink;
    end

    for i=1:n
            if(update_dis == true)
                minToSink = i;
                maxToSink = i;
                update_dis = false;
            end

                if Sensors(i).dis2sink < Sensors(minToSink).dis2sink
                    minToSink = i;
                end

            end

            if Sensors(i).dis2sink > Sensors(maxToSink).dis2sink
                maxToSink = i;
            end

        
        
    end
    