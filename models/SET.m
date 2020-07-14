function [i] = SET(Q, tauA, tauB, t)
    %% Equação.

    i = (Q/(tauA-tauB))*(exp(-t/tauA)-exp(-t/tauB));

end

