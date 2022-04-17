function [ymin, ymax] = getLimits(yold,ynew)

    ymin = yold(1,1);
    ymax = yold(1,2);
    
    if (yold(1,1) > ynew(1,1))
        ymin = ynew(1,1);
    end
    if (yold(1,2) < ynew(1,2))
        ymax = ynew(1,2);
    end

end

