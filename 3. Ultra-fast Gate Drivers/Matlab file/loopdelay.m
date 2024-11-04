clc
clear

%yellow_color = '#e2d810';
yellow_color = '#CbC000';
red_color = '#ff0000'; %'#d9138a';
blue_color = '#0000ff';%'#12a4d9';
black_color = '#322e2f';

magenta_color = '#d9138a';
cyan_color = '#12a4d9';
orange_color = '#D95319';


s=tf('s');

options = bodeoptions;
options.FreqUnits = 'Hz';
options.Title.FontSize = 14;
options.XLabel.FontSize = 14;
options.YLabel.FontSize = 14;
options.TickLabel.FontSize = 14;

figure();
fmax=10e6;
[mag,phase,wout] = bode(1*exp(-s*1E-9),{2*pi*100e3 2*pi*fmax});
phase4 = squeeze(phase);
wout4=wout/2/pi;
semilogx(wout4,phase4,'Color' , black_color,'LineWidth',5);
hold on

[mag,phase,wout] = bode(1*exp(-s*5E-9),{2*pi*100e3 2*pi*fmax});
phase3 = squeeze(phase);
wout3=wout/2/pi;
semilogx(wout3,phase3,'Color' , cyan_color,'LineWidth',5);

[mag,phase,wout] = bode(1*exp(-s*9E-9),{2*pi*100e3 2*pi*fmax});
phase2 = squeeze(phase);
wout2=wout/2/pi;
semilogx(wout2,phase2,'Color' , yellow_color,'LineWidth',5);

[mag,phase,wout] = bode(1*exp(-s*22E-9),{2*pi*100e3 2*pi*fmax});
phase1 = squeeze(phase);
wout1=wout/2/pi;
semilogx(wout1,phase1,'Color' , magenta_color,'LineWidth',5);
hold off

ylim([-82 2]);
set(gca,'FontSize',16)
label_x=xlabel('$Frequency [Hz]$','Interpreter','latex','FontSize',22,'HorizontalAlignment','center');
set(label_x,'rotation',0);
label_h=ylabel('$Phase \ [{^\circ}]$','Interpreter','latex','FontSize',22,'HorizontalAlignment','center');
set(label_h,'rotation',90);
%legend('\it t_{d}=22ns','\it t_{d}=10ns','\it t_{d}=5ns','Location','southeast','FontSize',20);
legend('$ t_d=1ns$','$ t_d=5ns$','$ t_d=9ns$','$ t_d=22ns$','Interpreter','latex','Orientation','horizontal','Location','southeast','FontSize',22)
legend('boxoff')
grid on
hold off
My_LGD = legend;
My_LGD.NumColumns = 2;    % Show legends in 5 lines
h=gcf;
set(h,'Position',[200 200 720 570]);
xlim([100e3 fmax]);


if (0)
figure();
bode((1+100*s)*exp(-s*22E-9),(1+100*s)*exp(-s*10E-9),(1+100*s)*exp(-s*5E-9),(1+100*s)*exp(-s*1E-9),options);
xlim([100e3 30e6]);
ylim([-270 90]);
grid on
end
