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
R=500;
Resr = 0;%increase ESR for damping
L=250e-6;
C = 100e-6; 


Vc = 50;
IL = 0.1;
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



Kp=1;
Ki=1e3; %1e5 %6.66e-6
Gcomp=Kp+Ki/s;
Ts_new=Gvd*Gcomp;
figure
bode(Gvd,Ts_new,options);


title('Loop Gain Ts'); 
xlim([10 1e6]);
legend('Gvd','Ts','FontSize',18);
grid on



