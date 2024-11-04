clc
clear all

%yellow_color = '#e2d810';
yellow_color = '#CbC000';
red_color = '#ff0000'; %'#d9138a';
blue_color = '#0000ff';%'#12a4d9';
black_color = '#322e2f';



format long
data = csvread('Tek093_ALL.csv',1); % Read the data

f1=data(1:1898,6)/1e6;
FFT1=data(1:1898,7);
f2=data(1:1898,9)/1e6;
FFT2=data(1:1898,10);


figure();
%plot(f2,CH4,'Color' , yellow_color,'LineWidth',1.5);
plot(f1,FFT1,'Color' , blue_color,'LineWidth',2);
xlim([0.1 3]);
ylim([-100 20]);
set(gca,'FontSize',13)
label_h=ylabel('$I_{conv} \ [dBmA]$','Interpreter','latex','FontSize',18,'HorizontalAlignment','center');
set(label_h,'rotation',90);
grid minor

figure();
plot(f2,FFT2,'Color' , red_color,'LineWidth',2);
xlim([0.1 3]);
ylim([-120 -20]);
set(gca,'FontSize',13)
label_x=xlabel('$Frequency [MHz]$','Interpreter','latex','FontSize',18,'HorizontalAlignment','center');
set(label_x,'rotation',0);
label_h=ylabel('$I_{s} \ [dBmA]$','Interpreter','latex','FontSize',18,'HorizontalAlignment','center');
set(label_h,'rotation',90);
grid minor