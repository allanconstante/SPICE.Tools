function [t,ft,value] = trGetSignal(spice, signal, sweep)

    tam = size(spice.signals);
    for i=1:tam(1,1)
        
        str = spice.signals(i,1);
        if strcmp(signal, str)
            
            s = (i + 1);
            break;
        end
    end
    
    if nargin == 3
        
        t = spice.vectors{sweep,1}.t;
        ft = spice.vectors{sweep,1}{:,s};
    elseif nargin == 2
        
        t = spice.vectors{1,1}.t;
        ft = spice.vectors{1,1}{:,s};
    end
    
    if nargout == 3
        
        value = spice.values(sweep,1);
    end
end