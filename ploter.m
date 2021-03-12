function deadNum=ploter(Sensors,Model)
    %% Developed by Amin Nazari 
% 	aminnazari91@gmail.com 
%	0918 546 2272
    deadNum=0;
    n=Model.n;
    for i=1:n
        %check dead node
        if (Sensors(i).E>0)
            
            if(Sensors(i).type=='N' )      
                plot(Sensors(i).xd,Sensors(i).yd,'blue .','MarkerSize',10);     
            else %Sensors.type=='C'       
                plot(Sensors(i).xd,Sensors(i).yd,'blue x','MarkerSize',10);
            end
            
        else
            deadNum=deadNum+1;
            plot(Sensors(i).xd,Sensors(i).yd,'red .');
        end
        
        hold on;
        
    end 
    plot(Sensors(n+1).xd,Sensors(n+1).yd,'green *','MarkerSize',15); 
    axis square

    %%%%%%%%%%%%%%%%%%%%%%% plot network status in end of set-up phase 

    for i=1:n
        
        if (Sensors(i).type=='N' && Sensors(i).E>0)
            % Sensors(i).dis2ch<Sensors(i).dis2sink && ...
            % Sensors(i).E>0)
            
            XL=[Sensors(i).xd ,Sensors(Sensors(i).MCH).xd];
            YL=[Sensors(i).yd ,Sensors(Sensors(i).MCH).yd];
            % hold on
            line(XL,YL)
        
        end
        % if (Sensors(i).type=='N' && ...
        %     Sensors(i).dis2ch>Sensors(i).dis2sink && ...
        %     Sensors(i).E>0)   
        
        %     XA=[Sensors(i).xd ,Sensors(n+1).xd];
        %     YA=[Sensors(i).yd ,Sensors(n+1).yd];
        %     % hold on
        %     line(XA,YA)

        % end

        XB=[Sensors(n+1).xd ,Sensors(Sensors(i).MCH).xd];
        YB=[Sensors(n+1).yd ,Sensors(Sensors(i).MCH).yd];
        % hold on
        line(XB,YB)

    end

end