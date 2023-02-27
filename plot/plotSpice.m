function [] = plotSpice(spice,cmd)

%%

flag            = 0;

%%
figr            = figure('Name',spice.Analysis,'NumberTitle','off');
axis            = axes;

plotConfig;

figr.Color      = winColor;

axis.XColor     = axiColor;
axis.YColor     = axiColor;
axis.Color      = backColor;
axis.GridColor  = gridColor;

if strcmp(spice.Analysis, 'Transient Analysis')
    
    axisXG = 'Time (s)';
elseif strcmp(spice.Analysis, 'DC transfer characteristic')
    
    axisXG = 'Sweep Voltage (V)';
elseif strcmp(spice.Analysis,'ac')
    
    %Continuar
end

if strcmp(Grid, 'on')
    grid minor
elseif strcmp(Grid, 'off')
    grid off;
end

%%

x = getVector(spice,'dom');

tam = size(cmd);

for i = 1:tam(1,1)
    
    if (contains(cmd{i,1},"-"))&&(contains(cmd{i,1},"="))
        
        aux = split(cmd{i,1},'=');
        
        switch aux{1,1}
            
            case '-x'
                axisXG = aux{2,1};
            case '-y'
                axisYG = aux{2,1};
            case '-tp'
                type = aux{2,1};
            case '-lx'
                limAux = strrep(aux{2,1},';',' ');
                axis.xLim = str2num(limAux);
            case '-ly'
                limAux = strrep(aux{2,1},';',' ');
                axis.YLim = str2num(limAux);
        end
        
    elseif contains(cmd{i,1},"-")
        
        switch cmd{i,1}
            
            case '-xy'
                flag = 2;
        end
        
    else
        
        if flag == 0
            vector{1,1} = cmd{i,1};
            flag = 1;
        elseif flag == 1
            vector = vertcat(vector, cmd{i,1});
        elseif flag == 2
            x = getVector(spice,cmd{i,1});
            axisXG = 'Amplitude';
            flag = 0;
        end
        
    end
end

%%

hold on

liV = '';
lsV = '';
liI = '';
lsI = '';

state = 0;

tam = size(vector);
for i=1:tam(1,1)
    
    y = getVector(spice,vector{i,1});
    
    if contains(vector{i,1},"v(")
        
        if isempty(liV)
        
            liV = min(y);
            lsV = max(y);
        end
        
        if state == 0
            state = 1;
        elseif state == 2
            yyaxis right;
            flag = 4;
        elseif ((state == 1)&&(flag == 3))
            yyaxis left;
        end
        
        if strcmp(type, 'linha')

            plot(x, y, 'LineWidth', lineWidth);
            [liV, lsV] = getLimits([liV lsV],[min(y) max(y)]);
            axis.YLim = [liV lsV];
        elseif strcmp(type, 'pontos')

            scatter(x, y, 8, 'filled');
        end
        ylabel('Voltage (V)','Interpreter','Latex');
    elseif contains(vector{i,1},"i(")
        
        if state == 0
            state = 2;
        elseif state == 1
            yyaxis right;
            flag = 3;
        elseif ((state == 2)&&(flag == 4))
            yyaxis left;
        end
        
        if isempty(liI)
        
            liI = min(y);
            lsI = max(y);
        end
        
        if strcmp(type, 'linha')

            plot(x, y, 'LineWidth', lineWidth);
            [liI, lsI] = getLimits([liI lsI],[min(y) max(y)]);
            axis.YLim = [liI lsI];
        elseif strcmp(type, 'pontos')

            scatter(x, y, 8, 'filled');
        end
        ylabel('Current (A)','Interpreter','Latex');
    end
end

axis.XLim = [x(1,1) x(end,end)];

xlabel(axisXG,'Interpreter','Latex');

if (flag == 3)||(flag == 4)
    yyaxis left;
    axis.YColor = axiColor;
    yyaxis right;
    axis.YColor = axiColor;
end

hold off

leg = legend(vector, 'Interpreter','Latex');
leg.Color = 'none';
leg.Box = 'off';
leg.TextColor = 'white';

end