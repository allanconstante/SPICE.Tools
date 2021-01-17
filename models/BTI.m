function [dV] = BTI(model, inputs, tech, t, dVth0)
    %%  Variaveis de entrada.
    %
    %   - alfa:     Duty cycle;
    %   - Tclk:     Periodo de ciclo;
    %   - n:        Perfil de difusão, 1/6 para H2 ou 1/4 para H;
    %   - Te:       Temperatura de operação em Graus Celsius (°C)

    Te = inputs(1);
    alfa = inputs(2);
    Tclk = inputs(3);
    n = inputs(4);

    %%  Parâmetros provenientes da Tecnlogia utilizada.
    %
    %   - Vdd:      Tensão de alimentação (V);
    %   - Vth:      Tensão de treshold (V);
    %   - tox:      Espessura do dióxido (nm) - Fisica(toxp);
    %   - EPSROX:   Constante dielétrica relativa do isolador da porta (SIO2);

    Vdd = tech(1);
    Vth = tech(2);
    tox = tech(3);
    EPSROX = tech(4);

    %%  Constantes.
    %
    %   Ea:     Ref.[1];
    %   E0:     Ref.[1];
    %   K:      Ref.[1];
    %   qsi1:   Ref.[1];
    %   qsi2:   Ref.[1];
    %   T0:     Ref.[1];
    %   k:      Constante de Boltzmann em (eV/K);
    %   e0:     Permissividade do vácuo (F/nm)
    %   q:      Carga do elétron.

    Ea = 0.49;
    E0 = 0.335;
    K = 8e4;
    qsi1 = 0.9;
    qsi2 = 0.5;
    T0 = 1e-8;
    k = 8.617333262145e-5;
    e0 = 8.854187817e-21;
    q = 1.60217662e-19;

    %%  Equações.
    
    switch nargin
        case 4
            dVth0 = 0;
    end
    
    Vgs = Vdd;
    te = tox;
    Eox = (Vgs-Vth)/tox;
    eox = EPSROX*e0;
    Cox = eox/tox;
    T = Te+273.15;
    C = exp(-Ea/(k*T))/T0;

    Kv = ((q*tox/eox)^3)*(K^2)*Cox*(Vgs-Vth)*sqrt(C)*exp((2*Eox)/E0);
    
    if strcmp('LongTerm', model)
        
        beta = 1-(((2*qsi1*te)+sqrt(qsi2*C*(1-alfa)*Tclk))./((2*tox)...
            +sqrt(C.*t)));
        dV = (sqrt((Kv^2)*alfa*Tclk)./(1-(beta.^(1/(2*n))))).^(2*n);
    
    elseif strcmp('Static', model)
        
        
        
    elseif strcmp('Dynamic', model)
        
        est = 0;
        Tst = (Tclk*alfa) + t(1,1);
        Trv = Tclk + t(1,1);
        t0 = t(1,1);
        tam = size(t);
        dV = zeros(1, tam(1,2));
        for i = 1:tam(1,2)
            
            if t(1,i) < Tst

                dV(1,i) = (Kv*(t(1,i)-t0)^(1/2) + nthroot(dVth0, 2*n))^...
                    (2*n);
                
            elseif t(1,i) <= Trv
                
                if est==0
                    
                    t0 = t(1,(i - 1));
                    dVth0 = dV(1,(i - 1));
                    est = 1;
                    
                end
                dV(1,i) = dVth0*(1 - ((2*qsi1*te + sqrt(qsi2*C*(t(1,i)...
                    -t0)))/((2*tox)+sqrt(C*t(1,i)))));
            
            else
                
                est = 0;
                t0 = t(1,(i - 1));
                dVth0 = dV(1,(i - 1));
                
                Tst = Tst + Tclk;
                Trv = Trv + Tclk;
                
                dV(1,i) = (Kv*(t(1,i)-t0)^(1/2) + nthroot(dVth0, 2*n))^(2*n);
                
            end
        end
    end
    
    %%  Referencias.
    
    %[1]    S. Bhardwaj, W. Wang, R. Vattikonda, Y. Cao, and S. Vrudhula, 
    %       “Predictive modeling of the NBTI effect for reliable design,” 
    %       Proc. Cust. Integr. Circuits Conf., no. Cicc, pp. 189–192, 2006, 
    %       doi: 10.1109/CICC.2006.320885.
end