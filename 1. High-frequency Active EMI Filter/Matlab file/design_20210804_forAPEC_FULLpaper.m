   clc
clear all

%yellow_color = '#e2d810';
yellow_color = '#CbC000';
magenta_color = '#d9138a';
cyan_color = '#12a4d9';
black_color = '#322e2f';
%yellow_color = sscanf(str1(2:end),'%2x%2x%2x',[1 3])/255;
%magenta_color = sscanf(str2(2:end),'%2x%2x%2x',[1 3])/255;
%cyan_color = sscanf(str3(2:end),'%2x%2x%2x',[1 3])/255;

s=tf('s');

alpha = 0.6;
ab=0.1;
m=6;
fmin=600;
wmin=2*pi*fmin;
wmax=wmin/ab^m;
fmax=wmax/(2*pi)

wav=(wmin*wmax)^0.5;

Dr=10;  

C1=0.001e-6;
R1=1/(wmin*C1);
%R1=10e3;;
a=10^(alpha*log10(ab));
b=ab/a;
%wav=(a/b)^0.25*(1/(R1*C1*(ab)^2))

Rp=R1*((1-a)/a);
Cp=C1*(b^m/(1-b));
for k = 1:(m-1)
    C(k)=C1*b^k;
    R(k)=R1*b^k;
end
C=[C1 C];
R=[R1 R];

Yp = 1/Rp + j*wav*Cp; Y = 0;
for k = 1:length(C)
Y = Y + (j*wav*C(k))/(1+j*wav*C(k)*R(k));
end
Ytot = Y + Yp; 
Zav = 1/abs(Ytot)

D=Zav*(wav^(-alpha));
Coff=Dr/D;

Rp=Rp/Coff;
Cp=Cp*Coff;
R=R./Coff;
C=C.*Coff;

Cpp=0.1e-6;
YY=50+1/(s*Cp);
Rp=50e3;
%Yp = 1/(Rp+1/(s*Cpp)) + 1/YY; Y = 0;

Yp = 1/(Rp) + 1/YY; Y = 0;
for k = 1:1:length(C)
Y = Y + (s*C(k))/(1+s*C(k)*R(k));
end
Ytot = Y + Yp;
Zav = 1/Ytot;


wmin1=0.94e5;
wmin2=7.5e6;
wmin3=2e4;
wkp4=[wmin2 wmin3];
wk4=[wmin1 wmin1 wmin1];
G7=zpk(-wkp4,-wk4,wmin1*wmin1*wmin1/0.013/wmin2/wmin3);
 
zeropoints=[wmin2 wmin3];
polepoints=[wmin1 wmin1 wmin1];

Cx=(4/3)*990e-9; % Can change this to change gains
R1=1/50/Cx
%R1=15e3;
C2=0.06e-9;
R2=1/zeropoints(1)/C2; % 2.21k
R3=1/polepoints(1)/C2-R2 % R3=174k
%R3=51e3;
zz1=1/R2/C2 % for wmin2
pp1=1/(R2+R3)/C2 % for wmin1
Ga=(s*Cx*R3)*(1+s*R2*C2)/(1+s*(R2+R3)*C2)/(1+s*R1*Cx);

Caa=0.2e-9; 
Raa=0.6e3;
%Raa=511;
Rf=1/polepoints(2)/Caa-Raa
Rf=52.3e3;
sys1=Rf*(1+s*Raa*Caa)/(1+s*(Rf+Raa)*Caa);
zaa=1/Raa/Caa
paa=1/(Rf+Raa)/Caa
sys=sys1/Zav;


C4=147e-9;
R4=1/zeropoints(2)/C4
R4=500;
R5=1/120/C4-R4 
R5=67e3; 
C6=47e-9;
R6=1/polepoints(3)/C6
R6=121; % R6=121 ; Rcm=50Ohm
R6=432;
p66=1/R6/C6
C7=100e-12;
R7=100;
Z7=R7+1/s/C7;
Z6=R6;
Z67=Z6*Z7/(Z6+Z7)+1/s/C6;
z77=1/C7/R6;
Gb=(s*C6*R5)*(1+s*R4*C4)/(1+s*(R4+R5)*C4)/(1+s*R6*C6);
%Gb=(R5)*(1+s*R4*C4)/(1+s*(R4+R5)*C4)/(Z67);

%30pF & 200 Ohm


% Also need to use an additional RC LPF to create an additional pole -->
% shit complex
if (1)
C8=30e-12;
R8=200
p77=1/C8/R8;
Gc=1/(1+s*R8*C8);
end


options = bodeoptions;
options.FreqUnits = 'Hz';
options.Title.FontSize = 14;
options.XLabel.FontSize = 14;
options.YLabel.FontSize = 14;
options.TickLabel.FontSize = 14;
if (1)
    if (1)
figure('Name','Stage 2');
%bode(Ga*Gb*Gc*sys,options);
bode(Ga,options);
legend('Stages 1','FontSize',18);
grid on
xlim([10 30e6]);
figure('Name','Stage 2');
%bode(Ga*Gb*Gc*sys,options);
bode(sys,options);
legend('Stages 2','FontSize',18);
grid on
xlim([10 30e6]);
    end
figure('Name','Stage 2');
%bode(Ga*Gb*Gc*sys,options);
bode(Gb,options);
legend('Stages 3','FontSize',18);
grid on
xlim([10 30e6]);
end

Vm=5;
wo=1e6;
La=1e-6;
Ca=1/La/wo^2;
Ca=0.99e-6;
wo=1/(La*Ca)^0.5;
Vin=10;

if (0)
Rx=3000;
Lx=200e-6;
Zxx=s*Lx+Rx;
Cy=2e-6;
Ry=50;
Zyy=Ry+1/(s*Cy);
Rs=Zxx*Zyy/(Zxx+Zyy);
end

