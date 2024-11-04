%% Switching- Active EMI filter
% Name: Duy Nguyen
% Hitory
% -- Jan 08 2021: Initilization
%%
clear
clc

%%
pi=3.141592654;

%% PFC boost converter operating at BCM mode
% DC input voltage 
Vdc=200; % [V]
% Output power of PFC boost converter
% Boost is designed to work at BCM mode for highest current ripple
Pout=1000; % [W]
% Switching frequency is lower than 150kHz, out of conducted EMI range
fsw_boost=150E3; % [Hz]
w=2*pi*fsw_boost; % [rad/s]
% Average ac current amplitude
Iconv=Pout/Vdc; % [A]

% Active EMI amplifier: optimum Volume and Capacitance
% Power density
Ro_amp=50/0.0254^3;  % [W/m^3] 
% Capacitance density 
Ro_c=0.047; % [F/m^3]

% --> Optimal capacitance 
Copt=Iconv*(2*Ro_c/Ro_amp/w)^0.5; % [F]
% --> Optimal Volume
VOLopt=2*Iconv*(2/Ro_c/Ro_amp/w)^0.5; % [m^3]
VOLopt=VOLopt/0.0254^3; % [in^3]
% --> Optimal capacitance voltage
Vcopt=(Ro_amp/2/w/Ro_c)^0.5; % [V]
% Voltage supply or Vdd
Vdd=2*ceil(Vcopt);

%% Active EMI filter operating at Synschronous- CCM mode buck converter
% with frequency of 31MHz or possible to go higher
fsw_emi=31E6; % [Hz]
% Use 2 GaN EPC8004 devices in parallel for each leg
Cgs=55E-12*2;
Coss=40E-12*2;
Rdson=110E-3/2;
% GaN GS on voltage
Vgs=5;
% Gate power loss
Pg=(Cgs*Vgs^2*fsw_emi)*2;
% Switching loss
Psw=(Coss*Vdd^2*fsw_emi)*2;
% Conduction loss
Pcond=(Rdson*(Iconv/2)^2)*2;
% Total loss by switches
Psw_tt=Pg+Psw+Pcond;
% Assume same loss for magnetic component, total loss
Pdiss_sw=2*Psw_tt;
% Amplifier's average power
Pamp=2*Iconv^2/(pi*w*Copt); %%%% Why Dr. Hanson multiplied 2 here
% Switched amplified's efficiency
Eff=Pamp/(Pamp+Pdiss_sw)*100;

% --> Power dissipation of linear amplifier
Pdiss_lin=((Eff/100)/(1-Eff/100))*pi*Pdiss_sw;

% Switched power dissipation vs. linear power dissipation
Eff_sw=linspace(0.1,1);
diss_r=(1-Eff_sw)./Eff_sw./pi;
figure('Name','Power Dissipation of SW vs. Linear Amplifiers');
plot(Eff_sw,diss_r,'b','LineWidth',1.5);
ylim manual
xlim([0 1]);
ylim([0 2]);
xlabel('\eta','FontSize',20);
label_h=ylabel('$\frac{P_{diss,sw}}{P_{diss,lin}}$','Interpreter','latex','FontSize',25,'HorizontalAlignment','right');
set(label_h,'rotation',0);
title('Power Dissipation of SW vs. Linear Amplifiers');
xline(1/(1+pi),'LineStyle','--', 'LineWidth', 1.2)
yline(1,'LineStyle','--', 'LineWidth', 1.2)
text(0.1,1.2,{'Switching not','worthwhile'},'FontSize',16,'HorizontalAlignment','center')
text(0.4,0.8,{'Switching','worthwhile'},'FontSize',16,'HorizontalAlignment','center')
text(0.85,0.4,'Estimate on Efficiency','Color','r','FontSize',16,'HorizontalAlignment','center')
annotation('ellipse',[.7 0.05 .25 .15],'Color','r','LineWidth', 1.2)
%annotation('textbox',[.9 .5 .1 .2],'String','Switching worthwhile','FontSize',14,'EdgeColor','none')
