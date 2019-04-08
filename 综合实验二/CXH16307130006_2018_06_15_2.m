%DVB 2Kģʽ���ղ���
clear;
close all;
Tu=224e-6; %����OFDM���ų���ʱ��
T=Tu/2048; %ԭʼ��������
G=0; %������ʱ����ѡ��1/4, 1/8, 1/16��1/32
delta=G*Tu; %�����������ʱ��
Ts=delta+Tu; %����OFDM���ų���ʱ��
Kmax=1705; %���ز���
Kmin=0;
FS=4096; %IFFT/FFT ����
q=10; %�ز�������ԭʼ�������ڱ�
fc=q*1/T; %�ز�Ƶ��
Rs=4*fc; %ģ������
t=0:1/Rs:Tu;
tt=0:T/2:Tu;
%���ݲ�������
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
delay=64; %���ն��ع��˲����ӳ�
s_tilde=(uoft(delay+(1:length(t))).').*exp(1i*2*pi*fc*t);
s=real(s_tilde);
%OFDM ����
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
%�ز�����
[B,AA] = butter(3,1/2);
r_info=2*filter(B,AA,r_tilde); %�����źų���ʱ��(G)
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
%����
r_data=real(r_info(1:(2*q):length(t)))... %��ɢʱ������ź�
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
%�޷�
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
