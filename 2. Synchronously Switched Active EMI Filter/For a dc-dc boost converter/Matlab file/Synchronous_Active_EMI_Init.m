%close all
clear all
clc

% dc-dc boost converter
Vs=200;
Vo_bst=400;
D=1-Vs/Vo_bst;
Lbst=250e-6;
Cbst=330e-6;

fsw=150e3;
Tsw=1/fsw;
Po_bst=300 % Norminal output power is 300W
Ro1=Vo_bst^2/Po_bst;
IL2max=(Vs/Lbst)*(D*Tsw);
IL2min_ac=-IL2max/2;
IL2max_ac=+IL2max/2;

t=linspace(0,Tsw,1000);
L_aef=6.3e-6;
C_aef=4.7e-6;
Ron=0;

wr_aef=1/(L_aef*C_aef)^0.5;
a=Ron/2/L_aef;
b=wr_aef;

c2=IL2min_ac;
c1=(IL2max_ac/exp(a*D*Tsw)-c2*cos(wr_aef*D*Tsw))/sin(wr_aef*D*Tsw);
c4=IL2max_ac;
c3=(IL2max_ac/exp(a*Tsw)-c4*cos(wr_aef*Tsw))/sin(wr_aef*Tsw);

iL_bst = [];
iL_aef = [];
cycle = 10;
for i=1:cycle
for k=1:numel(t)
    if ( t(k) <= D*Tsw)
        iL_bst=[iL_bst (Vs/Lbst)*t(k)];
        iL_aef=[iL_aef exp(a*t(k))*(c1*sin(wr_aef*t(k))+c2*cos(wr_aef*t(k)))];
    else
        %iL_bst=[iL_bst (-(Vs-Vo_bst)/Lbst)*(Tsw-t(k))];
        iL_bst=[iL_bst (((Vs-Vo_bst)/Lbst)*t(k) + Vo_bst/Lbst*D*Tsw)];
        iL_aef=[iL_aef exp(a*(t(k)-D*Tsw))*(-c1*sin(wr_aef*(t(k)-D*Tsw))-c2*cos(wr_aef*(t(k)-D*Tsw)))];
    end
end
end
%iL_bst=(Vs/Lbst).*t;
%iL_aef=exp(a.*t).*(c1.*sin(wr_aef.*t)+c2.*cos(wr_aef.*t));

t=linspace(0,cycle*Tsw,cycle*1000);
figure('Name','Plot IL_bst vs. IL_aef');
plot(t,iL_bst,t,iL_aef)
legend('iL boost converter', 'iL active EMI','FontSize',18);
grid on

figure('Name','iL difference');
plot(t,iL_bst-iL_aef-(IL2max_ac-IL2min_ac)/2)
legend('iL diff','FontSize',18);
grid on

