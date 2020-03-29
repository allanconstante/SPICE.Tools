function [data] = trAlter(name)
    
    if ~isstring(name)
        
        name = convertCharsToStrings(name);
    end
    if contains(name, ".alter")
        
        file = fopen(name);
    else
        
        name = strcat(name, ".alter");
        file = fopen(name);
    end
    
    str = '* Parameters #####################################################';
    
    state = 0;
    pos = 0;
    i = 1;
    values = [];
    
    data.cases = 0;
    data.parameters = [];
    
    if file == -1

        error('File does not exist');
    else

        while 1
            
            stateFile = fgetl(file);
            if stateFile == -1
                
                data.vectors = array2table(auxTable, 'VariableNames', names);
                break
            end
            
            line = string(stateFile);
            if state == 0
                
                if ~(contains(line, str))
                    
                    error('Is not file .alter');
                else
                    
                    state = 1;
                end
            elseif state == 1
                
                if contains(line, '.alter')
                    
                    parameters = 1;
                    values = [];
                    pos = pos + 1;
                elseif contains(line, '+')
                    
                    aux = sscanf(line, '* + %s');
                    names{i,1} = aux;
                    aux = convertCharsToStrings(aux);
                    data.parameters = vertcat(data.parameters, aux);
                    i = i + 1;
                elseif contains(line, ':')
                    
                    tam = size(data.parameters);
                    data.cases = sscanf(line, '* : %d');
                elseif contains(line, '.param')
                    
                    if parameters <= tam(1,1)
                        
                        str = sprintf('.param %s=%%e', data.parameters(parameters,1));
                        aux = sscanf(line, str);
                        values = horzcat(values, aux);
                        if parameters == tam(1,1)
                            
                            auxTable(pos, : ) = values;
                        else
                            
                            parameters = parameters + 1;
                        end
                    end
                end
            end
        end
    end
    fclose(file);
end