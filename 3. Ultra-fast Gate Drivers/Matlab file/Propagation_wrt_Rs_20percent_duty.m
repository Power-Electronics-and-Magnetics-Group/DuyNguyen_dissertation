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
Rs= [1 5 10 15 20];

t_on_delay=[2.7 2.48 2.2 2 1.87]; % ns
t_off_delay=[1.9 2 2.1 2.1 2.2];% ns

%%
figure();
stem(Rs,t_on_delay,'o','filled','Color' , cyan_color, 'LineStyle', 'none' ,'LineWidth',7);
hold on
stem(Rs,t_off_delay,'o','filled','Color' , magenta_color, 'LineStyle', 'none' ,'LineWidth',7);
ylim([0 7]);
xlim([0 21]);
set(gca,'FontSize',18)
label_x=xlabel('$Resistance \ R_s \ [\Omega]$','Interpreter','latex','FontSize',22,'HorizontalAlignment','center');
set(label_x,'rotation',0);
label_h=ylabel('$Propagation \ Delay \ [ns]$','Interpreter','latex','FontSize',22,'HorizontalAlignment','center');
set(label_h,'rotation',90);

ax = gca;
ax.YAxis(1).Color = 'k';
hold off
legend('$t_{d,on}$','$t_{d,off}$','Interpreter','latex','Orientation','horizontal','Location','southeast','FontSize',22)
legend('boxoff')
My_LGD = legend;
My_LGD.NumColumns = 1;    % Show legends in 5 lines
h=gcf;
set(h,'Position',[200 200 700 450]);
grid on
%grid minor

