clear

dt=0.001;
t=[0:dt:10*pi];
et=(sin(t))';
sigPower=sum(abs(et(:)).^2)/length(et(:));  %信号功率
xt=et+wgn(length(et),1,2*pi,'linear');

dw=dt*10*pi;
w=[-10*pi:dw:10*pi]';
Xw=dt*exp(-1i*w*t)*xt;
Hw=10./(10.+1i.*w);
Yw=Xw.*Hw;

yt=(1/2/pi)*(exp(1i*(t')*(w')))*Yw*dw;

figure
plot(t,[xt et]);
legend('加噪声信号','原信号');

figure
plot(w,[Xw Yw]);
title('输入输出信号的傅里叶变换');
legend('输入信号','输出信号');

figure
plot(t,yt);
title('滤波后输出');