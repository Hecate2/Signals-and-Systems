clear;
%close all;
Tu=224e-6; %有用OFDM符号持续时间
T=Tu/2048; %原始基带周期
CP_rate=1/16; %允许保护时间间隔选择1/4, 1/8, 1/16或1/32
TG=CP_rate*Tu; %保护间隔持续时间
Ts=TG+Tu; %整个OFDM符号持续时间
N=256; %子载波数

FS=4096; %IFFT/FFT 长度
q=10; %信道抽头系数(载波周期与原始基带周期比)
fc=q*1/T; %载波频率
Rs=4*fc; %模拟周期
t=0:1/Rs:Tu;
%tt=T/2:T/2:Tu;

%OFDM发射

%数据产生程序
%产生数据
%M=N+1;
M=N;
rand('state',0);
a=-1+2*round(rand(M,1)); %随机的正负1
A=length(a);
info=zeros(FS,1);
info(1:(A/2)) = a(1:(A/2));
info((FS-(A/2)+1):FS) = a(((A/2)+1):A);
%info首尾是生成的1和-1，其余是0（给其他信道用）

%数据搬上载波
carriers=FS*ifft(info,FS); %有数据的载波
tt=0:T/2:Tu;
sM = 2;
%[x,y] = meshgrid((-sM+1):2:(sM-1),(-sM+1):2:(sM-1));
%alphabet = x(:) + 1i*y(:);
alphabet = [-1;1];

figure(1);
subplot(211);
plot(tt(1:length(carriers)),real(carriers));
title('real(carrier)');
subplot(212);
plot(tt(1:length(carriers)),imag(carriers));
title('imag(carrier)');
figure(2);
f=(2/T)*(1:(FS))/(FS);
subplot(211);
plot(f,abs(fft(carriers,FS))/FS);
xlabel('frequency');
title('fft(carrier)');
subplot(212);
pwelch(carriers,[],[],[],2/T);
title('Welch’s Power Spectral Density Estimate for carrier');

