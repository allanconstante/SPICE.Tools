function [data] = trData(name, number)

%   =======================================================================
%   A funçao trData tem por objetivo a extração dos sinais elétricos conti-
%   dos no  arquivo de extensão  ".trX"  proveniente das simulações do tipo
%   transiente no software HSPICE. Permitindo a manipulação dos sinais den-
%   tro do Matlab.
%
%   A função tem dois formatos para os argumentos de entrada:
%
%       1 - [data] = trData(name, number);
%       2 - [data] = trData(name).
%
%   =======================================================================
%
%
%   Entradas --------------------------------------------------------------
%   name:   nome do arquivo;
%   number: sufixo da extensão.
%
%   Exemplos:
%       
%       - trData('ckt', 0) -> lê o arquivo ckt.tr0;
%       - trData('ckt', 6) -> lê o arquivo ckt.tr6;
%
%       - trData('ckt.tr6') -> lê o arquivo ckt.tr6;
%
%   Note que ao entrar apenas com o nome do arquivo este deve ser completo.
%
%
%   Saida -----------------------------------------------------------------
%   Como saida a função retorna um struct com o seguinte formato:
%
%            file: "trX"
%            date: dd/MM/AAAA hh:mm:ss
%        variable: []
%          values: []
%           sweep: 0
%         signals: []
%         vectors: {}
%
%   file:       extensão do arquivo com sufixo;
%   date:       data e hora em que foi realizada a simulação;
%   variable:   nome da variavel de varredura;
%   values:     vetor com os valores utilizados nas varreduras;
%   sweep:      numero de varreduras realizadas;
%   signals:    vetor de strings com o nome dos sinais elétricos;
%   vectors:    vetores com os valores dos sinais elétricos.
%
    
    %------
    inf = dir(name);
    Tfile = inf.bytes; 
    ref = (Tfile/100)*2.5;
    pAux = ref;
    progs = 0;
    %------
    
    if ~isstring(name)
        
        name = convertCharsToStrings(name);
    end
    
    if nargin == 1
        %str = split(name, '.');
        file = fopen(name);
    elseif nargin == 2
        str = num2str(number);
        str = strcat(".tr", str);
        name = strcat(name, str);
        file = fopen(name);
    end
    
    state = 0;
    values = [];
    header = '';
    %ind = 1;
    
    if file == -1
        error('File does not exist');
    else
        %-------
        fprintf('\n');
        fprintf('[Progress]-[');
        n = fprintf('] 0%%');
        %-------
        while 1
            stateFile = fgetl(file);
            if stateFile == -1
                break
            end
            line = string(stateFile);
            %-------
            progs = progs + strlength(line); 
            %-------
            if state == 0 % Monta o cabeçalho
                
                if contains(line,"$&%#")
                    
                    header = horzcat(header, stateFile);
                    inf = readHeader_tr(header);
                    data.Date = inf.Date;
                    data.Analysis = 'Transient Analysis';
                    data.Variables = inf.Variables;
                    sweep = inf.Sweep;
                            
                    indT = 1;
                    indV = 1;
                    
                    qV = size(data.Variables);          
                    
                    %---------------------
                    % A flag tem como finalidade informar se existe uma
                    % variavel de sweep.
                    %
                    % Quando em 0 indica a existencia da variavel e
                    % considera como valor o primeiro elemento da pilha de
                    % dados.
                    %
                    % Quando em 1 indica que não existe variavel.
                    %---------------------
                    if sweep > 0
                        qV = qV -1;
                        flag = 0;
                    else
                        flag = 1;
                    end
                    
                    data.Values = cell(1,1);
                    state = 1;
                    aux2 = 0;
                    
                else
                    header = horzcat(header, stateFile);
                end
                
                cont = 1;
                
            elseif (state == 1)
                
                ind = strfind(line, '.');
                tam = size(ind);
                if tam(1,2) > 1
                    r = ind(2) - ind(1);
                end
                a = 1;
                b = r;
                for i2=1:tam(1,2)
                    aux = str2mat(extractBetween(line, a, b));
                    aux = str2num(aux);
                    %-------
                    if flag == 0
                        flag = 1;
                    elseif aux == 1.0000e+30
                        cont = cont + 1;
                        if sweep > 0
                            flag = 0;
                        end
                        if aux2 == 0
                            data.Values{1,1} = values;
                            aux2 = 1;
                        else
                            data.Values = vertcat(data.Values, values);
                        end
                        values = [];
                        indV = 1;
                        indT = 1;
                    else
                        values(indT,indV) = aux;
                        if indV == qV(1,1)
                            indV = 1;
                            indT = indT + 1;
                        else
                            indV = indV + 1;
                        end
                    end
                    %-------
                    a = a + r;
                    b = b + r;
                end
            end
            
            %---------
            if progs >= pAux
                while n > 0
                    fprintf('\b');
                    n = n - 1;
                end
                n = fprintf('=] %2.0f%%', ((pAux/Tfile)*100));
                n = n-1;
                pAux = pAux+ref;
            end
            %---------
        end
    end
    %-----------
    while n > 0
        fprintf('\b');
        n = n - 1;
    end
    fprintf('=] 100%%\n');
    %-----------
    fclose(file);
end