%% Boost Converter for Input Filter
close all


s = tf('s'); 
%Boost Values
D=0.5;
Dn = 1-D;
R=533;
Resr = 0;%increase ESR for damping
L=250e-6;
C = 330e-6; 
%C = 833e-9;


Vc = 400;
IL = 1.5;
fsw = 150e3;
wsw = fsw * 2*pi;
wHF = wsw *5; 

options = bodeoptions;
options.FreqUnits = 'rad/s';
options.Title.FontSize = 14;
options.XLabel.FontSize = 14;
options.YLabel.FontSize = 14;
options.TickLabel.FontSize = 14;

%with ESR
vc = R*(Vc*(1-D) - s*L*IL)*(1+s*Resr*C);
d = (s^2 *L*C*(R+Resr)) + (R*((1-D)^2))+(s*(L+(((1-D)^2)*R*Resr*C)));
Gvd = vc/d;

wz1 =  1.74e3;
wz2 = 642.5;
wp= 5.987e5;
k = 44.586; % note the gain needs to be multplied by 5 due to comparator  
Gc = k*(((s+wz1)*(s+wz2))/(s+wp));
H = 1/s; %integrator term

Ts = Gvd*Gc*H;
figure
bode(Gvd,Ts,options);
title('Loop Gain Ts'); 
xlim([10 100e6]);
grid on
legend('Gvd','Ts','FontSize',18);
figure
margin(Ts);

%controlSystemDesigner(Gvd,Gc,H);

% figure
% Ts2 = C_rip * G_rip * H;
% bode(Ts,Ts2);
% title('Loop Gain Ts Comparison'); 
% legend('330uF Cap','833nF Cap','FontSize',18);
% grid on
% 
% figure
% margin(Ts2);
% grid on




