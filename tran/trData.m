function [data] = trData(name, number)

    if ~isstring(name)
        
        name = convertCharsToStrings(name);
    end
    
    if nargin == 1
        
        str = split(name, '.');
        data.file = str(2,1);
        file = fopen(name);
    elseif nargin == 2
        
        str = num2str(number);
        data.file = strcat("tr", str);
        str = strcat(".tr", str);
        name = strcat(name, str);
        file = fopen(name);
    end

    str1 = "descriptions =========================================";
    
    flag = 0;
    state = 0;
    stateSignal = 0;
    interaction = 0;
    values = [];
    auxTable = [];

    data.date = [];
    data.variable = [];
    data.values = [];
    data.sweep = [];
    data.signals = [];
    data.vectors = {};
    
    if file == -1

        error('File does not exist');
    else

        while 1
            
            stateFile = fgetl(file);
            if stateFile == -1
                
                break
            end
            line = string(stateFile);
            if state == 0

               %aux = contains(line, str1);
               aux = 1;
               if ~aux

                   error('Is not file .tr*');
               else

                   state = 1;
               end
            elseif state == 1
                
                % Extrai a data e a hora do arquivo.
                date = extractBetween(line, 9, 18);
                time = extractBetween(line, 25, 32);
                aux = sprintf("%s %s", date, time);
                data.date = datetime(aux, 'InputFormat','MM/dd/uuuu HH:mm:ss');
                data.date.Format = 'dd/MM/uuuu HH:mm:ss';
                state = 2;
            elseif state == 2
                
                % Extrai o numero de interações da função "sweep".
                data.sweep = sscanf(line,"served.%d");
                state = 3;
            elseif state == 3
                
                % Extrai o nome dos sinais.
                if contains(line,"(")

                    aux = extractBetween(line, "(", " ");
                   data.signals = vertcat(data.signals, aux);
                    tam = size(data.signals);
                    tam = tam(1,1);
                    names{1,1} = 't';
                    for i=1:tam
                        
                        auxName = char(data.signals(i,1));
                        auxName = strrep(auxName,'.','_');
                        names{1,(i+1)} = auxName;
                    end
                end
                
                % Reconhece o final do cabeçalho e o inicio dos dados.
                if contains(line,"$&%#")
                    
                    i = strfind(line, '$');
                    i = i - 16;
                    if i <= 0
                        
                        tam2 = strlength(lineAux);
                        i = tam2 + i;
                        while 1
                            
                            str2 = extractBetween(lineAux, i, i);
                            if (i == tam2)||(strcmp(str2, " "))
                                
                                break
                            else
                                
                                data.variable = strcat(data.variable, str2);
                                i = i + 1;
                            end
                        end
                    else
                        
                        while 1
                            
                            str2 = extractBetween(line, i, i);
                            if (strcmp(str2, " "))||(strcmp(str2, "$"))
                                
                                break
                            else
                                
                                data.variable = strcat(data.variable, str2);
                                i = i + 1;
                            end
                        end
                    end
                    state = 4;
                end
                lineAux = line;
            elseif (state == 4)
                
                %  Leitura do conteudo
                i1 = 1;
                i2 = 11;
                while 1
                    
                    aux = str2mat(extractBetween(line, i1, i2));
                    aux = str2num(aux);
                    if (flag == 0)&&(data.sweep > 0)
                        
                        % O primeiro valor é o da interação.
                        data.values = vertcat(data.values, aux);
                        i1 = i1 + 11;
                        i2 = i2 + 11;
                        flag = 1;
                    elseif aux == 1.0000e+30
                        
                        % Fim da interação
                        auxTable(interaction, : ) = values;
                        table = array2table(auxTable, 'VariableNames', names);
                        data.vectors = [data.vectors; {table}];
                        values = [];
                        stateSignal = 0;
                        interaction = 0;
                        flag = 0;
                        break
                    else
                        
                        if stateSignal == (tam + 1)
                            
                            interaction = interaction + 1;
                            auxTable(interaction, : ) = values;
                            values = [];
                            stateSignal = 0;
                        else
                            
                            stateSignal = stateSignal + 1;
                            values = horzcat(values, aux);
                            if i2 == 77
                                % Encontra o comando "/n" no final do
                                % setimo dado.
                                break
                            end
                            i1 = i1 + 11;
                            i2 = i2 + 11;
                            
                        end
                    end
                end
            end
        end
    end
    fclose(file);
end

