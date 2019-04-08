%DVB 2K模式接收部分
clear;
close all;
Tu=224e-6; %有用OFDM符号持续时间
T=Tu/2048; %原始基带周期
G=0; %允许保护时间间隔选择1/4, 1/8, 1/16或1/32
delta=G*Tu; %保护间隔持续时间
Ts=delta+Tu; %整个OFDM符号持续时间
Kmax=1705; %子载波数
Kmin=0;
FS=4096; %IFFT/FFT 长度
q=10; %载波周期与原始基带周期比
fc=q*1/T; %载波频率
Rs=4*fc; %模拟周期
t=0:1/Rs:Tu;
tt=0:T/2:Tu;
%数据产生程序
sM = 2;
[x,y] = meshgrid((-sM+1):2:(sM-1),(-sM+1):2:(sM-1));
alphabet = x(:) + 1i*y(:);
N=Kmax+1;
rand('state',0);
a=-1+2*round(rand(N,1)).'+1i*(-1+2*round(rand(N,1))).';
A=length(a);
info=zeros(FS,1);
info(1:(A/2)) = [ a(1:(A/2)).'];
info((FS-((A/2)-1)):FS) = [ a(((A/2)+1):A).'];
carriers=FS.*ifft(info,FS);
%Upconverter
L = length(carriers);
chips = [ carriers.';zeros((2*q)-1,L)];
p=1/Rs:1/Rs:T/2;
g=ones(length(p),1);
dummy=conv(g,chips(:));
u=[dummy; zeros(46,1)];
[b,aa] = butter(13,1/20);
uoft = filter(b,aa,u);
delay=64; %接收端重构滤波器延迟
s_tilde=(uoft(delay+(1:length(t))).').*exp(1i*2*pi*fc*t);
s=real(s_tilde);
%OFDM 接收
%Downconversion
r_tilde=exp(-1i*2*pi*fc*t).*s; %(F)
figure(1);
subplot(211);
plot(t,real(r_tilde));
axis([0e-7 12e-7 -60 60]);
grid on;
figure(1);
subplot(212);
plot(t,imag(r_tilde));
axis([0e-7 12e-7 -100 150]);
grid on;
figure(2);
ff=(Rs)*(1:(q*FS))/(q*FS);
subplot(211);
plot(ff,abs(fft(r_tilde,q*FS))/FS);
grid on;
figure(2);
subplot(212);
pwelch(r_tilde,[],[],[],Rs);
%载波抑制
[B,AA] = butter(3,1/2);
r_info=2*filter(B,AA,r_tilde); %基带信号持续时间(G)
figure(3);
subplot(211);
plot(t,real(r_info));
axis([0 12e-7 -60 60]);
grid on;
figure(3);
subplot(212);
plot(t,imag(r_info));
axis([0 12e-7 -100 150]);
grid on;
figure(4);
f=(2/T)*(1:(FS))/(FS);
subplot(211);
plot(ff,abs(fft(r_info,q*FS))/FS);
grid on;
subplot(212);
pwelch(r_info,[],[],[],Rs);
%抽样
r_data=real(r_info(1:(2*q):length(t)))... %离散时间基带信号
+1i*imag(r_info(1:(2*q):length(t))); % (H)
figure(5)
subplot(212);
stem(tt(1:20),(imag(r_data(1:20))));
axis([0 12e-7 -100 150]);
grid on;
figure(6);
f=(2/T)*(1:(FS))/(FS);
subplot(211);
plot(f,abs(fft(r_data,FS))/FS);
grid on;
subplot(212);
pwelch(r_data,[],[],[],2/T);
%FFT
info_2N=(1/FS).*fft(r_data,FS); % (I)
info_h=[info_2N(1:A/2) info_2N((FS-((A/2)-1)):FS)];
%限幅
for k=1:N,
a_hat(k)=alphabet((info_h(k)-alphabet)==min(info_h(k)-alphabet)); %j
end;
figure(7)
plot(info_h((1:A)),'.k');
title('info-h Received Constellation')
axis square;
axis equal;
figure(8)
plot(a_hat((1:A)),'or');
title('a_hat 4-QAM')
axis square;
axis equal;
grid on;
axis([-1.5 1.5 -1.5 1.5]);;
subplot(211);
stem(tt(1:20),(real(r_data(1:20))));
axis([0 12e-7 -60 60]);