if (0)
Rx=0;
Cabc=8e-6;
Rabc=5;
Zabc=Rabc+1/(s*Cabc);
Zhhh=Zabc*Rx/(Zabc+Rx);
Lx=500e-3;
Zxx=s*Lx+Zhhh;
Cy=4.7e-3;
Ry=50;
Zyy=Ry+1/(s*Cy);
Rsss=Zxx*Zyy/(Zxx+Zyy);
end

Rs=50;
Zo=(La/Ca)^0.5;

Lf=5.6e-6;
RLf=7.5 ;
Cf=60e-9;
Cf1=4e-9;
RCf=4;
Csh=0.1e-6;
Zsh=1/s/Csh; 
Z1=s*Lf*RLf/(s*Lf+RLf)+Rs;
Z2=(1/s/Cf+RCf);
Zs=Z1*Z2/(Z1+Z2);

Z1a=1/(s*Cf)+RCf;
Z1b=1/(s*Cf1);
Z11=Z1a*Z1b/(Z1a+Z1b);

Z2a=s*Lf*RLf/(s*Lf+RLf);
Z22=Z2a+Rs;

Zss=Z11*Z22/(Z11+Z22);
Ztemp=(s^2*La*Ca+1)/(s^2*La*Ca+s*Ca*Zss+1)

Aol=(Z11/(Z11+Z22))*Ztemp;


Qs=Zo/Zs;

