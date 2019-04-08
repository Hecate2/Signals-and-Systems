%这个程序并不是一天就写出来的。是知道了有OFDM大作业后猜测了一下要求。提前写了一篇代码
%当时用了4QAM（而不是BPSK）调制，所以整个程序都带有虚数运算
%当时做了一些额外滤波。现在保留了滤波，所以误码率可能低了一些。
%以前的上机经常画时域频域图，所以这个程序画了很多时域频域图，还有功率谱密度。现在对于作业要求来说没用了。

%在第66行s=awgn(s0,0);处修改信噪比
%第14行的q修改信道抽头系数
%figure 7为收到信号的星座图，其他图都是发射/接收信号的时域或频域或功率谱密度图，欣赏意义不大
%发射信号的星座图不是1就是-1，没有画！

%传输的正负1都是随机的。误码率也可能随运气而变化。
%这个程序只用首尾两个信道发射，并统计这两个信道的总误码率。其他信道的载波运载的信息全是0。
%但所有信道都会被处理。
%如果要用上全部信道，只需向info变量填满正负1
%没有做信道均衡，所以整个信道填满数据的时候误码率高

clear
%close all
Tu=224e-6; %有用OFDM符号持续时间
T=Tu/2048; %原始基带周期
CP_rate=1/16; %保护时间的比例。1/4, 1/8, 1/16或1/32都可以
TG=CP_rate*Tu; %保护间隔持续时间
Ts=TG+Tu; %整个OFDM符号持续时间
N=256; %子载波数

FS=4096; %IFFT/FFT 长度
q=10; %信道抽头系数(载波周期与原始基带周期比)
fc=q*1/T; %载波频率
Rs=4*fc; %模拟周期
t=0:1/Rs:Tu;
tt=0:T/2:Tu;
%数据产生程序
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
%info=-1+2*round(rand(length(info),1)); %这一句重设info中所有的点都被正负1填满，会使误码率增加
carriers=FS.*ifft(info,FS);
%上变频
L = length(carriers);
chips = [ carriers.';zeros((2*q)-1,L)];
p=1/Rs:1/Rs:T/2;
g=ones(length(p),1);
dummy=conv(g,chips(:));
u=[dummy; zeros(46,1)];
[b,aa] = butter(13,1/20);
uoft = filter(b,aa,u);
delay=64; %接收端滤波器延迟
s_tilde=(uoft(delay+(1:length(t))).').*exp(1i*2*pi*fc*t);
s=real(s_tilde);

sigPower=sum(abs(s(:)).^2)/length(s(:));  %发射信号功率
s=s/sqrt(sigPower); %发射信号功率归一
%sigPower=sum(abs(s(:)).^2)/length(s(:)); %现在信号功率为1W,0dBW

%s被发射出去
s0=s;
s=awgn(s0,0); %被发射的信号添加高斯白噪声


%OFDM 接收
%下变频
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
%载波抑制
[B,AA] = butter(3,1/2);
r_info=2*filter(B,AA,r_tilde); %基带信号持续时间
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
%抽样
r_data=real(r_info(1:(2*q):length(t)))... %离散时间基带信号
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
%限幅
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

%判决info_h是-1还是1，并计算误码率
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
SER=err/A %误码率
