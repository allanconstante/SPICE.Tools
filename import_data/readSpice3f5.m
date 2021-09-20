%%
%Data: 18/09/2021
%Autor: Allan Appelt Constante

%%

%aux = str2num(aux);
%str = split(name, '.');
%name = strcat(name, str);
%strcmp(str2, " ")
%aux = contains(line, str1);
%data.signals = vertcat(data.signals, aux);

function [data] = readSpice3f5(name)

    file = fopen(name);

    No_Variables = 0;
    No_Points = 0;

    %data.Values = zeros(1001,18);

    while 1

        stateFile = fgetl(file);
        if stateFile == -1
            break
        end

        strAux = split(stateFile, ": ");
        if strcmp(strAux{1,1}, 'Date')
            data.Date = datetime(strAux{2,1}, 'InputFormat',...
                'eee MMM dd HH:mm:ss uuuu');
            data.Date.Format = 'dd/MM/uuuu HH:mm:ss';
        elseif strcmp(strAux{1,1}, 'Plotname')
            data.Analysis = strAux{2,1};
        elseif strcmp(strAux{1,1}, 'No. Variables')
            No_Variables = str2num(strAux{2,1});
            data.Variables = cell(No_Variables,1);
        elseif strcmp(strAux{1,1}, 'No. Points')
            No_Points = str2num(strAux{2,1});
            data.Values = zeros(No_Points,No_Variables);
        elseif strcmp(strAux{1,1}, 'Variables:')
            for i=1:No_Variables
                stateFile = fgetl(file);
                aux = split(stateFile);
                aux = aux{3,1};
                data.Variables{i,1} = aux;
            end
        elseif strcmp(strAux{1,1}, 'Values:')
            %------
            ref = (No_Points/100)*2.5;
            pAux = ref;
            %------
            for line=1:No_Points
                stateFile = fgetl(file);
                if isempty(stateFile)
                    stateFile = fgetl(file);
                end
                strAux = split(stateFile);
                auxT = size(strAux);
                aux = str2num(strAux{auxT(1,1),1});
                data.Values(line,1) = aux;
                for column=2:No_Variables
                    stateFile = fgetl(file);
                    aux = str2num(stateFile);
                    data.Values(line,column) = aux;
                end
                %------
                if line == 1
                    fprintf('\n');
                    fprintf('[Progress]-[');
                    n = fprintf('] 0%%');
                elseif line == No_Points
                    while n > 0
                        fprintf('\b');
                        n = n - 1;
                    end
                    fprintf('=] 100%%\n');
                elseif line >= pAux
                    while n > 0
                        fprintf('\b');
                        n = n - 1;
                    end
                    n = fprintf('=] %2.0f%%', ((pAux/No_Points)*100));
                    n = n-1;
                    pAux = pAux+ref;
                end
                %------
            end
        end
    end
    fclose(file);
end
