function [graph] = trPlot(spice, signal, sweep)

%   =======================================================================
%   Esta fun��o plota a curva do sinal indicando, no dominio tempo, contido
%   na struct proveniente da fun��o trData.
%
%   A fun��o tem os seguintes formatos:
%
%       1 - [graph] = trPlot(...);
%       2 - trPlot(spice, signal, sweep);
%       3 - trPlot(spice, signal).
%
%   =======================================================================
%
%
%   Entradas --------------------------------------------------------------
%   spice:   struct, sa�da da fun��o trData;
%   signal:  nome do sinal;
%   sweep:   posi��o na varredura.
%
%   Sem o argumento sweep  a fun��o pega  o sinal el�trico correspondente a
%   varredura 1.
%
%
%   Sa�da -----------------------------------------------------------------
%   graph:   objeto para ajustes e modifica��es da tela plot.
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
    
    if nargout == 0
        
        plot(t, ft, 'r--', 'LineWidth', 1);
        title('HSpice Signal');
        xlabel('t(s)');
        ylabel(signal);
        grid on;
    elseif nargout == 1
        
        graph = plot(t, ft);
    end
end