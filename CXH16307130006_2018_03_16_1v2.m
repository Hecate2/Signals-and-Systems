clear

syms t;

h(t)=t/2;
x(t)=heaviside(t+1/2)-heaviside(t-3/2);
th=0:0.01:2;%��ɢ����h�Ķ�����
fh=th/2;%��ɢ����h�ĺ���ֵ
tx=-0.5:0.01:1.5;
fx=ones(1,length(tx));
y=0.01*conv(fx,fh);

t=0:0.01:2;
plot(t,h(t));
hold on
t=-1:0.01:4;
plot(t,x(t));
hold on
t=0:0.01:4;
plot(t,y);
grid on
xlabel('t')
legend('h(t)','x(t)','y(t)')