clear 
Tb=1;A=1;fc=4;%�����źŲ���:��Ԫ����Tb;�����źŷ���A;Ƶ��fc;
dt=0.001;t=0:dt:Tb;
s=A*sin(2*pi*fc*t);%ƥ���˲������������ź�;
h=sin(2*pi*fc*(Tb-t));% ƥ���˲����弤��Ӧh��t��=s(Tb-t);
y=conv(s,h)*dt; %���������֣�ƥ���˲������
ty=[1:1:length(y)]*dt;

figure
subplot(3,1,1);
plot(t,s,'g');
title('�����ź�');
subplot(3,1,2);
plot(t,h,'g');
title('�����Ӧh(t)')
subplot(3,1,3);
plot(ty,0*ty,'g',ty,y,'g');hold on
axis([0,2,-0.5,0.5]);
xlabel('ƥ���˲������') 