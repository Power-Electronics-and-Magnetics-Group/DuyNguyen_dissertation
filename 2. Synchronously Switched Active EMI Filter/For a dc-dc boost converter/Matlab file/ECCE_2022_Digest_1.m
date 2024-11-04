clc
clear all

%yellow_color = '#e2d810';
yellow_color = '#CbC000';
red_color = '#ff0000'; %'#d9138a';
blue_color = '#0000ff';%'#12a4d9';
black_color = '#322e2f';



format long
data = csvread('Tek085_ALL.csv',1); % Read the data
t1 = data(:,2)*10^6; 
CH6=(data(:,3));
CH7=(data(:,4));

figure();
plot(t1,CH6,'Color' , yellow_color,'LineWidth',2.4);
hold on
plot(t1,CH7,'Color' , blue_color,'LineWidth',2.4);
%ylim([0 5.5]);
%xlim([0 15]);
set(gca,'FontSize',13)
label_h=ylabel('$Voltage \ [V]$','Interpreter','latex','FontSize',18,'HorizontalAlignment','center');
set(label_h,'rotation',90);
grid minor

figure();
plot(t1,CH4,'Color' , red_color,'LineWidth',2.4);
hold on
plot(t1,CH5,'Color' , blue_color,'LineWidth',2.4);
ylim([-4 14]);
xlim([0 15]);
set(gca,'FontSize',13)
label_h=ylabel('$Voltage \ [V]$','Interpreter','latex','FontSize',18,'HorizontalAlignment','center');
set(label_h,'rotation',90);
grid minor

figure();
plot(t1,-CH1,'Color' , yellow_color,'LineWidth',1.5);
hold on
plot(t1,CH2,'Color' , blue_color,'LineWidth',1.5);
plot(t2,CH9,'Color' , red_color,'LineWidth',2.6);
grid on
ylim([-1.9 3]);
xlim([0 15]);
set(gca,'FontSize',13)
label_h=ylabel('$Current \ [A]$','Interpreter','latex','FontSize',18,'HorizontalAlignment','center');
set(label_h,'rotation',90);
grid minor

figure();
plot(t1,CH3,'Color' , black_color,'LineWidth',2.4);
set(gca,'FontSize',13)
%ylim([-6 15]);
xlim([0 15]);
label_x=xlabel('$Time \ [\mu s]$','Interpreter','latex','FontSize',18,'HorizontalAlignment','center');
set(label_x,'rotation',0);
label_h=ylabel('$Current \ [A]$','Interpreter','latex','FontSize',18,'HorizontalAlignment','center');
set(label_h,'rotation',90);
grid minor



figure();
%plot(f2,CH4,'Color' , yellow_color,'LineWidth',1.5);
plot(f1,FFT1,'Color' , blue_color,'LineWidth',2);
xlim([0.1 3]);
ylim([-110 20]);
set(gca,'FontSize',13)
label_h=ylabel('$I_{conv} \ [dBmA]$','Interpreter','latex','FontSize',18,'HorizontalAlignment','center');
set(label_h,'rotation',90);
grid minor

figure();
plot(f2,FFT2,'Color' , red_color,'LineWidth',2);
xlim([0.1 3]);
ylim([-130 -20]);
set(gca,'FontSize',13)
label_x=xlabel('$Frequency [MHz]$','Interpreter','latex','FontSize',18,'HorizontalAlignment','center');
set(label_x,'rotation',0);
label_h=ylabel('$I_{s} \ [dBmA]$','Interpreter','latex','FontSize',18,'HorizontalAlignment','center');
set(label_h,'rotation',90);
grid minor