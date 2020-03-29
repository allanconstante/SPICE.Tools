function [i] = SEU(Q, tauA, tauB, t)
    %% Equação.

    i = (Q/(tauA-tauB))*(exp(-t/tauA)-exp(-t/tauB));

    %%  Referencias.

    %[1]    G. Saxena, R. Agrawal, and H. Sharma, “Single Event Upset (SEU) 
    %       in SRAM,” Citeseer, vol. 3, no. 4, pp. 2171–2175, 2013.
    %
    %[2]    F. Wang and V. D. Agrawal, “Single event upset: An embedded 
    %       tutorial,” Proc. IEEE Int. Freq. Control Symp. Expo., pp. 429–434, 
    %       2008, doi: 10.1109/VLSI.2008.28.
end

