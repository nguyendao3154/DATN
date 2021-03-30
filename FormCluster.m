%  Developed by: Nguyen Dao  -   DHBKHN

function [CH,Sensors] = FormCluster(Sensors,Model,CH_idx)
    CH=[];
    CH1=[];
    CH2=[];
    countCHs1=0;
    countCHs=0;
    countTempCHs=0;
    n=Model.n;
    k = 1;

    % while (countCHs < Model.NumOfClusters && k < Model.n)
    %     CH1(countCHs+1).id = CH_idx(k);
        
        for i =1:10
            CH1(i).id = CH_idx(i);
        end
        m=length(CH1);
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
                    D(j,i)=sqrt((Sensors(i).xd-Sensors(CH1(j).id).xd)^2+ ...
                        (Sensors(i).yd-Sensors(CH1(j).id).yd)^2);        
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
                            Sensors(i).MCH=CH1(1).id;
                            Sensors(i).dis2ch=Dmin(i);
                        else
                            Sensors(i).MCH=CH1(idx(i)).id;
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
            countTempCHs = 0;
            for i = 1:n 
                if (Sensors(i).E < 0 || Sensors(i).E == 0)
                    Sensors(i).type = 'D';
                else
                    if(Sensors(i).countMem > 3)
                    Sensors(i).type = 'C';
                    countTempCHs=countTempCHs+1;
                    CH2(countTempCHs).id=i; %#ok     
                    else 
                    Sensors(i).type = 'N';
                    end
                end
            end
        end
        m=length(CH2);
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
                    D(j,i)=sqrt((Sensors(i).xd-Sensors(CH2(j).id).xd)^2+ ...
                        (Sensors(i).yd-Sensors(CH2(j).id).yd)^2);        
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
                            Sensors(i).MCH=CH2(1).id;
                            Sensors(i).dis2ch=Dmin(i);
                        else
                            Sensors(i).MCH=CH2(idx(i)).id;
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
            countCHs = 0;
            for i = 1:n 
                if (Sensors(i).E < 0 || Sensors(i).E == 0)
                    Sensors(i).type = 'D';
                else
                    if(Sensors(i).countMem > 3)
                    Sensors(i).type = 'C';
                    countCHs=countCHs+1;
                    CH(countCHs).id=i; %#ok
                    else 
                    Sensors(i).type = 'N';
                    end
                end
            end
        end
    %     k = k+1;
    % end