clear

syms t w
dt=0.001;

%f(t)=(heaviside(t+1/2)-heaviside(t-1/2))*(1-2*abs(t));
t=[-1/2:dt:1/2];
y=[ones(1,1/dt/2+1)];%�÷���y�ľ���������ǲ�
ft=[conv(y,y)/(1/dt/2)]';
figure
plot(t,ft);
title('���ǲ�f(t)');
ylabel('f(t)');
xlabel('t');

%ֱ�Ӹ���Ҷ�任
w=[-8*pi:dt*16*pi:8*pi]';
Fw=dt*exp(-1i*w*t)*ft;
figure
plot(w,Fw);
ylabel('Fw');
xlabel('w');
title('Fw');
%fplot(w,F(w));

%���󷽲��ĸ���Ҷ�任���ٰѷ����ĸ���Ҷ�任��ˣ��õ����ǲ��ĸ���Ҷ�任
w0=[-4*pi:dt*8*pi:4*pi]';
Fw0=dt*exp(-1i*w0*t)*[ones(1,1001)]';%�����ĸ���Ҷ�任
figure
plot(w0*2,Fw0.*Fw0/2);
ylabel('Fw');
xlabel('w');
title('���󷽲��ĸ���Ҷ�任���ٰѷ����ĸ���Ҷ�任��ˣ��õ����ǲ��ĸ���Ҷ�任');
