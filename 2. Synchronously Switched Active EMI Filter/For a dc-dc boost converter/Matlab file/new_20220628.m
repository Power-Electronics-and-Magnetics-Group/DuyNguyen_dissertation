clc
clear all
%yellow_color = '#e2d810';
yellow_color = '#CbC000';
red_color = '#ff0000'; %'#d9138a';
blue_color = '#0000ff';%'#12a4d9';
black_color = '#322e2f';

magenta_color = '#d9138a';
cyan_color = '#12a4d9';

format long
Tsw=6.66e-6; % This frequency is 150kHz
fsw=1/Tsw;
cycle = 200;
%Tsw = 1e-6; % 1MHz
sample = 1000;
t=linspace(0,1*Tsw,sample*1);

Lo=250e-6;
%Ro=1;
Vs=200;
Vo=400;
Io=0.178;
D=0.5;

%Ro_i = [1e-3 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1]; % Parasitic resistor of boost circuit
%Cf_i = 15e-6:-0.5e-6:1e-6;   % Capacitor of AEF

Ro_i = [0.1 0.25 0.5 0.75 1]; % Parasitic resistor of boost circuit
n_i = 0.01:0.01:1.5;   % Capacitor of AEF

%Ro_i = [0.1]; % Parasitic resistor of boost circuit
%n_i = [1];   % Capacitor of AEF

[Ro_m, n_m] = meshgrid(Ro_i,n_i);

attenuation_Ai = [];
for j=1:numel(n_i)
    for n=1:numel(Ro_i)
        iL_boost = [];
        Ro = Ro_m(j,n);
        for k=1:(numel(t)-1)
            if (mod(t(k),Tsw) <= D*Tsw)
                iL_boost=[iL_boost (Io*exp(-Ro*mod(t(k),Tsw)/Lo) + (Vs/Ro)*(1-exp(-Ro*mod(t(k),Tsw)/Lo)))];
                Io_save=iL_boost(k);
            elseif (mod(t(k),Tsw) < (Tsw))
                iL_boost=[iL_boost (Io_save*exp(-Ro*(mod(t(k),Tsw)-D*Tsw)/Lo) + ((Vs-Vo)/Ro)*(1-exp(-Ro*(mod(t(k),Tsw)-D*Tsw)/Lo)))];
            end  
        end

        iL_boost_cycle=[];
        time=[];
        for i=1:cycle
            iL_boost_cycle=[iL_boost_cycle iL_boost];
            time=[time ((i-1)*Tsw+t(1:end-1))];
        end

        max_iL_boost=max(iL_boost_cycle);
        min_iL_boost=min(iL_boost_cycle);
        % dc value of dc-dc boost converter
        dc_iL_boost=(max_iL_boost+min_iL_boost)/2;% mean(iL_boost_cycle);%

        %i_aef = exp(-alpha*t)*(B1*cos(wd*t) + B2*sin(wd*t))
        B2 = -((min_iL_boost-dc_iL_boost));
        
        no=n_m(j,n);
        iL_aef = [];
         for k=1:(numel(t)-1)
            if (mod(t(k),Tsw) <= D*Tsw)
                iL_aef=[iL_aef (B2*exp(-no*Ro*mod(t(k),Tsw)/Lo) + (Vs/(Ro*no))*(1-exp(-no*Ro*mod(t(k),Tsw)/Lo)))];
                 Io_save1=iL_aef(k);
            elseif (mod(t(k),Tsw) < (Tsw))
                iL_aef=[iL_aef (Io_save1*exp(-no*Ro*(mod(t(k),Tsw)-D*Tsw)/Lo) + ((Vs-Vo)/(no*Ro))*(1-exp(-no*Ro*(mod(t(k),Tsw)-D*Tsw)/Lo)))];
            end  
         end
        
        iL_aef_cycle = [];
        for i=1:cycle
            iL_aef_cycle=[iL_aef_cycle iL_aef];
        end

        %figure('Name','aaa');
        % current from dc source
        i_diff = iL_aef_cycle-iL_boost_cycle;
        %i1(1:end-1)=i1(2:end);
        %plot(t(sample*1:end),iL_boost(sample*1:end),t(sample*1:end),iL_boost(sample*1:end)-dc_iL_boost,'LineWidth',1.5);
        %plot(t(sample*1:end),iL_boost(sample*1:end),t(sample*1:end),iL_boost(sample*1:end)-dc_iL_boost,t(sample*1:end),iL_aef(sample*1:end),t(sample*1:end),i_diff(sample*1:end),'LineWidth',2);
        %plot(time(1:end),iL_boost_cycle(1:end)-dc_iL_boost,time(1:end),iL_aef_cycle(1:end),'LineWidth',2);
        %legend('iL boost converter','iaef','FontSize',18);
        %figure('Name','bbb');
        %plot(time(1:end),i_diff,'LineWidth',2);
        %xlim([0*Tsw cycle*Tsw]);
        %grid on
        %legend('iL boost converter','iaef','FontSize',18);

        %figure('Name','Source current Is');
        %plot(time(1:end),i_diff(1:end),'LineWidth',2);
        %xlim([0*Tsw cycle*Tsw]);
        %grid on
        
        if (0)
            figure('Name','aaa');
        %i1(1:end-1)=i1(2:end);
        %plot(t(sample*1:end),iL_boost(sample*1:end),t(sample*1:end),iL_boost(sample*1:end)-dc_iL_boost,'LineWidth',1.5);
        %plot(t(sample*1:end),iL_boost(sample*1:end),t(sample*1:end),iL_boost(sample*1:end)-dc_iL_boost,t(sample*1:end),iL_aef(sample*1:end),t(sample*1:end),i_diff(sample*1:end),'LineWidth',2);
        plot(time(1:end),iL_boost_cycle(1:end)-dc_iL_boost,time(1:end),iL_aef_cycle(1:end),'LineWidth',2);
        legend('iL boost converter','iaef','FontSize',18);
        figure('Name','bbb');
        plot(time(1:end),i_diff,'LineWidth',2);
        %xlim([0*Tsw cycle*Tsw]);
        %grid on
        %legend('iL boost converter','iaef','FontSize',18);

        %figure('Name','Source current Is');
        %plot(time(1:end),i_diff(1:end),'LineWidth',2);
        %xlim([0*Tsw cycle*Tsw]);
        %grid on
        end
        

        Ts = mean(diff(time)); % sampling interval
        Fs = 1/Ts;
        Fn = Fs/2;
        N = length(time);
        fft_i_diff = fft(i_diff-mean(i_diff))/N;
        fft_i_boost = fft(iL_boost_cycle-mean(iL_boost_cycle))/N;
        Fv = linspace(0, 1, fix(N/2)+1)*Fn;                 % Frequency Vector
        Iv = 1:length(Fv);                                  % Index Vector
        fft_i_diff_mag=mag2db(abs(fft_i_diff(Iv)));
        fft_i_boost_mag=mag2db(abs(fft_i_boost(Iv)));

        source_Ai = max(fft_i_diff_mag);
        boost_Ai  = max(fft_i_boost_mag);
        attenuation_Ai = [attenuation_Ai (source_Ai-boost_Ai)];
    end
