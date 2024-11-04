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

Current_fed=[0.244 0.36 0.675]; % W
LVDS=[0.441 0.442 0.442];% W

LMG1210=[0.137 0.133 0.105];% W

%%
figure();
stem(D,LMG1210,'o','filled','Color' , black_color, 'LineStyle', 'none' ,'LineWidth',7);
hold on
stem(D,LVDS,'o','filled','Color' , yellow_color, 'LineStyle', 'none' ,'LineWidth',7);
hold on
stem(D,Current_fed,'o','filled','Color' , magenta_color, 'LineStyle', 'none' ,'LineWidth',7);


ylim([0 0.8]);
xlim([0.15 0.85]);
set(gca,'FontSize',18)
label_x=xlabel('$Duty \ D$','Interpreter','latex','FontSize',22,'HorizontalAlignment','center');
set(label_x,'rotation',0);
label_h=ylabel('$Power \ Consumption \ [W]$','Interpreter','latex','FontSize',22,'HorizontalAlignment','center');
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

