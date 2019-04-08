clear

syms x t;

h(t)=t/2;
x(t)=heaviside(t+1/2)-heaviside(t-3/2);
th=0:0.01:2;%离散化的h的定义域
fh=th/2;%离散化的h的函数值
tx=-0.5:0.01:1.5;
fx=ones(1,length(tx));
y=0.01*conv(fx,fh);

fplot(t,h,[0,2]);
hold on
fplot(t,x,[-1,4]);
hold on
t=0:0.01:4;
plot(t,y);
grid on
xlabel('t')
legend('h(t)','x(t)','y(t)')