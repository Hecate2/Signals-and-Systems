clear

%syms t
dt=0.001;
dw=0.001*pi;

%����������Ƶ��
w=[-4:dw:4]';
Xw=tripuls(w,2*pi,0);
figure
plot(w,Xw);
title('������Ƶ��');

%������Ƶ�ױ任��ʱ����
t=[-10:dt:10];
xt=(1/2/pi)*(exp(1i*(t')*(w')))*Xw*dw;
figure
plot(t,xt);
%axis([-10 10 0 0.5]);
title('������Ƶ�׵�ʱ����');

%��ʱ���β�������Ҫ�Ӳ�������ָ�ԭʼ���Σ��������Ҫ��������������Ƶ��ʱtripuls��������ĵڶ�������
sampRate=10*pi; %������Ƶ�ʣ���Ƶ�ʣ�
sampFreq=sampRate/2/pi;%����Ƶ��
%N=length(xt)/sampFreq;%��Ҫ�����ĵ���
sample=downsample(xt,1/sampFreq/dt);
%,(rem(length(xt),1/sampFreq/dt)-1)/2
Tsample=(reshape((sample*ones(1,1/sampFreq/dt))',1,length(sample)/sampFreq/dt))';
tsample=[-10:20/length(Tsample):10-20/length(Tsample)];
figure
plot(tsample,Tsample);
title('�������');

%���������Ƶ��
TsampleW=dt*exp(-1i*w*tsample)*Tsample;
figure
plot(w,TsampleW);
title('���������Ƶ��')

%������Ƶ�׽����������أ�������Ӧʱ���ź�
w=[-pi:dw:pi];
Xw=(tripuls(w,2*pi,0))';
w=[-3*pi-dw:dw:3*pi+dw];
Xw=reshape(kron([1,1,1],Xw),3*length(Xw),1);
xt=(1/2/pi)*(exp(1i*(t')*(w)))*Xw*dw;
figure
plot(w,Xw);
title('�������غ��Ƶ��')
figure
plot(t,xt);
%axis([-10 10 0 0.5]);
title('������Ƶ���������غ��ʱ����');