H1=(Vin*s*wo*(Cf*RCf*s + 1)*(RLf*Rs + Lf*RLf*s + Lf*Rs*s))/(Lf*s^3*(La/Ca)^(1/2) + RLf*s^2*(La/Ca)^(1/2) + RLf*wo^2*(La/Ca)^(1/2) + Lf*RLf*s^2*wo + Lf*Rs*s^2*wo + Lf*s*wo^2*(La/Ca)^(1/2) + RLf*Rs*s*wo + Cf*Lf*RCf*s^4*(La/Ca)^(1/2) + Cf*Lf*RLf*s^4*(La/Ca)^(1/2) + Cf*Lf*Rs*s^4*(La/Ca)^(1/2) + Cf*RCf*RLf*s^3*(La/Ca)^(1/2) + Cf*RLf*Rs*s^3*(La/Ca)^(1/2) + Cf*RCf*RLf*s*wo^2*(La/Ca)^(1/2) + Cf*RLf*Rs*s*wo^2*(La/Ca)^(1/2) + Cf*Lf*RCf*s^2*wo^2*(La/Ca)^(1/2) + Cf*Lf*RLf*s^2*wo^2*(La/Ca)^(1/2) + Cf*Lf*Rs*s^2*wo^2*(La/Ca)^(1/2) + Cf*Lf*RCf*RLf*s^3*wo + Cf*Lf*RCf*Rs*s^3*wo + Cf*RCf*RLf*Rs*s^2*wo);
H2=(Vin*s*(Cx*R1*s + 1)*(Cf*RCf*s + 1)*(Ca*La)^(1/2)*(RLf*Rs + Lf*RLf*s + Lf*Rs*s))/(RLf*(La/Ca)^(1/2) + Lf*s*(La/Ca)^(1/2) + Lf*RLf*s^2*(Ca*La)^(1/2) + Lf*Rs*s^2*(Ca*La)^(1/2) + RLf*Rs*s*(Ca*La)^(1/2) + Cx*R1*RLf*s*(La/Ca)^(1/2) + Cf*RCf*RLf*s*(La/Ca)^(1/2) + Cf*RLf*Rs*s*(La/Ca)^(1/2) + Cx*RLf*Rs*s*(La/Ca)^(1/2) + Ca*La*Lf*s^3*(La/Ca)^(1/2) + Cx*Lf*R1*s^2*(La/Ca)^(1/2) + Ca*La*RLf*s^2*(La/Ca)^(1/2) + Cf*Lf*RCf*s^2*(La/Ca)^(1/2) + Cf*Lf*RLf*s^2*(La/Ca)^(1/2) + Cx*Lf*RLf*s^2*(La/Ca)^(1/2) + Cf*Lf*Rs*s^2*(La/Ca)^(1/2) + Cx*Lf*Rs*s^2*(La/Ca)^(1/2) + Cx*Lf*R1*RLf*s^3*(Ca*La)^(1/2) + Cx*Lf*R1*Rs*s^3*(Ca*La)^(1/2) + Cf*Lf*RCf*RLf*s^3*(Ca*La)^(1/2) + Cf*Lf*RCf*Rs*s^3*(Ca*La)^(1/2) + Cx*R1*RLf*Rs*s^2*(Ca*La)^(1/2) + Cf*RCf*RLf*Rs*s^2*(Ca*La)^(1/2) + Ca*Cx*La*Lf*R1*s^4*(La/Ca)^(1/2) + Ca*Cf*La*Lf*RCf*s^4*(La/Ca)^(1/2) + Ca*Cf*La*Lf*RLf*s^4*(La/Ca)^(1/2) + Ca*Cx*La*Lf*RLf*s^4*(La/Ca)^(1/2) + Ca*Cf*La*Lf*Rs*s^4*(La/Ca)^(1/2) + Ca*Cx*La*Lf*Rs*s^4*(La/Ca)^(1/2) + Ca*Cx*La*R1*RLf*s^3*(La/Ca)^(1/2) + Cf*Cx*Lf*R1*RCf*s^3*(La/Ca)^(1/2) + Cf*Cx*Lf*R1*RLf*s^3*(La/Ca)^(1/2) + Cf*Cx*Lf*R1*Rs*s^3*(La/Ca)^(1/2) + Ca*Cf*La*RCf*RLf*s^3*(La/Ca)^(1/2) + Cf*Cx*Lf*RCf*RLf*s^3*(La/Ca)^(1/2) + Ca*Cf*La*RLf*Rs*s^3*(La/Ca)^(1/2) + Ca*Cx*La*RLf*Rs*s^3*(La/Ca)^(1/2) + Cf*Cx*Lf*RCf*Rs*s^3*(La/Ca)^(1/2) + Cf*Cx*R1*RCf*RLf*s^2*(La/Ca)^(1/2) + Cf*Cx*R1*RLf*Rs*s^2*(La/Ca)^(1/2) + Cf*Cx*RCf*RLf*Rs*s^2*(La/Ca)^(1/2) + Cf*Cx*Lf*R1*RCf*RLf*s^4*(Ca*La)^(1/2) + Cf*Cx*Lf*R1*RCf*Rs*s^4*(Ca*La)^(1/2) + Cf*Cx*R1*RCf*RLf*Rs*s^3*(Ca*La)^(1/2) + Ca*Cf*Cx*La*Lf*R1*RCf*s^5*(La/Ca)^(1/2) + Ca*Cf*Cx*La*Lf*R1*RLf*s^5*(La/Ca)^(1/2) + Ca*Cf*Cx*La*Lf*R1*Rs*s^5*(La/Ca)^(1/2) + Ca*Cf*Cx*La*Lf*RCf*RLf*s^5*(La/Ca)^(1/2) + Ca*Cf*Cx*La*Lf*RCf*Rs*s^5*(La/Ca)^(1/2) + Ca*Cf*Cx*La*R1*RCf*RLf*s^4*(La/Ca)^(1/2) + Ca*Cf*Cx*La*R1*RLf*Rs*s^4*(La/Ca)^(1/2) + Ca*Cf*Cx*La*RCf*RLf*Rs*s^4*(La/Ca)^(1/2))
H3=(Vin*s*(Cx*R1*s + 1)*(Cf*RCf*s + 1)*(Ca*La)^(1/2)*(RLf*Rs + Lf*RLf*s + Lf*Rs*s))/(RLf*(La/Ca)^(1/2) + Lf*s*(La/Ca)^(1/2) + Lf*RLf*s^2*(Ca*La)^(1/2) + Lf*Rs*s^2*(Ca*La)^(1/2) + RLf*Rs*s*(Ca*La)^(1/2) + Cx*R1*RLf*s*(La/Ca)^(1/2) + Cf*RCf*RLf*s*(La/Ca)^(1/2) + Cf*RLf*Rs*s*(La/Ca)^(1/2) + Cf1*RLf*Rs*s*(La/Ca)^(1/2) + Cx*RLf*Rs*s*(La/Ca)^(1/2) + Ca*La*Lf*s^3*(La/Ca)^(1/2) + Cx*Lf*R1*s^2*(La/Ca)^(1/2) + Ca*La*RLf*s^2*(La/Ca)^(1/2) + Cf*Lf*RCf*s^2*(La/Ca)^(1/2) + Cf*Lf*RLf*s^2*(La/Ca)^(1/2) + Cf1*Lf*RLf*s^2*(La/Ca)^(1/2) + Cx*Lf*RLf*s^2*(La/Ca)^(1/2) + Cf*Lf*Rs*s^2*(La/Ca)^(1/2) + Cf1*Lf*Rs*s^2*(La/Ca)^(1/2) + Cx*Lf*Rs*s^2*(La/Ca)^(1/2) + Cx*Lf*R1*RLf*s^3*(Ca*La)^(1/2) + Cx*Lf*R1*Rs*s^3*(Ca*La)^(1/2) + Cf*Lf*RCf*RLf*s^3*(Ca*La)^(1/2) + Cf*Lf*RCf*Rs*s^3*(Ca*La)^(1/2) + Cx*R1*RLf*Rs*s^2*(Ca*La)^(1/2) + Cf*RCf*RLf*Rs*s^2*(Ca*La)^(1/2) + Ca*Cx*La*Lf*R1*s^4*(La/Ca)^(1/2) + Ca*Cf*La*Lf*RCf*s^4*(La/Ca)^(1/2) + Ca*Cf*La*Lf*RLf*s^4*(La/Ca)^(1/2) + Ca*Cf1*La*Lf*RLf*s^4*(La/Ca)^(1/2) + Ca*Cx*La*Lf*RLf*s^4*(La/Ca)^(1/2) + Ca*Cf*La*Lf*Rs*s^4*(La/Ca)^(1/2) + Ca*Cf1*La*Lf*Rs*s^4*(La/Ca)^(1/2) + Ca*Cx*La*Lf*Rs*s^4*(La/Ca)^(1/2) + Ca*Cx*La*R1*RLf*s^3*(La/Ca)^(1/2) + Cf*Cx*Lf*R1*RCf*s^3*(La/Ca)^(1/2) + Cf*Cx*Lf*R1*RLf*s^3*(La/Ca)^(1/2) + Cf1*Cx*Lf*R1*RLf*s^3*(La/Ca)^(1/2) + Cf*Cx*Lf*R1*Rs*s^3*(La/Ca)^(1/2) + Cf1*Cx*Lf*R1*Rs*s^3*(La/Ca)^(1/2) + Ca*Cf*La*RCf*RLf*s^3*(La/Ca)^(1/2) + Cf*Cf1*Lf*RCf*RLf*s^3*(La/Ca)^(1/2) + Cf*Cx*Lf*RCf*RLf*s^3*(La/Ca)^(1/2) + Ca*Cf*La*RLf*Rs*s^3*(La/Ca)^(1/2) + Ca*Cf1*La*RLf*Rs*s^3*(La/Ca)^(1/2) + Cf*Cf1*Lf*RCf*Rs*s^3*(La/Ca)^(1/2) + Ca*Cx*La*RLf*Rs*s^3*(La/Ca)^(1/2) + Cf*Cx*Lf*RCf*Rs*s^3*(La/Ca)^(1/2) + Cf*Cx*R1*RCf*RLf*s^2*(La/Ca)^(1/2) + Cf*Cx*R1*RLf*Rs*s^2*(La/Ca)^(1/2) + Cf1*Cx*R1*RLf*Rs*s^2*(La/Ca)^(1/2) + Cf*Cf1*RCf*RLf*Rs*s^2*(La/Ca)^(1/2) + Cf*Cx*RCf*RLf*Rs*s^2*(La/Ca)^(1/2) + Cf*Cx*Lf*R1*RCf*RLf*s^4*(Ca*La)^(1/2) + Cf*Cx*Lf*R1*RCf*Rs*s^4*(Ca*La)^(1/2) + Cf*Cx*R1*RCf*RLf*Rs*s^3*(Ca*La)^(1/2) + Ca*Cf*Cx*La*Lf*R1*RCf*s^5*(La/Ca)^(1/2) + Ca*Cf*Cx*La*Lf*R1*RLf*s^5*(La/Ca)^(1/2) + Ca*Cf1*Cx*La*Lf*R1*RLf*s^5*(La/Ca)^(1/2) + Ca*Cf*Cx*La*Lf*R1*Rs*s^5*(La/Ca)^(1/2) + Ca*Cf1*Cx*La*Lf*R1*Rs*s^5*(La/Ca)^(1/2) + Ca*Cf*Cf1*La*Lf*RCf*RLf*s^5*(La/Ca)^(1/2) + Ca*Cf*Cx*La*Lf*RCf*RLf*s^5*(La/Ca)^(1/2) + Ca*Cf*Cf1*La*Lf*RCf*Rs*s^5*(La/Ca)^(1/2) + Ca*Cf*Cx*La*Lf*RCf*Rs*s^5*(La/Ca)^(1/2) + Ca*Cf*Cx*La*R1*RCf*RLf*s^4*(La/Ca)^(1/2) + Cf*Cf1*Cx*Lf*R1*RCf*RLf*s^4*(La/Ca)^(1/2) + Ca*Cf*Cx*La*R1*RLf*Rs*s^4*(La/Ca)^(1/2) + Ca*Cf1*Cx*La*R1*RLf*Rs*s^4*(La/Ca)^(1/2) + Cf*Cf1*Cx*Lf*R1*RCf*Rs*s^4*(La/Ca)^(1/2) + Ca*Cf*Cf1*La*RCf*RLf*Rs*s^4*(La/Ca)^(1/2) + Ca*Cf*Cx*La*RCf*RLf*Rs*s^4*(La/Ca)^(1/2) + Cf*Cf1*Cx*R1*RCf*RLf*Rs*s^3*(La/Ca)^(1/2) + Ca*Cf*Cf1*Cx*La*Lf*R1*RCf*RLf*s^6*(La/Ca)^(1/2) + Ca*Cf*Cf1*Cx*La*Lf*R1*RCf*Rs*s^6*(La/Ca)^(1/2) + Ca*Cf*Cf1*Cx*La*R1*RCf*RLf*Rs*s^5*(La/Ca)^(1/2));
Rs=30;
H4=(Vin*s*(Cx*R1*s + 1)*(Cf*RCf*s + 1)*(Ca*La)^(1/2)*(RLf*Rs + Lf*RLf*s + Lf*Rs*s))/(RLf*(La/Ca)^(1/2) + Lf*s*(La/Ca)^(1/2) + Lf*RLf*s^2*(Ca*La)^(1/2) + Lf*Rs*s^2*(Ca*La)^(1/2) + RLf*Rs*s*(Ca*La)^(1/2) + Cx*R1*RLf*s*(La/Ca)^(1/2) + Cf*RCf*RLf*s*(La/Ca)^(1/2) + Cf*RLf*Rs*s*(La/Ca)^(1/2) + Cf1*RLf*Rs*s*(La/Ca)^(1/2) + Cx*RLf*Rs*s*(La/Ca)^(1/2) + Ca*La*Lf*s^3*(La/Ca)^(1/2) + Cx*Lf*R1*s^2*(La/Ca)^(1/2) + Ca*La*RLf*s^2*(La/Ca)^(1/2) + Cf*Lf*RCf*s^2*(La/Ca)^(1/2) + Cf*Lf*RLf*s^2*(La/Ca)^(1/2) + Cf1*Lf*RLf*s^2*(La/Ca)^(1/2) + Cx*Lf*RLf*s^2*(La/Ca)^(1/2) + Cf*Lf*Rs*s^2*(La/Ca)^(1/2) + Cf1*Lf*Rs*s^2*(La/Ca)^(1/2) + Cx*Lf*Rs*s^2*(La/Ca)^(1/2) + Cx*Lf*R1*RLf*s^3*(Ca*La)^(1/2) + Cx*Lf*R1*Rs*s^3*(Ca*La)^(1/2) + Cf*Lf*RCf*RLf*s^3*(Ca*La)^(1/2) + Cf*Lf*RCf*Rs*s^3*(Ca*La)^(1/2) + Cx*R1*RLf*Rs*s^2*(Ca*La)^(1/2) + Cf*RCf*RLf*Rs*s^2*(Ca*La)^(1/2) + Ca*Cx*La*Lf*R1*s^4*(La/Ca)^(1/2) + Ca*Cf*La*Lf*RCf*s^4*(La/Ca)^(1/2) + Ca*Cf*La*Lf*RLf*s^4*(La/Ca)^(1/2) + Ca*Cf1*La*Lf*RLf*s^4*(La/Ca)^(1/2) + Ca*Cx*La*Lf*RLf*s^4*(La/Ca)^(1/2) + Ca*Cf*La*Lf*Rs*s^4*(La/Ca)^(1/2) + Ca*Cf1*La*Lf*Rs*s^4*(La/Ca)^(1/2) + Ca*Cx*La*Lf*Rs*s^4*(La/Ca)^(1/2) + Ca*Cx*La*R1*RLf*s^3*(La/Ca)^(1/2) + Cf*Cx*Lf*R1*RCf*s^3*(La/Ca)^(1/2) + Cf*Cx*Lf*R1*RLf*s^3*(La/Ca)^(1/2) + Cf1*Cx*Lf*R1*RLf*s^3*(La/Ca)^(1/2) + Cf*Cx*Lf*R1*Rs*s^3*(La/Ca)^(1/2) + Cf1*Cx*Lf*R1*Rs*s^3*(La/Ca)^(1/2) + Ca*Cf*La*RCf*RLf*s^3*(La/Ca)^(1/2) + Cf*Cf1*Lf*RCf*RLf*s^3*(La/Ca)^(1/2) + Cf*Cx*Lf*RCf*RLf*s^3*(La/Ca)^(1/2) + Ca*Cf*La*RLf*Rs*s^3*(La/Ca)^(1/2) + Ca*Cf1*La*RLf*Rs*s^3*(La/Ca)^(1/2) + Cf*Cf1*Lf*RCf*Rs*s^3*(La/Ca)^(1/2) + Ca*Cx*La*RLf*Rs*s^3*(La/Ca)^(1/2) + Cf*Cx*Lf*RCf*Rs*s^3*(La/Ca)^(1/2) + Cf*Cx*R1*RCf*RLf*s^2*(La/Ca)^(1/2) + Cf*Cx*R1*RLf*Rs*s^2*(La/Ca)^(1/2) + Cf1*Cx*R1*RLf*Rs*s^2*(La/Ca)^(1/2) + Cf*Cf1*RCf*RLf*Rs*s^2*(La/Ca)^(1/2) + Cf*Cx*RCf*RLf*Rs*s^2*(La/Ca)^(1/2) + Cf*Cx*Lf*R1*RCf*RLf*s^4*(Ca*La)^(1/2) + Cf*Cx*Lf*R1*RCf*Rs*s^4*(Ca*La)^(1/2) + Cf*Cx*R1*RCf*RLf*Rs*s^3*(Ca*La)^(1/2) + Ca*Cf*Cx*La*Lf*R1*RCf*s^5*(La/Ca)^(1/2) + Ca*Cf*Cx*La*Lf*R1*RLf*s^5*(La/Ca)^(1/2) + Ca*Cf1*Cx*La*Lf*R1*RLf*s^5*(La/Ca)^(1/2) + Ca*Cf*Cx*La*Lf*R1*Rs*s^5*(La/Ca)^(1/2) + Ca*Cf1*Cx*La*Lf*R1*Rs*s^5*(La/Ca)^(1/2) + Ca*Cf*Cf1*La*Lf*RCf*RLf*s^5*(La/Ca)^(1/2) + Ca*Cf*Cx*La*Lf*RCf*RLf*s^5*(La/Ca)^(1/2) + Ca*Cf*Cf1*La*Lf*RCf*Rs*s^5*(La/Ca)^(1/2) + Ca*Cf*Cx*La*Lf*RCf*Rs*s^5*(La/Ca)^(1/2) + Ca*Cf*Cx*La*R1*RCf*RLf*s^4*(La/Ca)^(1/2) + Cf*Cf1*Cx*Lf*R1*RCf*RLf*s^4*(La/Ca)^(1/2) + Ca*Cf*Cx*La*R1*RLf*Rs*s^4*(La/Ca)^(1/2) + Ca*Cf1*Cx*La*R1*RLf*Rs*s^4*(La/Ca)^(1/2) + Cf*Cf1*Cx*Lf*R1*RCf*Rs*s^4*(La/Ca)^(1/2) + Ca*Cf*Cf1*La*RCf*RLf*Rs*s^4*(La/Ca)^(1/2) + Ca*Cf*Cx*La*RCf*RLf*Rs*s^4*(La/Ca)^(1/2) + Cf*Cf1*Cx*R1*RCf*RLf*Rs*s^3*(La/Ca)^(1/2) + Ca*Cf*Cf1*Cx*La*Lf*R1*RCf*RLf*s^6*(La/Ca)^(1/2) + Ca*Cf*Cf1*Cx*La*Lf*R1*RCf*Rs*s^6*(La/Ca)^(1/2) + Ca*Cf*Cf1*Cx*La*R1*RCf*RLf*Rs*s^5*(La/Ca)^(1/2));

