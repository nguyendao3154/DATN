%  Developed by: Nguyen Dao  -   DHBKHN

function [CH,Sensors] = FormCluster(Sensors,Model,TotalCH,CH_idx)
    CH=[];
    countCHs=0;
    n=Model.n;
    
    for k = 1:n
        CH(k).id = k;

        m=length(CH);
        if(m>0)
            D=zeros(m,n);  
        
            for i = 1:n 
                Sensors(i).countMem = 1;
                if(Sensors(i).E > 0)
                    Sensors(i).type = 'N';
                else
                    Sensors(i).type = 'D';
                end
            end
        
            for i=1:n     
                for j=1:m
                    % D la khoang cach tu Cluster den cac node
                    D(j,i)=sqrt((Sensors(i).xd-Sensors(CH(j).id).xd)^2+ ...
                        (Sensors(i).yd-Sensors(CH(j).id).yd)^2);        
                end
            end
            
            %% 
            if (m == 1)
                Dmin = D;
            else
                [Dmin,idx]=min(D);
            end
            
            for i=1:n       
                if (Sensors(i).E>0)
                    %if node is in RR CH and is Nearer to CH rather than Sink
                    % if (Dmin(i) <= Model.RR && Dmin(i)<Sensors(i).dis2sink )
                        if (m==1)
                            Sensors(i).MCH=CH(1).id;
                            Sensors(i).dis2ch=Dmin(i);
                        else
                            Sensors(i).MCH=CH(idx(i)).id;
                            Sensors(i).dis2ch=Dmin(i);
                        end
                    % else
                    %     Sensors(i).MCH=n+1;   
                    %     Sensors(i).dis2ch=Sensors(i).dis2sink;
                    % end
                end
            end
        
            for i=1:n 
                for j = 1:n 
                    if (Sensors(i).MCH == j)
                        Sensors(j).countMem = Sensors(j).countMem+1;
                    end
                end
            end
        
            for i = 1:n 
                if (Sensors(i).E < 0 || Sensors(i).E == 0)
                    Sensors(i).type = 'D';
                else
                    if(Sensors(i).countMem > 3)
                    Sensors(i).type = 'C';
            
                    else 
                    Sensors(i).type = 'N';
                    end
                end
            end
        end
    end