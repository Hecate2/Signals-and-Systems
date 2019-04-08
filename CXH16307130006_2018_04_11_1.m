clear

syms v t
dt=0.001;

%�������ź�v1(t)
v1(t)=heaviside(t)-heaviside(t-1);
figure
fplot(t,v1(t));
axis([-1 2 0 1.1]);
xlabel('t');
ylabel('v1(t)');
title('�����źŵ�ʱ����');

%�������źŵĸ���Ҷ�任
t=[-1:dt:2];
v1t=[zeros(1,1/dt),ones(1,1+1/dt),zeros(1,1/dt)]';
w=[-16*pi:dt*32*pi:16*pi]';
V1w=dt*exp(-1i*w*t)*v1t;
figure
plot(w,V1w);
ylabel('V1w');
xlabel('w');
title('�����źŵĸ���Ҷ�任')

%������źŵĸ���Ҷ�任������Hjw��Ƶ��
Hw=(10./(10.+w.*1i))';
Vow=(V1w'.*Hw)';
figure
plot(w,abs(Vow));
hold on
plot(w,abs(Hw));
legend('|Vow|','|Hjw|');
%ylabel('Vow');
xlabel('w');
title('����źź�H(jw)�ĸ���Ҷ�任');

%����źź�H(jw)��ʱ����
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
title('����źŵ�ʱ����');