%H1=(Vin*s*(Cx*R1*s + 1)*(Cf*RCf*s + 1)*(Ca*La)^(1/2)*(RLf*Rs + Lf*RLf*s + Lf*Rs*s))/(RLf*(La/Ca)^(1/2) + Lf*s*(La/Ca)^(1/2) + Lf*RLf*s^2*(Ca*La)^(1/2) + Lf*Rs*s^2*(Ca*La)^(1/2) + RLf*Rs*s*(Ca*La)^(1/2) + Cx*R1*RLf*s*(La/Ca)^(1/2) + Cf*RCf*RLf*s*(La/Ca)^(1/2) + Cf*RLf*Rs*s*(La/Ca)^(1/2) + Cx*RLf*Rs*s*(La/Ca)^(1/2) + Ca*La*Lf*s^3*(La/Ca)^(1/2) + Cx*Lf*R1*s^2*(La/Ca)^(1/2) + Ca*La*RLf*s^2*(La/Ca)^(1/2) + Cf*Lf*RCf*s^2*(La/Ca)^(1/2) + Cf*Lf*RLf*s^2*(La/Ca)^(1/2) + Cx*Lf*RLf*s^2*(La/Ca)^(1/2) + Cf*Lf*Rs*s^2*(La/Ca)^(1/2) + Cx*Lf*Rs*s^2*(La/Ca)^(1/2) + Cx*Lf*R1*RLf*s^3*(Ca*La)^(1/2) + Cx*Lf*R1*Rs*s^3*(Ca*La)^(1/2) + Cf*Lf*RCf*RLf*s^3*(Ca*La)^(1/2) + Cf*Lf*RCf*Rs*s^3*(Ca*La)^(1/2) + Cx*R1*RLf*Rs*s^2*(Ca*La)^(1/2) + Cf*RCf*RLf*Rs*s^2*(Ca*La)^(1/2) + Ca*Cx*La*Lf*R1*s^4*(La/Ca)^(1/2) + Ca*Cf*La*Lf*RCf*s^4*(La/Ca)^(1/2) + Ca*Cf*La*Lf*RLf*s^4*(La/Ca)^(1/2) + Ca*Cx*La*Lf*RLf*s^4*(La/Ca)^(1/2) + Ca*Cf*La*Lf*Rs*s^4*(La/Ca)^(1/2) + Ca*Cx*La*Lf*Rs*s^4*(La/Ca)^(1/2) + Ca*Cx*La*R1*RLf*s^3*(La/Ca)^(1/2) + Cf*Cx*Lf*R1*RCf*s^3*(La/Ca)^(1/2) + Cf*Cx*Lf*R1*RLf*s^3*(La/Ca)^(1/2) + Cf*Cx*Lf*R1*Rs*s^3*(La/Ca)^(1/2) + Ca*Cf*La*RCf*RLf*s^3*(La/Ca)^(1/2) + Cf*Cx*Lf*RCf*RLf*s^3*(La/Ca)^(1/2) + Ca*Cf*La*RLf*Rs*s^3*(La/Ca)^(1/2) + Ca*Cx*La*RLf*Rs*s^3*(La/Ca)^(1/2) + Cf*Cx*Lf*RCf*Rs*s^3*(La/Ca)^(1/2) + Cf*Cx*R1*RCf*RLf*s^2*(La/Ca)^(1/2) + Cf*Cx*R1*RLf*Rs*s^2*(La/Ca)^(1/2) + Cf*Cx*RCf*RLf*Rs*s^2*(La/Ca)^(1/2) + Cf*Cx*Lf*R1*RCf*RLf*s^4*(Ca*La)^(1/2) + Cf*Cx*Lf*R1*RCf*Rs*s^4*(Ca*La)^(1/2) + Cf*Cx*R1*RCf*RLf*Rs*s^3*(Ca*La)^(1/2) + Ca*Cf*Cx*La*Lf*R1*RCf*s^5*(La/Ca)^(1/2) + Ca*Cf*Cx*La*Lf*R1*RLf*s^5*(La/Ca)^(1/2) + Ca*Cf*Cx*La*Lf*R1*Rs*s^5*(La/Ca)^(1/2) + Ca*Cf*Cx*La*Lf*RCf*RLf*s^5*(La/Ca)^(1/2) + Ca*Cf*Cx*La*Lf*RCf*Rs*s^5*(La/Ca)^(1/2) + Ca*Cf*Cx*La*R1*RCf*RLf*s^4*(La/Ca)^(1/2) + Ca*Cf*Cx*La*R1*RLf*Rs*s^4*(La/Ca)^(1/2) + Ca*Cf*Cx*La*RCf*RLf*Rs*s^4*(La/Ca)^(1/2));


