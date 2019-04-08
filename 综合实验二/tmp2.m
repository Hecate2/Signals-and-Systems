clear;
%close all;
Tu=224e-6; %����OFDM���ų���ʱ��
T=Tu/2048; %ԭʼ��������
CP_rate=1/16; %������ʱ����ѡ��1/4, 1/8, 1/16��1/32
TG=CP_rate*Tu; %�����������ʱ��
Ts=TG+Tu; %����OFDM���ų���ʱ��
N=256; %���ز���

FS=4096; %IFFT/FFT ����
q=10; %�ŵ���ͷϵ��(�ز�������ԭʼ�������ڱ�)
fc=q*1/T; %�ز�Ƶ��
Rs=4*fc; %ģ������
t=0:1/Rs:Tu;
%tt=T/2:T/2:Tu;

%OFDM����

%���ݲ�������
%��������
%M=N+1;
M=N;
rand('state',0);
a=-1+2*round(rand(M,1)); %���������1
A=length(a);
info=zeros(FS,1);
info(1:(A/2)) = a(1:(A/2));
info((FS-(A/2)+1):FS) = a(((A/2)+1):A);
%info��β�����ɵ�1��-1��������0���������ŵ��ã�

%���ݰ����ز�
carriers=FS*ifft(info,FS); %�����ݵ��ز�
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
title('Welch��s Power Spectral Density Estimate for carrier');

% D/A
L = length(carriers);
chips = [ carriers.';zeros((2*q)-1,L)];
p=1/Rs:1/Rs:T/2;
g=ones(length(p),1); %�����γ�
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
[b,aa] = butter(13,1/20); %�����˲��� %������a�ù��ˣ�����aa
[H,F] = freqz(b,aa,FS,Rs);
%figure(6);
%plot(F,20*log10(abs(H)));
uoft = filter(b,aa,u); %�����ź�
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
%�ϱ�Ƶ
s_tilde=(uoft.').*exp(1i*2*pi*fc*t);
s=real(s_tilde); %�������ź�
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

sigPower=sum(abs(s(:)).^2)/length(s(:));  %�źŹ���
s=s/sqrt(sigPower);
%sigPower=sum(abs(s(:)).^2)/length(s(:)); %�����źŹ���Ϊ1W,0dBW

%s�������ȥ



%OFDM ����
%s0=s;
s=awgn(s,10); %��������ź���Ӹ�˹������

%�±�Ƶ
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
%�ز�����
[B,AA] = butter(3,1/2);
r_info=2*filter(B,AA,r_tilde); %�����źų���ʱ��
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
%����
r_data=real(r_info(1:(2*q):length(t))); %��ɢʱ������ź�
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
%�޷�
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

%�о�info_h������������
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
SER=err/A %������
%zero
figure(20)
plot(info_judged-a); %��ʾ��Щλ�ó���
