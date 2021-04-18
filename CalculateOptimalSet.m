function [Model, d_tch, d_tbs, update_cluster_flag] = CalculateOptimalSet(Model, Node)
    d_tch = 0;
    d_tbs = 0;
    d_total = 0;
    e_ch = 0;
    e_total = 0;
    update_cluster_flag = false;
    for i=1:Model.n
        
        if (Node(i).type=='N' && Node(i).E>0)
            d_tch = d_tch + sqrt(((Node(i).xd) - Node(Node(i).MCH).xd)^2 +((Node(i).yd) - Node(Node(i).MCH).yd)^2);
            d_total = d_total + sqrt((Node(i).xd-Node(Model.n+1).xd)^2 + ...
            (Node(i).yd-Node(Model.n+1).yd)^2 );
            e_total = e_total + 1/Node(i).E;
        end

        if (Node(i).type=='C' && Node(i).E>0)
            d_tbs = d_tbs + sqrt((Node(i).xd-Node(Model.n+1).xd)^2 + ...
            (Node(i).yd-Node(Model.n+1).yd)^2 );
            d_total = d_total + sqrt((Node(i).xd-Node(Model.n+1).xd)^2 + ...
            (Node(i).yd-Node(Model.n+1).yd)^2 );
            e_ch = e_ch + 1/Node(i).E;
            e_total = e_total + 1/Node(i).E;
        end

    end

    if (Model.F3 == 0)
        % Model.F3 = Model.a3*d_tch + (1-Model.a3)*d_tbs;
        Model.F3 = Model.a3*(d_tch + d_tbs)/d_total + (1-Model.a3)*e_ch/e_total; 
        update_cluster_flag = true;
    else
        % if (Model.F3 > (Model.a3*d_tch + (1-Model.a3)*d_tbs))
        if(Model.F3 > Model.a3*(d_tch + d_tbs)/d_total + (1-Model.a3)*e_ch/e_total)
            % Model.F3 = Model.a3*d_tch + (1-Model.a3)*d_tbs;
            Model.F3 = Model.a3*(d_tch + d_tbs)/d_total + (1-Model.a3)*e_ch/e_total;
            update_cluster_flag = true;
        end
    end
