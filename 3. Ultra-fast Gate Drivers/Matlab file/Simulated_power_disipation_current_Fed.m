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

P_80percent=[0.49 0.383 0.284 0.22 0.177]; % W
P_50percent=[0.316 0.282 0.242 0.21 0.175];% W

P_20percent=[0.146 0.138 0.13 0.12 0.112];% W

%%
figure();
stem(Rs,P_80percent,'o','filled','Color' , yellow_color, 'LineStyle', 'none' ,'LineWidth',7);
hold on
stem(Rs,P_20percent,'o','filled','Color' , cyan_color, 'LineStyle', 'none' ,'LineWidth',7);
hold on
stem(Rs,P_50percent,'o','filled','Color' , magenta_color, 'LineStyle', 'none' ,'LineWidth',7);


ylim([0.05 0.55]);
xlim([0 21]);
set(gca,'FontSize',18)
label_x=xlabel('$Resistance \ R_s \ [\Omega]$','Interpreter','latex','FontSize',22,'HorizontalAlignment','center');
set(label_x,'rotation',0);
label_h=ylabel('$Power \ Consumption \ [W]$','Interpreter','latex','FontSize',22,'HorizontalAlignment','center');
set(label_h,'rotation',90);

ax = gca;
ax.YAxis(1).Color = 'k';
hold off
legend('$D = 80 \%$','$D = 50 \%$','$D = 20 \%$','Interpreter','latex','Orientation','horizontal','Location','southeast','FontSize',22)
legend('boxoff')
My_LGD = legend;
My_LGD.NumColumns = 1;    % Show legends in 5 lines
h=gcf;
set(h,'Position',[200 200 700 500]);
grid on
%grid minor