[z01,gain01]=zero(H1);
p01=pole(H1);
z01=abs(z01)
p01=abs(p01)

[z02,gain02]=zero(H3);
p02=pole(H3);
z02=abs(z02)
p02=abs(p02)

%if (1)
%figure('Name','Bode plot regarding to different loads Rs');
%bode(H1/Vm,H2/Vm,H3/Vm, options)

%bode(H1*G4*sys,options)
%bode(H1,H1*exp(-s*35E-9), H1*exp(-s*20E-9),H1*exp(-s*25E-9),options)
%bode(H1*G4*sys,H1*G4*sys*exp(-s*22E-9),options)
%legend('No delay','22ns delay','FontSize',18);

%bode(G7*(0.8e3/Zav)*H1/Vm,options);
%bode(Ga*Gb*sys*Gc*H1/Vm,Ga*Gb*sys*H1/Vm,options);
%bode(Ga*Gb*sys*H1/Vm,Ga*Gb*sys*H3/Vm,options);


Rx=47;
Cx=1/(2*pi*1e6*9)/Rx;
Cy=1/(2*pi*1e6*500)/Rx;
Cz=1/(2*pi*600e3)/Rx/2;
Cw=1/(2*pi*600e3)/Rx/2.5;
%*(1+s*Rx*Cx)*(1+s*Rx*Cy)/(1+s*Rx*Cz)/(1+s*Rx*Cw)
%bode((Ga*Gb*sys*H3/Vm)*(1+s*(2*pi*0.5e-6))/(1+s*(2*pi*1e-6)),(Ga*Gb*sys*H3/Vm)*exp(-s*22E-9)*(1+s*(2*pi*0.5e-6))/(1+s*(2*pi*1e-6)),options);
%bode((1*Ga*Gb*Gc*sys*H3/Vm),(1*Ga*Gb*Gc*sys*H3/Vm)*exp(-s*22E-9),options);


