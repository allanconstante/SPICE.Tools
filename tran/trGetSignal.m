function [t,ft,value] = trGetSignal(spice, signal, sweep)

%   =======================================================================
%   Esta função permite a captura do vetor de um  respectivo sinal elétrico
%   e seu vetor tempo dentro da struct proveniente da função trData.
%
%   A função tem dois formatos para os argumentos de entrada:
%
%       1 - [t,ft,value] = trGetSignal(spice, signal, sweep);
%       2 - [t,ft] = trGetSignal(spice, signal);
%
%   =======================================================================
%
%   Entradas
%   -----------------------------------------------------------------------
%   spice:  struct, saida da função trData;
%   signal: nome do sinal;
%   sweep:  posição na varredura;
%
%   Sem o argumento sweep  a função pega  o sinal elétrico correspondente a 
%   varredura 1.
%
%   
%   Saidas
%   -----------------------------------------------------------------------
%   t:      vetor tempo;
%   ft:     vetor do respectivo sinal elétrico;
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
        
        t = spice.vectors{1,1}.t;
        ft = spice.vectors{1,1}{:,s};
    end
    
    if nargout == 3
        
        value = spice.values(sweep,1);
    end
end