end

attenuation_mx = shiftdim(reshape(attenuation_Ai,[numel(Ro_i) numel(n_i)]),1);

figure();
plot(n_i,abs(attenuation_mx(:,1)),'Color' , blue_color,'LineWidth',2.2);
hold on
plot(n_i,abs(attenuation_mx(:,2)),'Color' , yellow_color,'LineWidth',2.2);
plot(n_i,abs(attenuation_mx(:,3)),'Color' , red_color,'LineWidth',2.2);
plot(n_i,abs(attenuation_mx(:,4)),'Color' , black_color,'LineWidth',2.2);
plot(n_i,abs(attenuation_mx(:,5)),'Color' , magenta_color,'LineWidth',2.2);
xlim([0 1.5]);
%ylim([-100 20]);
set(gca,'FontSize',15)
label_x=xlabel('$ Time \ Constant \ Ratio$','Interpreter','latex','FontSize',18,'HorizontalAlignment','center');
%xlabel('\it{Capacitance C} [\it{\muF}]','FontSize',18,'HorizontalAlignment','center');
set(label_x,'rotation',0);
label_h=ylabel('$A_{i} \ [dB]$','Interpreter','latex','FontSize',18,'HorizontalAlignment','center');
set(label_h,'rotation',90);
legend('\it{Ro} = 0.1 \Omega','\it{Ro} = 0.25 \Omega','\it{Ro} = 0.5 \Omega','\it{Ro} = 0.75 \Omega','\it{Ro} = 1 \Omega','Location','southeast','FontSize',19);
legend('boxoff')
h=gcf;
set(h,'Position',[200 200 760 580]);
grid on
grid minor

%%
% Interpolate measurements on a finer [PHS,MAG] grid for better display
Ro_i_interp = linspace(min(Ro_i),max(Ro_i),100);
Cf_i_interp = linspace(max(Cf_i),min(Cf_i),100);
[Ro_i_interp, Cf_i_interp] = meshgrid(Ro_i_interp,Cf_i_interp);


for k=1:numel(Cf_i)
    attenuation_interp(:,:)= interp2(Ro_m,Cf_m,attenuation_mx(:,:),Ro_i_interp,Cf_i_interp);
end

figure();
mesh(abs(attenuation_interp));
colormap(red)    % change color map
shading interp    % interpolate colors across lines and faces
figure();
surf(abs(attenuation_interp));
figure();
plot3(Ro_i_interp,Cf_i_interp,abs(attenuation_interp))

%%
figure();
semilogx(Fv, fft_i_diff_mag);
grid on
title('Fourier Transform Of Original Signal ‘X’')
xlabel('Frequency (Hz)')
ylabel('Amplitude')
xlim([100e3 10e6]);

figure();
semilogx(Fv,fft_i_boost_mag);
grid on
title('Fourier Transform Of boost converter current')
xlabel('Frequency (Hz)')
ylabel('Amplitude')
xlim([100e3 10e6]);