% D/A
L = length(carriers);
chips = [ carriers.';zeros((2*q)-1,L)];
p=1/Rs:1/Rs:T/2;
g=ones(length(p),1); %脉冲形成
% figure(3);
% stem(p,g);
dummy=conv(g,chips(:));
u=dummy(1:length(t));
figure(4);
subplot(211);
plot(t,real(u));
title('real(CP-inserted signal)');
subplot(212);
plot(t,imag(u));
title('imag(CP-inserted signal)');
figure(5);
ff=(Rs)*(1:(q*FS))/(q*FS);
subplot(211);
plot(ff,abs(fft(u,q*FS))/FS);
title('abs(fft(CP-inserted signal))');
subplot(212);
pwelch(u,[],[],[],Rs);
[b,aa] = butter(13,1/20); %构造滤波器 %变量名a用过了，改用aa
[H,F] = freqz(b,aa,FS,Rs);
%figure(6);
%plot(F,20*log10(abs(H)));
uoft = filter(b,aa,u); %基带信号
figure(7);
subplot(211);
plot(t,real(uoft));
title('real(baseband signal)');
subplot(212);
plot(t,imag(uoft));
title('imag(baseband signal)');
figure(8);
subplot(211);
plot(ff,abs(fft(uoft,q*FS))/FS);
title('abs(fft(baseband signal))');
subplot(212);
pwelch(uoft,[],[],[],Rs);
%上变频
s_tilde=(uoft.').*exp(1i*2*pi*fc*t);
s=real(s_tilde); %待发射信号
figure(9);
plot(t,s);
title('transmission band signal');
figure(10);
subplot(211);
%plot(ff,abs(fft(((real(uoft).').*cos(2*pi*fc*t)),q*FS))/FS);
%plot(ff,abs(fft(((imag(uoft).').*sin(2*pi*fc*t)),q*FS))/FS);
plot(ff,abs(fft(s,q*FS))/FS);
title('fft(transmission band signal)');
subplot(212);
%pwelch(((real(uoft).').*cos(2*pi*fc*t)),[],[],[],Rs);
%pwelch(((imag(uoft).').*sin(2*pi*fc*t)),[],[],[],Rs);
pwelch(s,[],[],[],Rs);

sigPower=sum(abs(s(:)).^2)/length(s(:));  %信号功率
s=s/sqrt(sigPower);
%sigPower=sum(abs(s(:)).^2)/length(s(:)); %现在信号功率为1W,0dBW

%s被发射出去



%OFDM 接收
%s0=s;
s=awgn(s,10); %被发射的信号添加高斯白噪声

%下变频
r_tilde=exp(-1i*2*pi*fc*t).*s;
figure(11);
subplot(211);
plot(t,real(r_tilde));
%axis([0e-7 12e-7 -60 60]);
grid on;
figure(11);
subplot(212);
plot(t,imag(r_tilde));
%axis([0e-7 12e-7 -100 150]);
grid on;
figure(12);
ff=(Rs)*(1:(q*FS))/(q*FS);
subplot(211);
plot(ff,abs(fft(r_tilde,q*FS))/FS);
grid on;
figure(12);
subplot(212);
pwelch(r_tilde,[],[],[],Rs);
%载波抑制
[B,AA] = butter(3,1/2);
r_info=2*filter(B,AA,r_tilde); %基带信号持续时间
figure(13);
subplot(211);
plot(t,real(r_info));
axis([0 12e-7 -60 60]);
grid on;
figure(13);
subplot(212);
plot(t,imag(r_info));
%axis([0 12e-7 -100 150]);
grid on;
figure(14);
%f=(2/T)*(1:(FS))/(FS);
subplot(211);
plot(ff,abs(fft(r_info,q*FS))/FS);
grid on;
subplot(212);
pwelch(r_info,[],[],[],Rs);
%抽样
r_data=real(r_info(1:(2*q):length(t))); %离散时间基带信号
%+1i*imag(r_info(1:(2*q):length(t)));
figure(15)
plot(tt,(real(r_data)));
%axis([0 12e-7 -100 150]);
grid on;
figure(16);
f=(2/T)*(1:(FS))/(FS);
subplot(211);
plot(f,abs(fft(r_data,FS))/FS);
grid on;
subplot(212);
pwelch(r_data,[],[],[],2/T);
%FFT
info_2N=(1/FS).*fft(r_data,FS);
info_h=[info_2N(1:A/2) info_2N((FS-((A/2)-1)):FS)];
%限幅
% for k=1:N,
% a_hat(k)=alphabet((info_h(k)-alphabet)==min(info_h(k)-alphabet)); %j
% end;
figure(17)
plot(sqrt(sigPower)*info_h,'.k');
title('info-h Received Constellation')
axis square;
axis equal;
% figure(18)
% plot(a_hat((1:A)),'or');
% title('a_hat 4-QAM')
% axis square;
% axis equal;
% grid on;
% axis([-1.5 1.5 -1.5 1.5]);;
figure(19);
plot(tt,(real(r_data)));
%axis([0 12e-7 -60 60]);

%判决info_h并计算误码率
info_judged=sqrt(sigPower)*real(info_h');
err=0;
zero=0;
for i=1:length(info_judged)
    if(abs(info_judged(i)+1)<abs(info_judged(i)) && abs(info_judged(i)+1)<abs(info_judged(i)-1))
        info_judged(i)=-1;
    elseif(abs(info_judged(i))<=abs(info_judged(i)+1) && abs(info_judged(i))<=abs(info_judged(i)-1))
        info_judged(i)=0;
        %zero=zero+1;
    elseif(abs(info_judged(i)-1)<abs(info_judged(i)) && abs(info_judged(i)-1)<abs(info_judged(i)+1))
        info_judged(i)=1;
    end
    if(info_judged(i)~=a(i))
        err=err+1;
    end
end
SER=err/A %误码率
%zero
figure(20)
plot(info_judged-a); %显示哪些位置出错