%bode((1*Ga*Gb*Gc*sys*H3/Vm)*exp(-s*22E-9),(1*Ga*Gb*Gc*sys*H3/Vm)*exp(-s*22E-9),options);

%bode((1*Ga*Gb*Gc*sys*H3/Vm)*exp(-s*22E-9),(1*Ga*Gb*Gc*sys*H3/Vm)*exp(-s*22E-9),options);

if (0)
figure('Name','1');
bode((Ga*Gb*Gc*sys*H3/Vm),options);
xlim([50 30e6]);
grid on
end

[mag,phase,wout] = bode((Ga*Gb*Gc*sys*H3/Vm),{2*pi*50 2*pi*30e6});
Mag=20*log10(mag(:));
phase1 = squeeze(phase);
wout1=wout/2/pi;
figure('Name','Comparson between Zof vs. Zic');
%semilogx(wout,Mag,'b','LineWidth',2.4);
semilogx(wout1,Mag,'Color' , cyan_color,'LineWidth',2.4);

xlim([50 30e6]);
hold on
%bode(Aol,Aol/(1+1*Ga*Gb*Gc*sys*H3/Vm),options);

%bode((Ga*Gb*sys*H3/Vm),(Ga*Gb*sys*H3/Vm)*exp(-s*22E-9),options);
%legend('T with LISN','T with 50Ohm','FontSize',18);
%xlim([50 30e6]);
%grid on
if (0)
figure('Name','Bode plot regarding to different loads Rs');
bode((0.1e3/Zav),options);
legend('Gvd','FontSize',18);
%xlim([1 30e6]); 
xlim([50 30e6]);
%legend('No delay','5ns delay','20ns delay','25ns delay','FontSize',18);
%legend('H1','T(s) Rs=50\Omega','FontSize',18);
%legend('H1(s)', 'H2(s)','H3(s)','FontSize',18);
%legend('Loop Gain T(s)','FontSize',18);
grid on
end
%end
%figure('Name','1');
if (0)
T = readtable('Trace192.csv','NumHeaderLines',1);
X(:)=squeeze(T(:,1));
%X=logspace
Y(:)=squeeze(T(:,2));
plot(X,Y)
end
if (0)
tbl = readtable('Trace192.csv');
head(tbl,3)
stackedplot(tbl,{'Mag'})
end

