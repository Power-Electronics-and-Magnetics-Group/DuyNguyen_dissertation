clc
clear all


D=0.5;
Vo=400;
Po=300;
Ro=Vo^2/Po;
L=250e-6;
C=330e-6;
Dp=1-D;
Rc=0.1;
s=tf('s');

R1=3.3e3;
R2=200e3;
R3=120e3;
R4=2.573e3;
C2=3e-9;
C3=4e-9;
R12=R1*R2/(R1+R2);
Gc = 1/((R1+R2)*s*C3)*(1+s*R2*C2)*(1+s*R3*C3)/(1+s*R12*C2);
Vm=5;
Gpwm=1/Vm;

options = bodeoptions;
options.FreqUnits = 'Hz';
options.Title.FontSize = 14;
options.XLabel.FontSize = 14;
options.YLabel.FontSize = 14;
options.TickLabel.FontSize = 14;
Gvd=Dp*Ro*Vo*(1-s*L/(Dp^2*Ro))*(s*Rc*C+1)/(s^2*(Ro+Rc)*L*C + s*(L+Dp^2*Ro*Rc*C) + Dp^2*Ro);
Ts=Gvd*Gc*Gpwm;
[z01,gain01]=zero(Ts);
p01=pole(Ts);
z01=abs(z01)
p01=abs(p01)
figure('Name','Gvd');
bode(Gvd, Ts,options);
legend('Gvd','Ts','FontSize',18);
grid on
