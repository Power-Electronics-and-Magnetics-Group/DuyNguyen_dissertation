clc
clear all

s=tf('s');

alpha = 0.6;
ab=0.1;
m=6;
fmin=400;
wmin=2*pi*fmin;
wmax=wmin/ab^m;
fmax=wmax/(2*pi)

wav=(wmin*wmax)^0.5;

Dr=10;  

C1=0.0018e-6;
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
Rp=50e3+1/(s*1e-6);
%Yp = 1/(Rp+1/(s*Cpp)) + 1/YY; Y = 0;

Yp = 1/(Rp) + 1/YY; Y = 0;
for k = 1:1:length(C)
Y = Y + (s*C(k))/(1+s*C(k)*R(k));
end
Ytot = Y + Yp;
Zav = 1/Ytot;

options = bodeoptions;
options.FreqUnits = 'Hz';
options.Title.FontSize = 14;
options.XLabel.FontSize = 14;
options.YLabel.FontSize = 14;
options.TickLabel.FontSize = 14;


Vm=5;
wo=1e6;
La=1e-6;
Ca=1/La/wo^2;
Ca=0.1e-6;
wo=1/(La*Ca)^0.5;
Vin=10;

Lf=5.6e-6;
RLf=7.5;
Cf=60e-9;
Cf1=4e-9;
RCf=16/4;
Csh=0.1e-6;

Cx=4*330e-9;
R1=7.58e3;

Lx=50e-6;
Zxx=s*Lx;
Cy=0.25e-6;
R50=50;
Zyy=R50+1/(s*Cy);
Rxx=Zxx*Zyy/(Zxx+Zyy);

Z1=s*Lf+Rxx;
Z2=1/s/Cf+RCf;
%Z2=1/s/Cf;
Z2p=1/s/Cf1;
Z22=Z2p*Z2/(Z2p+Z2); 
%Za=Z1*Z2/(Z1+Z2); 

Z3=R1+1/s/Cx;
Ys=1/Z1+1/Z22+1/Z3;

wo=1/(La*Ca)^0.5;
Zo=(La/Ca)^0.5;
Qs=Zo*Ys;
H3=(s*Vin*wo/Qs)/(s^2+s*wo/Qs+wo^2);

%%New 10262022

Lx=50e-6;
Zxx=s*Lx;
Cy=0.25e-6;
R50=50;
Zyy=R50+1/(s*Cy);
Rxx=Zxx*Zyy/(Zxx+Zyy);

Z1=s*Lf+Rxx;
Z2=1/s/Cf+RCf;
%Z2=1/s/Cf;
Z2p=1/s/Cf1;
Z22=Z2p*Z2/(Z2p+Z2); 
%Za=Z1*Z2/(Z1+Z2); 

Do=0.5;
Lo=250e-6;
Co=100e-6;
Ro=533;

Ao=50;
Zin_cl=-(1-Do)^2*Ro*(1-s*Lo/(Ro*(1-Do))+s^2*Lo*Co/((1-Do)^2*Ao))/(1-s*Ro*Co/Ao);
rCo=0.1;
rLo=0.1;
%Zin_cl_ESR=((s*Lo+rLo)*(1+s*(Ro+rCo)*Co)+(1-D)^2*Ro*(1+s*rCo*Co))/(1+s*(Ro+rCo)*Co);
Zin_cl_ESR=-(s^2*(Ro+rCo)*Lo*Co/Ao - s*(Lo + rLo*(Ro+rCo)*Co + (1-D)^2*Ro*rCo*Co)/Ao+(rLo+(1-D)^2*Ro))/(1-s*(Ro+rCo)*Co/Ao);

Z3=R1+1/s/Cx;
Ys=1/Z1+1/Z22+1/Z3+1/Zin_cl_ESR;

wo=1/(La*Ca)^0.5;
Zo=(La/Ca)^0.5;
Qs=Zo*Ys;
H4=(s*Vin*wo/Qs)/(s^2+s*wo/Qs+wo^2);


Vm=5;
wo=1e6;
La=1e-6;
Ca=1/La/wo^2;
Ca=0.1e-6;
wo=1/(La*Ca)^0.5;
Vin=10;

Lf=5.6e-6;
RLf=7.5;
Cf=60e-9;
Cf1=4e-9;
RCf=16/4;
Csh=0.1e-6;

Cx=4*330e-9;
R1=7.58e3;

%Cx=(4/3)*990e-9; % Can change this to change gains
%R1=1/50/Cx;

%%%%%%%%%%% Case 2
Lx=50e-6;
Zxx=s*Lx;
Cy=0.25e-6;
R50=50;
Zyy=R50+1/(s*Cy);
Rxx=Zxx*Zyy/(Zxx+Zyy);

