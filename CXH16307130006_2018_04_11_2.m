%_____________________________________
%�������ʵ��������˲����Ľ����������ͼ����ÿ�
%_____________________________________

clear

syms t
dt=0.001;

%filter1=[ones(1,2*2*pi/dt)];
%filter2=[ones(1,2*8*pi/dt)];
%filter3=[ones(1,2*32*pi/dt)];
ft=[zeros(1,3/2/dt),ones(1,1/dt+1),zeros(1,3/2/dt)]';
t=[-2:dt:2];

%ft�ĸ���Ҷ�任
w=[-40*pi:dt*80*pi:40*pi]';
Fw=dt*exp(-1i*w*t)*ft;
% figure
% plot(w,Fw);
% ylabel('Fw');
% xlabel('w');
% title('�����źŵĸ���Ҷ�任')

%�˲�
Fw1=(Fw'.*[zeros(1,38/dt/80),ones(1,2*2/dt/80+1),zeros(1,38/dt/80)])';
Fw2=(Fw'.*[zeros(1,32/dt/80),ones(1,2*8/dt/80+1),zeros(1,32/dt/80)])';
Fw3=(Fw'.*[zeros(1,8/dt/80),ones(1,2*32/dt/80+1),zeros(1,8/dt/80)])';

%�任�ص�ʱ��
dw=80*pi*dt;
ft1=(1/2/pi)*(exp(1i*(t')*(w')))*Fw1*dw;
ft2=(1/2/pi)*(exp(1i*(t')*(w')))*Fw2*dw;
ft3=(1/2/pi)*(exp(1i*(t')*(w')))*Fw3*dw;
figure
plot(t,abs(ft1));
xlabel('t');
axis([-2 2 0 1.3]);
hold on
plot(t,abs(ft2));
xlabel('t');
axis([-2 2 0 1.3]);
hold on
plot(t,abs(ft3));
xlabel('t');
axis([-2 2 0 1.3]);
legend('ft1','ft2','ft3');
