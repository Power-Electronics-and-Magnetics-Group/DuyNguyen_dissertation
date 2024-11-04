%% Boost Converter for Input Filter
clc
clear 
%close all

yellow_color = '#CbC000';
red_color = '#ff0000'; %'#d9138a';
blue_color = '#0000ff';%'#12a4d9';
black_color = '#322e2f';

magenta_color = '#d9138a';
cyan_color = '#12a4d9';

s = tf('s'); 
%Boost Values
D=0.5;
Dn = 1-D;
R=533;
Resr = 0.1;%increase ESR for damping
L=250e-6;
C = 47e-6*4; 


Vc = 400;
IL = 1.5;
fsw = 150e3;
wsw = fsw * 2*pi;
wHF = wsw *5; 

options = bodeoptions;
options.FreqUnits = 'Hz';
options.Title.FontSize = 14;
options.XLabel.FontSize = 14;
options.YLabel.FontSize = 14;
options.TickLabel.FontSize = 14;

%with ESR
vc = R*(Vc*(1-D) - s*L*IL)*(1+s*Resr*C);

duy=(1-D)*R*Vc*(1-s*L/(1-D)^2/R)*(1+s*Resr*C);

%figure();
%bode(duy,vc,options);


%%
dd = (s^2 *L*C*(R+Resr)) + (R*((1-D)^2))+(s*(L+(((1-D)^2)*R*Resr*C)));
Gvd = vc/dd;

wz1 =  1.74e3;
wz2 = 642.5;
wp= 5.987e5/1;
k = 44.586; % note the gain needs to be multplied by 5 due to comparator 
Gc = k*(((s+wz1)*(s+wz2))/(s+wp));
H = 1/s; %integrator term

Ts = Gvd*Gc*H;


if (0)
    Ts1 = duy/dd*Gc*H;
figure
bode(Ts1,Ts,options);
title('Loop Gain Ts'); 
xlim([1 100e6]);
grid on
legend('Ts1','Ts','FontSize',18);
%figure
%margin(Ts);
end

% Sensing divider circuit
R1=1e6;
Vo=400;
Vref=2.5;
R2=Vref/(Vo-Vref)*R1;

Vm=5;
Gpwm=1/Vm;
R12=R1*R2/(R1+R2);
%C2=1/(wp*R12)
C2=33e-12;
Gain_sense = R2/(R1+R2)/(1+s*R12*C2);

R6=500e3;
C6=1/(wz2*R6);

C4=47e-9;
R4=1/(wp*C4)
%R4=0;


R5=1/(wz1*C4)-R4

C7=0.1e-9;
wp7=1/R6/(C6*C7/(C6+C7))

C67=C6*C7/(C6+C7);

Gcomp=(1+s*R6*C6)*(1+s*(R4+R5)*C4)/(s*(C6+C7)*R5*(1+s*R4*C4)*(1+s*R6*C67));
Ts_new=Gvd*Gcomp*Gpwm*Gain_sense;
%figure
%bode(Ts,Ts_new,options);
%bode(Gvd,Gcomp*Gpwm*Gain_sense,Ts_new,options);

%title('Loop Gain Ts'); 
%xlim([10 1e6]);
%legend('Gvd','Gc','Ts','FontSize',18);
%grid on



[mag,phase,wout] = bode(Gvd,{2*pi*10 2*pi*1e6});
Mag=20*log10(mag(:));
phase1 = squeeze(phase);
wout1=wout/2/pi;
figure('Name','Loop-Gain (Magnitude)');
semilogx(wout1,Mag,'Color' , blue_color,'LineWidth',2.6);
xlim([10 1e6]);
hold on

[mag,phase,wout] = bode(Gcomp*Gpwm*Gain_sense,{2*pi*10 2*pi*1e6});
Mag=20*log10(mag(:));
phase2 = squeeze(phase);
wout2=wout/2/pi;
semilogx(wout2,Mag,'Color' , black_color,'LineWidth',2.6);
set(gca,'FontSize',15)
label_h=ylabel('$Magnitude \ [dB]$','Interpreter','latex','FontSize',20,'HorizontalAlignment','center');
set(label_h,'rotation',90);

[mag,phase,wout] = bode(Ts_new,{2*pi*10 2*pi*1e6});
Mag=20*log10(mag(:));
phase3 = squeeze(phase);
wout3=wout/2/pi;
semilogx(wout3,Mag,'Color' , red_color,'LineWidth',2.6);
set(gca,'FontSize',15)
label_h=ylabel('$Magnitude \ [dB]$','Interpreter','latex','FontSize',20,'HorizontalAlignment','center');
set(label_h,'rotation',90);

%set(gca,'FontSize',13)
%legend('\it T_{s}','\it T_{s,d}','Location','southeast','FontSize',20);
%legend('boxoff')
grid on
hold off

figure('Name','Loop-Gain (Phase)');
%semilogx(wout1,phase1,'g','LineWidth',2.2);
semilogx(wout1,phase1,'Color' , blue_color,'LineWidth',2.6);
xlim([10 1e6]);
hold on
%semilogx(wout2,phase2,'r','LineWidth',2.2);
semilogx(wout2,phase2,'Color' , black_color,'LineWidth',2.6);
semilogx(wout3,phase3,'Color' , red_color,'LineWidth',2.6);
set(gca,'FontSize',15)
label_x=xlabel('$Frequency [Hz]$','Interpreter','latex','FontSize',20,'HorizontalAlignment','center');
set(label_x,'rotation',0);
label_h=ylabel('$Phase \ [{^\circ}]$','Interpreter','latex','FontSize',20,'HorizontalAlignment','center');
set(label_h,'rotation',90);
legend('\it G_{vd}','\it G_{c}','\it T_{s}','Location','southeast','FontSize',20);
legend('boxoff')
grid on
hold off