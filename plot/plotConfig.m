%% Configuration plot

type            = 'linha';
lineWidth       = 1.5;

%% Configuration axis

axiColor        = 'white';
backColor       = 'none';
gridColor       = [0.15 0.15 0.15];
fontSize        = 17;
box             = 'off';
Grid            = 'on'; 

%% Configuration window

winColor        = [0.1725 0.1529 0.1765];

%% Configuration for paper

fig             = gcf;
picturewidth    = 20;
hw_ratio        = 0.65;

set(findall(fig,'-property','FontSize'),'FontSize',fontSize);
set(findall(fig,'-property','Box'),'Box',box);
set(findall(fig,'-property','Interpreter'),'Interpreter','latex');
set(findall(fig,'-property','TickLabelInterpreter'),...
    'TickLabelInterpreter','latex');
set(fig,'Units','centimeters','Position',...
    [3 3 picturewidth hw_ratio*picturewidth]);

pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','centimeters',...
    'PaperSize', [pos(3), pos(4)]);

%print(fig,'pdf_figure','-dpdf','-painters', '-fillpage');
%print(fig,'png_figure','-dpng','-painters');
