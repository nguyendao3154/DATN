function [Sensors,minToSink,maxToSink]=disToSink(Sensors,Model)
%% Developed by Amin Nazari 
% 	aminnazari91@gmail.com 
%	0918 546 2272
    n=Model.n;
    for i=1:n
        
        distance_ToSink=sqrt((Sensors(i).xd-Sensors(n+1).xd)^2 + ...
            (Sensors(i).yd-Sensors(n+1).yd)^2 );
        
            if i == 1
                minToSink = 1;
            else

                if distance_ToSink < Sensors(minToSink).dis2sink
                    minToSink = i;
                end

            end

            if i == 1
                maxToSink = 1;
            else

                if distance_ToSink > Sensors(maxToSink).dis2sink
                    maxToSink = i;
                end

            end


        Sensors(i).dis2sink=distance_ToSink;
        
    end
    
end