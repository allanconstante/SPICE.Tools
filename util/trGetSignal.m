function [t,ft,value] = trGetSignal(spice, signal, sweep)

%   =======================================================================
%   Esta fun��o permite a captura do vetor de um  respectivo sinal el�trico
%   e seu vetor tempo dentro da struct proveniente da fun��o trData.
%
%   A fun��o tem dois formatos para os argumentos de entrada e tr�s para os
%   elementos de saida:
%
%       1 - [...] = trGetSignal(spice, signal, sweep);
%       2 - [...] = trGetSignal(spice, signal);
%       3 - [t,ft,value] = trGetSignal(...);
%       4 - [t,ft] = trGetSignal(...);
%       5 - [ft] = trGetSignal(...);
%
%   =======================================================================
%
%   Entradas --------------------------------------------------------------
%   spice:  struct, saida da fun��o trData;
%   signal: nome do sinal;
%   sweep:  posi��o na varredura;
%
%   Sem o argumento sweep  a fun��o pega  o sinal el�trico correspondente a 
%   varredura 1.
%
%   
%   Saidas ----------------------------------------------------------------
%   t:      vetor tempo;
%   ft:     vetor do respectivo sinal el�trico;
%   value:  valor da variavel na respectiva varredura.
%

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
        
        sweep = 1;
        t = spice.vectors{sweep,1}.t;
        ft = spice.vectors{sweep,1}{:,s};
    end
    
    if nargout == 1
        
        t = ft;
    elseif nargout == 3
        
        value = spice.values(sweep,1);
    end
end