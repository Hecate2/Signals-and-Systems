clear

%syms t
dt=0.001;
dw=0.001*pi;

%生成三角形频谱
w=[-4:dw:4]';
Xw=tripuls(w,2*pi,0);
figure
plot(w,Xw);
title('三角形频谱');

%三角形频谱变换到时域波形
t=[-10:dt:10]';
xt=(1/2/pi)*(exp(1i*t*(w')))*Xw*dw;
figure
plot(t,xt);
%axis([-10 10 0 0.5]);
title('三角形频谱的时域波形');

%对时域波形采样。若要从采样结果恢复原始波形，则采样率要大于生成三角形频谱时tripuls函数输入的第二个参数
sampRate=10*pi; %采样角频率！角频率！
sampFreq=sampRate/2/pi;%采样频率
%N=length(xt)/sampFreq;%需要采样的点数
sample=downsample(xt,1/sampFreq/dt);
%,(rem(length(xt),1/sampFreq/dt)-1)/2
Tsample=(reshape((sample*ones(1,1/sampFreq/dt))',1,length(sample)/sampFreq/dt))';
tsample=[-10:20/length(Tsample):10-20/length(Tsample)];
figure
plot(tsample,Tsample);
title('采样结果');

%原始波形的频谱
Xw=dt*exp(-1i*w*t')*xt;
figure
plot(w,Xw);
title('原始波形的频谱')

%采样结果的频谱
TsampleW=dt*exp(-1i*w*tsample)*Tsample;
figure
plot(w,TsampleW);
title('采样结果的频谱')
