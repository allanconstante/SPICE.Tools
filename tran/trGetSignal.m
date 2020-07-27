function [t,ft,value] = trGetSignal(spice, signal, sweep)

%
%   Esta função permite a captura do vetor sinal e seu vetor tempo dentro
%   da struct de um arquivo ".trX".
%
%   Permite dois modos de argumentos de entrada:
%
%       1 - [t,ft,value] = trGetSignal(spice, signal, sweep);
%       2 - [t,ft] = trGetSignal(spice, signal);
%
%       spice:  struct do sinal '.trX';
%       signal: nome do sinal;
%       sweep:  posição da varredura (sweep);
%
%       Sem o argumento sweep a função pega o sinal de posição 1 da celula
%       vectors. Do mesmo modo a variavel value é suprimida no retorno da
%       função pois equivale ao valor numerico da variavel no respectivo
%       sweep.
%
%   Como variaveis de saidas temos:
%
%       t:      vetor função tempo;
%       ft:     vetor com os valores numericos do sinal;
%       value:  valor numerico da variavel no respectivo sweep.
%
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