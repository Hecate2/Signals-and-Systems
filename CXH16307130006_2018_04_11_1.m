clear

syms v t
dt=0.001;

%画输入信号v1(t)
v1(t)=heaviside(t)-heaviside(t-1);
figure
fplot(t,v1(t));
axis([-1 2 0 1.1]);
xlabel('t');
ylabel('v1(t)');
title('输入信号的时域波形');

%求输入信号的傅里叶变换
t=[-1:dt:2];
v1t=[zeros(1,1/dt),ones(1,1+1/dt),zeros(1,1/dt)]';
w=[-16*pi:dt*32*pi:16*pi]';
V1w=dt*exp(-1i*w*t)*v1t;
figure
plot(w,V1w);
ylabel('V1w');
xlabel('w');
title('输入信号的傅里叶变换')

%求输出信号的傅里叶变换；绘制Hjw的频谱
Hw=(10./(10.+w.*1i))';
Vow=(V1w'.*Hw)';
figure
plot(w,abs(Vow));
hold on
plot(w,abs(Hw));
legend('|Vow|','|Hjw|');
%ylabel('Vow');
xlabel('w');
title('输出信号和H(jw)的傅里叶变换');

%输出信号和H(jw)的时域波形
dw=32*pi*dt;
Vt=(1/2/pi)*(exp(1i*(t')*(w')))*Vow*dw;
Ht=(1/2/pi)*(exp(1i*(t')*(w')))*(Hw')*dw;
figure
plot(t,abs(Vt));
xlabel('t');
axis([-1 2 0 8]);
hold on
plot(t,abs(Ht));
legend('|Vt|','|Ht|');
title('输出信号的时域波形');