function [] = plotSpice(spice,cmd)

%%
flag = 0;
lim = '0';
plotConfig;

%%

if strcmp(spice.Analysis, 'Transient Analysis')
    x = getVector(spice,'dom');
    titleG = titleG_tr;
    axisXG = axisXG_tr;
    axisYG = axisYG_tr;
elseif strcmp(spice.Analysis, 'DC transfer characteristic')
    x = getVector(spice,'dom');
    titleG = titleG_dc;
    axisXG = axisXG_dc;
    axisYG = axisYG_dc;
elseif strcmp(spice.Analysis,'ac')
    %Continuar
end

tam = size(cmd);
if tam(1,1) == 1
    cmd = split(cmd);
end

tam = size(cmd);
for i = 1:tam(1,1)
    if (contains(cmd{i,1},"-"))&&(contains(cmd{i,1},"="))
        aux = split(cmd{i,1},'=');
        switch aux{1,1}
            case '-title'
                titleG = aux{2,1};
            case '-axisx'
                axisXG = aux{2,1};
            case '-axisy'
                axisYG = aux{2,1};
            case '-t'
                type = aux{2,1};
            case '-fst'
                fontSizeT = str2num(aux{2,1});
            case '-fsx'
                fontSizeX = str2num(aux{2,1});
            case '-fsy'
                fontSizeY = str2num(aux{2,1});
            case '-lw'
                lineWidth = str2num(aux{2,1});
            case '-limx'
                limAux = strrep(aux{2,1},';',' ');
                limX = str2num(limAux);
                lim = 'x';
            case '-limy'
                limAux = strrep(aux{2,1},';',' ');
                limY = str2num(limAux);
                lim = 'y';
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

hold on
tam = size(vector);
for i=1:tam(1,1)
    y = getVector(spice,vector{i,1});
    if type == 'c'
        plot(x, y, 'LineWidth', lineWidth);
    elseif type == 'd'
        scatter(x, y, 8, 'filled');
    end
end
title(titleG, 'FontSize', fontSizeT);
xlabel(axisXG, 'FontSize', fontSizeX);
ylabel(axisYG, 'FontSize', fontSizeY);

axis = gca;
if lim == 'y'
    axis.YLim = limY;
end
if lim == 'x'
    axis.XLim = limX;
end
grid on
hold off
end