Z1=s*Lf+0;
Z2=1/s/Cf+RCf;
%Z2=1/s/Cf;
Z2p=1/s/Cf1;
Z22=Z2p*Z2/(Z2p+Z2); 
%Za=Z1*Z2/(Z1+Z2); 

Z3=R1+1/s/Cx;
Ys=1/Z1+1/Z22+1/Z3;

wo=1/(La*Ca)^0.5;
Zo=(La/Ca)^0.5;
Qs=Zo*Ys;
H2=(s*Vin*wo/Qs)/(s^2+s*wo/Qs+wo^2);



if (1)
wmin1=50e3*2*pi;
wmin2=100;
wmin3=12e5*2*pi;
wmin4=0.25e7*2*pi;

wkp4= [wmin3 wmin4];
wk4=[wmin1 wmin2];
G8=zpk(-wkp4,-wk4,141000000*wmin1*wmin2/wmin3/wmin4);

add_comp = 2; 

[z01, gain01]=zero(H3);
p01=pole(H3);
z01=abs(z01);
p01=abs(p01);


zeropoints=[wmin3 wmin4];
polepoints=[wmin1 wmin2];


C2=0.047e-9;
R2=1/zeropoints(1)/C2;
%R2=5e2;
R3=1/polepoints(1)/C2-R2 
Cx=1e-6;
R1=1/100/Cx;
%R1=20e3;
zz1=1/R2/C2;
pp1=1/(R2+R3)/C2;
Ga_new=(s*Cx*R3)*(1+s*R2*C2)/(1+s*(R2+R3)*C2)/(1+s*R1*Cx);


if (0)
figure('Name','First Stage');
bode(Ga_new,options);
legend('Ga (new)','FontSize',18);
xlim([10 30e6]);
grid on
end

Caa=0.047e-9;
Raa=1/zeropoints(2)/Caa;
%Raa=2e3;
%Rf=1/polepoints(2)/Caa-Raa
Rf=50e4;
sys1=Rf*(1+s*Raa*Caa)/(1+s*(Rf+Raa)*Caa);
zaa=1/Raa/Caa;
paa=1/(Rf+Raa)/Caa;
sys_new=sys1/Zav;

if (0)
figure('Name','Second Stage');
bode(sys_new,options);
legend('sys (new)','FontSize',18);
xlim([10 30e6]);
grid on
end


C4=20e-9;
R4=1/paa/C4/0.8;
R5=1/polepoints(2)/C4-R4;
C6=4*330e-9;
R6=1/100/C6;
p66=1/R6/C6;
Gb_new=(s*C6*R5)*(1+s*R4*C4)/(1+s*(R4+R5)*C4)/(1+s*R6*C6);


if (0)
figure('Name','3 Stages');
bode(Gb_new*sys_new*Ga_new,options);
legend('3 Stages','FontSize',18);
xlim([10 30e6]);
grid on
end


if (1)
figure
%bode(H2*G8/Zav/Vm*exp(-s*22E-9),1*H3*Ga_new*sys_new*Gb_new*exp(-s*22E-9)/Vm,options);
%bode(Ga_new*sys_new*Gb_new*H2/Vm,1*H3*Ga_new*sys_new*Gb_new/Vm,options);
%bode(H2,H3*G8/Zav/Vm*add_comp,options);
%bode(H3*G8/Zav/Vm*add_comp,Ga_new*sys_new*Gb_new*H3/Vm,options);

bode(H3*G8/Zav/Vm*add_comp,Ga_new*sys_new*Gb_new*H4/Vm,options);

legend('with poles/zeros','With RC and opamps','FontSize',18);
end
end
xlim([10 100e6]);
grid on
set(findall(gcf, 'Type', 'Line'),'LineWidth',2);


figure
%bode(H2*G8/Zav/Vm*exp(-s*22E-9),1*H3*Ga_new*sys_new*Gb_new*exp(-s*22E-9)/Vm,options);
%bode(Ga_new*sys_new*Gb_new*H2/Vm,1*H3*Ga_new*sys_new*Gb_new/Vm,options);
%bode(H2,H3*G8/Zav/Vm*add_comp,options);
%bode(H3*G8/Zav/Vm*add_comp,Ga_new*sys_new*Gb_new*H3/Vm,options);

bode(Ga_new*sys_new*Gb_new*H4/Vm*exp(-s*22E-9),Ga_new*sys_new*Gb_new*H4/Vm*exp(-s*9E-9),3.5*Ga_new*sys_new*Gb_new*H4/Vm*exp(-s*9E-9),options);

legend('T(s) w/ 22ns loop delay','T(s) w/ 9ns loop delay','New T(s) w/ higher BW','FontSize',18);

xlim([10 100e6]);
grid on
set(findall(gcf, 'Type', 'Line'),'LineWidth',2);

