%������򲢲���һ���д�����ġ���֪������OFDM����ҵ��²���һ��Ҫ����ǰд��һƪ����
%��ʱ����4QAM��������BPSK�����ƣ������������򶼴�����������
%��ʱ����һЩ�����˲������ڱ������˲������������ʿ��ܵ���һЩ��
%��ǰ���ϻ�������ʱ��Ƶ��ͼ��������������˺ܶ�ʱ��Ƶ��ͼ�����й������ܶȡ����ڶ�����ҵҪ����˵û���ˡ�

%�ڵ�66��s=awgn(s0,0);���޸������
%��14�е�q�޸��ŵ���ͷϵ��
%figure 7Ϊ�յ��źŵ�����ͼ������ͼ���Ƿ���/�����źŵ�ʱ���Ƶ��������ܶ�ͼ���������岻��
%�����źŵ�����ͼ����1����-1��û�л���

%���������1��������ġ�������Ҳ�������������仯��
%�������ֻ����β�����ŵ����䣬��ͳ���������ŵ����������ʡ������ŵ����ز����ص���Ϣȫ��0��
%�������ŵ����ᱻ����
%���Ҫ����ȫ���ŵ���ֻ����info������������1
%û�����ŵ����⣬���������ŵ��������ݵ�ʱ�������ʸ�

clear
%close all
Tu=224e-6; %����OFDM���ų���ʱ��
T=Tu/2048; %ԭʼ��������
CP_rate=1/16; %����ʱ��ı�����1/4, 1/8, 1/16��1/32������
TG=CP_rate*Tu; %�����������ʱ��
Ts=TG+Tu; %����OFDM���ų���ʱ��
N=256; %���ز���

FS=4096; %IFFT/FFT ����
q=10; %�ŵ���ͷϵ��(�ز�������ԭʼ�������ڱ�)
fc=q*1/T; %�ز�Ƶ��
Rs=4*fc; %ģ������
t=0:1/Rs:Tu;
tt=0:T/2:Tu;
%���ݲ�������
sM = 2;
[x,y] = meshgrid((-sM+1):2:(sM-1),(-sM+1):2:(sM-1));
alphabet = x(:) + 1i*y(:);
if (rem(N,2)==1)
    N=N+1;
end
rand('state',0);
a=-1+2*round(rand(N,1)).';
A=length(a);
info=zeros(FS,1);
info(1:(A/2)) = [ a(1:(A/2)).'];
info((FS-((A/2)-1)):FS) = [ a(((A/2)+1):A).'];
%info=-1+2*round(rand(length(info),1)); %��һ������info�����еĵ㶼������1��������ʹ����������
carriers=FS.*ifft(info,FS);
%�ϱ�Ƶ
L = length(carriers);
chips = [ carriers.';zeros((2*q)-1,L)];
p=1/Rs:1/Rs:T/2;
g=ones(length(p),1);
dummy=conv(g,chips(:));
u=[dummy; zeros(46,1)];
[b,aa] = butter(13,1/20);
uoft = filter(b,aa,u);
delay=64; %���ն��˲����ӳ�
s_tilde=(uoft(delay+(1:length(t))).').*exp(1i*2*pi*fc*t);
s=real(s_tilde);

sigPower=sum(abs(s(:)).^2)/length(s(:));  %�����źŹ���
s=s/sqrt(sigPower); %�����źŹ��ʹ�һ
%sigPower=sum(abs(s(:)).^2)/length(s(:)); %�����źŹ���Ϊ1W,0dBW

%s�������ȥ
s0=s;
s=awgn(s0,0); %��������ź���Ӹ�˹������


%OFDM ����
%�±�Ƶ
r_tilde=exp(-1i*2*pi*fc*t).*s; %(F)
figure(1);
subplot(211);
plot(t,real(r_tilde));
% axis([0e-7 12e-7 -60 60]);
grid on;
figure(1);
subplot(212);
plot(t,imag(r_tilde));
% axis([0e-7 12e-7 -100 150]);
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
r_info=2*filter(B,AA,r_tilde); %�����źų���ʱ��
figure(3);
subplot(211);
plot(t,real(r_info));
% axis([0 12e-7 -60 60]);
grid on;
figure(3);
subplot(212);
plot(t,imag(r_info));
% axis([0 12e-7 -100 150]);
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
+1i*imag(r_info(1:(2*q):length(t))); %
figure(5)
subplot(212);
stem(tt(1:20),(imag(r_data(1:20))));
% axis([0 12e-7 -100 150]);
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
plot(sqrt(sigPower)*info_h((1:A)),'.k');
title('info-h Received Constellation');
xlabel('real');
ylabel('imag');
% axis square;
% axis equal;
% figure(8)
% plot(a_hat((1:A)),'or');
% title('a_hat 4-QAM')
% axis square;
% axis equal;
% grid on;
% axis([-1.5 1.5 -1.5 1.5]);;
% subplot(211);
% stem(tt(1:20),(real(r_data(1:20))));
% axis([0 12e-7 -60 60]);

%�о�info_h��-1����1��������������
info_judged=sqrt(sigPower)*real(info_h');
err=0;
for i=1:length(info_judged)
    if(abs(info_judged(i)+1)<abs(info_judged(i)) && abs(info_judged(i)+1)<abs(info_judged(i)-1))
        info_judged(i)=-1;
    elseif(abs(info_judged(i))<=abs(info_judged(i)+1) && abs(info_judged(i))<=abs(info_judged(i)-1))
        info_judged(i)=0;
    elseif(abs(info_judged(i)-1)<abs(info_judged(i)) && abs(info_judged(i)-1)<abs(info_judged(i)+1))
        info_judged(i)=1;
    end
    if(info_judged(i)~=a(i))
        err=err+1;
    end
end
SER=err/A %������
