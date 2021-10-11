function [] = plotSpice(spice,cmd)
    if nargin == 2
        tam = size(cmd);
        if tam(1,1) == 1
            cmd = split(cmd);
            tam = size(cmd);
        end
        flag = 0;
        for i = 1:tam(1,1)
            if contains(cmd{i,1},"-")
            else
                if flag == 0
                    vector = cmd(i,1);
                    flag = 1;
                else
                    vector = vertcat(vector,cmd{i,1});
                end
            end
        end
        if strcmp(spice.Analysis, 'Transient Analysis')
            x = getVector(spice,'time');
            titleG = 'Transient Analysis';
            axisXG = 'Time (s)';
            axisYG = 'Amplitude';
        elseif strcmp(spice.Analysis, 'DC transfer characteristic')
            x = getVector(spice,'v(v-sweep)');
            titleG = 'DC Transfer Characteristic';
            axisYG = 'Amplitude';
        elseif strcmp(spice.Analysis,'ac')
        end
        tam = size(cmd);
        for i = 1:tam
            aux = split(cmd{i,1},'=');
            switch aux{1,1}
                case '-title'
                    titleG = aux{2,1};
                case '-axisX'
                    axisXG = aux{2,1};
                case '-axisY'
                    axisYG = aux{2,1};
            end
        end
    end
    hold on
    tam = size(vector);
    for i=1:tam(1,1)
        y = getVector(spice,vector{i,1});
        plot(x, y, 'LineWidth', 1); % -- continuo
        %scatter(x, y, 8, 'filled') % -- dispercao
    end

    title(titleG, 'FontSize',15);
    xlabel(axisXG, 'FontSize', 15);
    ylabel(axisYG, 'FontSize', 15);

    %axis = gca;
    %axis.YLim = [min max];
    %axis.XLim = [min max];

    grid on
    
    if nargout == 0
    elseif nargout == 1
    end

    hold off
end