[mag,phase,wout] = bode((Ga*Gb*Gc*sys*H3/Vm)*exp(-s*22E-9),{2*pi*50 2*pi*30e6});
Mag=20*log10(mag(:));
phase2 = squeeze(phase);
wout2=wout/2/pi;
semilogx(wout2,Mag,'Color' ,yellow_color,'LineWidth',2.4);

data = csvread('Trace192.csv',2); % Read the data
t = data(:,1) ; 
mag_experiment = smooth(data(:,2)) ;
plot(t,mag_experiment,'Color' ,magenta_color,'LineWidth',2.4);
set(gca,'FontSize',13)
label_h=ylabel('$Magnitude \ [dB]$','Interpreter','latex','FontSize',18,'HorizontalAlignment','center');
set(label_h,'rotation',90);
%legend('Theoretical Analysis','Experimental Result','Location','southeast','FontSize',20);
%legend('boxoff')
grid on

figure('Name','Comparson between Zof vs. Zic');
semilogx(wout1,phase1,'Color' , cyan_color,'LineWidth',2.4);
xlim([50 30e6]);
hold on
semilogx(wout2,phase2,'Color' , yellow_color,'LineWidth',2.4);
xlim([50 30e6]);
hold on

data = csvread('Trace193.csv',2); % Read the data
t = data(:,1) ; 
phase_experiment = smooth(data(:,2)+180) ;
plot(t,phase_experiment,'Color' ,magenta_color,'LineWidth',2.4);
set(gca,'FontSize',13)
label_x=xlabel('$Frequency [Hz]$','Interpreter','latex','FontSize',18,'HorizontalAlignment','center');
set(label_x,'rotation',0);
label_h=ylabel('$Phase \ [{^\circ}]$','Interpreter','latex','FontSize',18,'HorizontalAlignment','center');
set(label_h,'rotation',90);
legend('Analysis with{\it t_{d}}=0','Analysis with{\it t_{d}}=22ns','Experimental Result','Location','southeast','FontSize',18);
legend('boxoff')
grid on


[mag,phase,wout] = bode((Ga*Gb*Gc*sys*H3/Vm*2.8),{2*pi*50 2*pi*30e6});
Mag=20*log10(mag(:));
phase1 = squeeze(phase);
wout1=wout/2/pi;
figure('Name','Loop-Gain (Magnitude)');
semilogx(wout1,Mag,'Color' , cyan_color,'LineWidth',2.4);
xlim([50 30e6]);
hold on

[mag,phase,wout] = bode((Ga*Gb*Gc*sys*H3/Vm*2.8)*exp(-s*22E-9),{2*pi*50 2*pi*30e6});
Mag=20*log10(mag(:));
phase2 = squeeze(phase);
wout2=wout/2/pi;
semilogx(wout2,Mag,'Color' , magenta_color,'LineWidth',2.4);
set(gca,'FontSize',13)
label_h=ylabel('$Magnitude \ [dB]$','Interpreter','latex','FontSize',18,'HorizontalAlignment','center');
set(label_h,'rotation',90);
%set(gca,'FontSize',13)
%legend('\it T_{s}','\it T_{s,d}','Location','southeast','FontSize',20);
%legend('boxoff')
grid on
hold off

figure('Name','Loop-Gain (Phase)');
%semilogx(wout1,phase1,'g','LineWidth',2.2);
semilogx(wout1,phase1,'Color' , cyan_color,'LineWidth',2.4);
xlim([50 30e6]);
hold on
%semilogx(wout2,phase2,'r','LineWidth',2.2);
semilogx(wout2,phase2,'Color' , magenta_color,'LineWidth',2.4);
set(gca,'FontSize',13)
label_x=xlabel('$Frequency [Hz]$','Interpreter','latex','FontSize',18,'HorizontalAlignment','center');
set(label_x,'rotation',0);
label_h=ylabel('$Phase \ [{^\circ}]$','Interpreter','latex','FontSize',18,'HorizontalAlignment','center');
set(label_h,'rotation',90);
legend('\it T_{s}','\it T_{s,d}','Location','southeast','FontSize',20);
legend('boxoff')
grid on
hold off

%(Ga*Gb*Gc*sys*H3/Vm*2.8)
[mag,phase,wout] = bode(Ga,{2*pi*50 2*pi*30e6});
Mag=20*log10(mag(:));
phase1 = squeeze(phase);
wout1=wout/2/pi;
figure('Name','Loop-Gain (Magnitude)');
semilogx(wout1,Mag,'g','LineWidth',2.2);
xlim([50 30e6]);
hold on

[mag,phase,wout] = bode(sys,{2*pi*50 2*pi*30e6});
Mag=20*log10(mag(:));
phase2 = squeeze(phase);
wout2=wout/2/pi;
semilogx(wout2,Mag,'k','LineWidth',2.2);

