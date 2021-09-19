function [] = plotSpice(x,y)
    hold on

    %scatter(x, y, 8, 'filled') % -- dispercao
    plot(x, y, 'r--', 'LineWidth', 1); % -- continuo 

    title('aaaaaa', 'FontSize',20)
    xlabel('aaaaaa', 'FontSize', 20)
    ylabel('aaaaaa', 'FontSize', 20)

    %axis = gca;
    %axis.YLim = [min max];
    %axis.XLim = [min max];

    grid on

    hold off
end

