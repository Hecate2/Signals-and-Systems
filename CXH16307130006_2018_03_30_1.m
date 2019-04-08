clear

syms t w
dt=0.001;

%��ԭ�ź�f(t)
f=heaviside(t+1/2)-heaviside(t-1/2);
figure
fplot(t,f);
axis([-1 1 0 1.1]);
ylabel('f(t)');
xlabel('t');
title('f(t)');

%����Ҷ�任
t=[-1/2:dt:1/2-dt];
ft=[ones(1,1/dt)]';
w=[-8*pi:dt*16*pi:8*pi]';
Fw=dt*exp(-1i*w*t)*ft;
figure
plot(w,Fw);
ylabel('Fw');
xlabel('w');
title('Fw')
%fplot(w,F(w));

%�ָ�ԭʱ���ź�ft
dw=16*pi*dt;
ft1=(1/2/pi)*(exp(1i*(t')*(w')))*Fw*dw;
figure
plot(t,ft1);
ylabel('�ָ���f(t)');
xlabel('t');
title('�ָ���f(t)');