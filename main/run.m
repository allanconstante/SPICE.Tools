clc
clear

%%

%Data: 18/09/2021
%Autor: Allan Appelt Constante

%% Constantes

tran = 'Transient Analysis';
dc = 'DC transfer characteristic';
ac = '';

%% main
fprintf('******\n');
fprintf('** SPICE-Tools : Tools for interaction with data files SPICE\n');
fprintf('** Download: https://github.com/allanconstante/SPICE-Tools\n');
fprintf('** Author: Allan Appelt Constante\n');
fprintf('** Creation Date: 18/09/2021\n');
fprintf('******\n');
fprintf('\n');

while 1
    command = input('SPICE -->> ', 's');
    command = split(command);
    switch command{1,1}
        case 'source'
            tam = size(command);
            if tam(1,1) > 1
                switch command{2,1}
                    case '-3f5'
                        kinema = readSpice3f5(command{3,1});
                        tVectors = size(kinema.Values);
                        date = datestr(kinema.Date,'dd/mm/yyyy HH:MM:ss');
                        fprintf('\n');
                        fprintf('\t%s\n',command{3,1});
                        fprintf(...
                            '\t--------------------------------------\n');
                        fprintf('\tAnalysis:\t%s\n',kinema.Analysis);
                        fprintf('\tDate:\t\t%s\n', date);
                        fprintf('\tPoints:\t\t%d\n',tVectors(1,1));
                        fprintf('\tVariables:\t%d\n',tVectors(1,2));
                        fprintf(...
                            '\t--------------------------------------\n');
                        fprintf('\n');
                    case '-tr'
                        kinema = trData(command{3,1});
                        tVectors = size(kinema.Values{1,1});
                        date = datestr(kinema.Date,'dd/mm/yyyy HH:MM:ss');
                        fprintf('\n');
                        fprintf('\t%s\n',command{3,1});
                        fprintf(...
                            '\t--------------------------------------\n');
                        fprintf('\tAnalysis:\t%s\n',kinema.Analysis);
                        fprintf('\tDate:\t\t%s\n', date);
                        fprintf('\tPoints:\t\t%d\n',tVectors(1,1));
                        fprintf('\tVariables:\t%d\n',tVectors(1,2));
                        fprintf(...
                            '\t--------------------------------------\n');
                        fprintf('\n');
                end
            else
                 warning('O comando source necessita de argumentos')
            end
        case 'plot'
            if strcmp(kinema.Analysis, tran)
                tam = size(command);
                ref = getVector(kinema,'time');
                hold on
                for i=2:tam(1,1)
                    y = getVector(kinema,command{i,1});
                    plotSpice(ref,y);
                end
                hold off
            elseif strcmp(kinema.Analysis, dc)
                tam = size(command);
                ref = getVector(kinema,'v(v-sweep)');
                hold on
                for i=2:tam(1,1)
                    y = getVector(kinema,command{i,1});
                    plot(ref,y);
                end
                hold off
            end
        case '-v'
            tam = size(kinema.Variables);
            fprintf('\n');
            fprintf('\tVariables\n');
            fprintf('\t--------------------------------------\n');
            for i=1:tam(1,1)
                fprintf('\t%d:\t\t%s\n',i,kinema.Variables{i,1});
            end
            fprintf('\n');
        case 'clc'
            clc
        case 'help'
        case 'exit'
            clear
            clc
            break
        otherwise
            warning('Comando invalido.');
    end
end