clc
clear

format long
%yellow_color = '#e2d810';
yellow_color = '#CbC000';
red_color = '#ff0000'; %'#d9138a';
blue_color = '#0000ff';%'#12a4d9';
black_color = '#322e2f';
magenta_color = '#d9138a';
cyan_color = '#12a4d9';
orange_color = '#D95319';

%% Rs values
D= [0.2 0.5 0.8];

Current_fed=[2.7 2.4 1.83]; % W
LVDS=[7.4 7.4 7.6];% W

LMG1210=[16.5 16.8 16.4];% W

%%
figure();
stem(D,LMG1210,'o','filled','Color' , black_color, 'LineStyle', 'none' ,'LineWidth',7);
hold on
stem(D,LVDS,'o','filled','Color' , yellow_color, 'LineStyle', 'none' ,'LineWidth',7);
hold on
stem(D,Current_fed,'o','filled','Color' , magenta_color, 'LineStyle', 'none' ,'LineWidth',7);


%ylim([0.05 0.55]);
xlim([0.15 0.85]);
set(gca,'FontSize',18)
label_x=xlabel('$Duty \ D$','Interpreter','latex','FontSize',22,'HorizontalAlignment','center');
set(label_x,'rotation',0);
label_h=ylabel('$ t_{d,off} \ [ns]$','Interpreter','latex','FontSize',22,'HorizontalAlignment','center');
set(label_h,'rotation',90);

ax = gca;
ax.YAxis(1).Color = 'k';
hold off
legend('LMG1210','LVDS','Current-fed','Interpreter','latex','Orientation','horizontal','Location','southeast','FontSize',22)
legend('boxoff')
My_LGD = legend;
My_LGD.NumColumns = 1;    % Show legends in 5 lines
h=gcf;
set(h,'Position',[200 200 700 500]);
grid on
%grid minor