[mag,phase,wout] = bode(Gb*Gc,{2*pi*50 2*pi*30e6});
Mag=20*log10(mag(:));
phase3 = squeeze(phase);
wout3=wout/2/pi;
semilogx(wout3,Mag,'b','LineWidth',2.2);

[mag,phase,wout] = bode(Ga*Gb*Gc*sys/Vm,{2*pi*50 2*pi*30e6});
Mag=20*log10(mag(:));
phase4 = squeeze(phase);
wout4=wout/2/pi;
semilogx(wout4,Mag,'r','LineWidth',2.2);
label_h=ylabel('$Magnitude \ [dB]$','Interpreter','latex','FontSize',18,'HorizontalAlignment','center');
set(label_h,'rotation',90);
legend('\it G_{c1}','\it G_{c2}','\it G_{c3}','\it G_{c}','Location','southeast','FontSize',15);
legend('boxoff')
grid on
grid on
hold off


figure('Name','Loop-Gain (Phase)');
semilogx(wout1,phase1,'g','LineWidth',2.2);
xlim([50 30e6]);
hold on
semilogx(wout2,phase2,'k','LineWidth',2.2);
semilogx(wout3,phase3,'b','LineWidth',2.2);
semilogx(wout4,phase4,'r','LineWidth',2.2);
set(gca,'FontSize',13)
label_x=xlabel('$Frequency [Hz]$','Interpreter','latex','FontSize',18,'HorizontalAlignment','center');
set(label_x,'rotation',0);
label_h=ylabel('$Phase \ [{^\circ}]$','Interpreter','latex','FontSize',18,'HorizontalAlignment','center');
set(label_h,'rotation',90);
legend('\it G_{c1}','\it G_{c2}','\it G_{c3}','\it G_{c}','Location','southeast','FontSize',15);
legend('boxoff')
grid on
hold off


format long
data = csvread('Switchingwaveforms.csv',1); % Read the data
t1 = data(:,2)./1000; 
CH1=data(:,4)./1000;
CH2=data(:,6)./1000;
CH3=data(:,8)./1000;
CH4=data(:,10)./1000;
CH5=data(:,12)./1000;
CH6=data(:,14)./1000;
figure();
plot(t1,CH1,'Color' , black_color,'LineWidth',2.4);
hold on
plot(t1,CH2,'Color' , cyan_color,'LineWidth',2.4);
plot(t1,CH3,'Color' , magenta_color,'LineWidth',2.4);
grid on
ylim([-0.5 5]);
set(gca,'FontSize',13)
label_h=ylabel('$Voltage \ [V]$','Interpreter','latex','FontSize',18,'HorizontalAlignment','center');
set(label_h,'rotation',90);
grid minor

figure();
plot(t1,CH4,'Color' , cyan_color,'LineWidth',2.4);
hold on
plot(t1,CH5,'Color' , magenta_color,'LineWidth',2.4);
ylim([-6.5 18.5]);
set(gca,'FontSize',13)
label_h=ylabel('$Voltage \ [V]$','Interpreter','latex','FontSize',18,'HorizontalAlignment','center');
set(label_h,'rotation',90);
grid minor

figure();
plot(t1,CH6,'Color' , yellow_color,'LineWidth',2.4);
set(gca,'FontSize',13)
ylim([-6 15]);
label_x=xlabel('$Time \ [ns]$','Interpreter','latex','FontSize',18,'HorizontalAlignment','center');
set(label_x,'rotation',0);
label_h=ylabel('$Voltage \ [V]$','Interpreter','latex','FontSize',18,'HorizontalAlignment','center');
set(label_h,'rotation',90);
grid minor


format long
data = csvread('FFTwaveforms.csv',1); % Read the data
t2 = data(:,5)./1e3; 
CH1=data(:,6)./1e3;
CH2=data(:,7)./1e4;
figure();
%plot(t2,CH2,'Color' , yellow_color,'LineWidth',1.5);
plot(t2,CH2,'Color' , cyan_color,'LineWidth',1.5);
ylim([-0.65 0.6]);
set(gca,'FontSize',13)
label_h=ylabel('$I_{conv} \ [A]$','Interpreter','latex','FontSize',18,'HorizontalAlignment','center');
set(label_h,'rotation',90);
grid minor
figure();
plot(t2,CH1,'Color' , magenta_color,'LineWidth',1.5);
ylim([-3 2]);
set(gca,'FontSize',13)
label_x=xlabel('$Time \ [\mu s]$','Interpreter','latex','FontSize',18,'HorizontalAlignment','center');
set(label_x,'rotation',0);
label_h=ylabel('$I_{s} \ [mA]$','Interpreter','latex','FontSize',18,'HorizontalAlignment','center');
set(label_h,'rotation',90);
grid minor

f1 = data(1:190002,12)/1e9;
CH3=data(1:190002,13)/1e6;
f2 = data(1:190002,14)/1e9;
CH4=data(1:190002,15)/1e6;
figure();
%plot(f2,CH4,'Color' , yellow_color,'LineWidth',1.5);
plot(f2,CH4,'Color' , cyan_color,'LineWidth',1.5);
xlim([0.1 3]);
ylim([-130 20]);
set(gca,'FontSize',13)
label_h=ylabel('$I_{conv} \ [dBmA]$','Interpreter','latex','FontSize',18,'HorizontalAlignment','center');
set(label_h,'rotation',90);
grid minor

figure();
plot(f1,CH3,'Color' , magenta_color,'LineWidth',1.5);
xlim([0.1 3]);
ylim([-160 -40]);
set(gca,'FontSize',13)
label_x=xlabel('$Frequency [MHz]$','Interpreter','latex','FontSize',18,'HorizontalAlignment','center');
set(label_x,'rotation',0);
label_h=ylabel('$I_{s} \ [dBmA]$','Interpreter','latex','FontSize',18,'HorizontalAlignment','center');
set(label_h,'rotation',90);
grid minor