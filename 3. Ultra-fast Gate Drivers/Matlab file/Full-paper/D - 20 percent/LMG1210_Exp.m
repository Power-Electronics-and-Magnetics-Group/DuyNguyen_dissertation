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

format long
data = csvread('Tek001_ALL.csv',1); % Read the data
x = 180;
t1 = data(x:end,2);
for i=2:(numel(t1))
    t1(i)=t1(i)-t1(1);
end
t1(1) = 0;
t1 =t1./1e12;
CH1=smooth(data(x:end,6)/1e6);  % Vpwm
CH2=smooth(data(x:end,10)/1e6);  % Vgs,L
CH3=smooth(data(x:end,8)/1e6);  % Vgg,H
CH4=smooth(data(x:end,4)/1e6);  % Vsw

figure();
plot(t1*1e9,CH1,'Color' , black_color,'LineWidth',2.5);
%grid on
xlim([0 100]);
ylim([-0.5 5.5]);
set(gca,'FontSize',13)
label_h=ylabel('$Voltage \ [V]$','Interpreter','latex','FontSize',20,'HorizontalAlignment','center');
set(label_h,'rotation',90);
grid minor
h=gcf;
set(h,'Position',[200 200 680 200]);

figure();
plot(t1*1e9,CH2,'Color' , cyan_color,'LineWidth',2.5);
hold on
plot(t1*1e9,CH3,'Color' , magenta_color,'LineWidth',2.5);
xlim([0 100]);
ylim([-1.5 10.3]);
set(gca,'FontSize',13)
label_h=ylabel('$Voltage \ [V]$','Interpreter','latex','FontSize',20,'HorizontalAlignment','center');
set(label_h,'rotation',90);
grid minor
h=gcf;
set(h,'Position',[200 200 680 200]);

figure();
plot(t1*1e9,CH4,'Color' , yellow_color,'LineWidth',2.5);
set(gca,'FontSize',13)
xlim([0 100]);
ylim([-0.5 6]);
label_x=xlabel('$Time \ [ns]$','Interpreter','latex','FontSize',20,'HorizontalAlignment','center');
set(label_x,'rotation',0);
label_h=ylabel('$Voltage \ [V]$','Interpreter','latex','FontSize',20,'HorizontalAlignment','center');
set(label_h,'rotation',90);
grid minor
h=gcf;
%set(h,'Position',[200 200 720 570]);
set(h,'Position',[200 200 680 200]);