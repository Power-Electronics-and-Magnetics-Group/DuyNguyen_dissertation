clc
clear all

format long
Tsw=6.66e-6; % This frequency is 150kHz
fsw=1/Tsw;
cycle = 20;
%Tsw = 1e-6; % 1MHz
sample = 1000;
t=linspace(0,cycle*Tsw,sample*cycle);

Lo=250e-6;
Ro=0.5;
Vs=200;
Vo=400;
Io=0.2;
D=0.5;
iL_boost = [];
for k=1:numel(t)
    if (mod(t(k),Tsw) <= D*Tsw)
        iL_boost=[iL_boost (Io*exp(-Ro*mod(t(k),Tsw)/Lo) + (Vs/Ro)*(1-exp(-Ro*mod(t(k),Tsw)/Lo)))];
        Io_save=iL_boost(k);
    elseif (mod(t(k),Tsw) < (Tsw))
        iL_boost=[iL_boost (Io_save*exp(-Ro*(mod(t(k),Tsw)-D*Tsw)/Lo) + ((Vs-Vo)/Ro)*(1-exp(-Ro*(mod(t(k),Tsw)-D*Tsw)/Lo)))];
    end  
end
max_iL_boost=max(iL_boost);
min_iL_boost=min(iL_boost);
dc_iL_boost=(max_iL_boost+min_iL_boost)/2; % dc value of dc-dc boost converter

% Currents for AEF filter
Lf= 4.7e-6;
Cf= 10e-6;
Rf=0.1;
wo=1/(Lf*Cf)^0.5;
alpha=Rf/(2*Lf);
damping_factor = alpha/wo;
wd=wo*(1-damping_factor^2)^0.5;

%i_aef = exp(-alpha*t)*(B1*cos(wd*t) + B2*sin(wd*t))
B1 = max_iL_boost-dc_iL_boost;
B2 = ((min_iL_boost-dc_iL_boost)/ exp(-alpha*D*Tsw)-B1*cos(wd*D*Tsw))/sin(wd*D*Tsw);

iL_aef = [];
for k=1:numel(t)
    if (mod(t(k),Tsw) <= D*Tsw)
        iL_aef=[iL_aef (exp(-alpha*mod(t(k),Tsw))*(B1*cos(wd*mod(t(k),Tsw)) + B2*sin(wd*mod(t(k),Tsw))))];
    elseif (mod(t(k),Tsw) < Tsw)
        iL_aef=[iL_aef (exp(-alpha*(mod(t(k),Tsw)-D*Tsw))*(-B1*cos(wd*(mod(t(k),Tsw)-D*Tsw)) + -B2*sin(wd*(mod(t(k),Tsw)-D*Tsw))))];
    end  
end

figure('Name','Plot IL_bst vs. IL_aef');
% current from dc source
i_diff = iL_boost+iL_aef;
%i1(1:end-1)=i1(2:end);
%plot(t(sample*1:end),iL_boost(sample*1:end),t(sample*1:end),iL_boost(sample*1:end)-dc_iL_boost,'LineWidth',1.5);
%plot(t(sample*1:end),iL_boost(sample*1:end),t(sample*1:end),iL_boost(sample*1:end)-dc_iL_boost,t(sample*1:end),iL_aef(sample*1:end),t(sample*1:end),i_diff(sample*1:end),'LineWidth',2);
plot(t(1:end),iL_boost(1:end)-dc_iL_boost,t(1:end),-iL_aef(1:end),'LineWidth',2);
xlim([0*Tsw cycle*Tsw]);
grid on
legend('iL boost converter','iaef','FontSize',18);

figure('Name','Source current Is');
plot(t(1:end),i_diff(1:end),'LineWidth',2);
xlim([0*Tsw cycle*Tsw]);
grid on

Ts = mean(diff(t)); % sampling interval
Fs = 1/Ts;
Fn = Fs/2;
N = length(t);
y = fft(i_diff-mean(i_diff))/N;
Fv = linspace(0, 1, fix(N/2)+1)*Fn;                 % Frequency Vector
Iv = 1:length(Fv);                                  % Index Vector
figure();
semilogx(Fv, mag2db(abs(y(Iv))));
grid on
title('Fourier Transform Of Original Signal ‘X’')
xlabel('Frequency (Hz)')
ylabel('Amplitude')
xlim([100e3 10e6]);

%%
i1=Io.*exp(-Ro.*t/Lo) + (Vs/Ro).*(1-exp(-Ro.*t/Lo));
t=linspace(0,Tsw/2,1000);
i2=i1(1000).*exp(-Ro.*t/Lo) + ((Vs-Vo)/Ro).*(1-exp(-Ro.*t/Lo));
t=linspace(Tsw/2,Tsw,1000);
plot(t,i2)
legend('iL boost converter','iL','FontSize',18);
grid on
i1_=Io+ Vs/Lo.*t;
%P1(2:end-1) = 2*P1(2:end-1);



