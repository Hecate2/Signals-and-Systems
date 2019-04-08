clear

Tb=2;%�����źŲ���:��Ԫ����Tb
dt=0.001;
t=[0:dt:Tb]';
s1t=ones(length(t),1);
s2t=[ones((length(t)+1)/2,1);-1*ones((length(t)-1)/2,1)];
s3t=sin(3*pi*t.^2);

h1t=ones(length(Tb-t),1);% ƥ���˲����弤��Ӧh(t)
y1=conv(s1t,h1t)*dt; %���������֣�ƥ���˲������
ty1=[1:1:length(y1)]*dt;%y1��ʱ����

h2t=[-1*ones((length(Tb-t)-1)/2,1);ones((length(Tb-t)+1)/2,1)];
y2=conv(s2t,h2t)*dt;
ty2=[1:1:length(y2)]*dt;

h3t=sin(3*pi*(Tb-t).^2);% ƥ���˲����弤��Ӧh(t)
y3=conv(s3t,h3t)*dt; %���������֣�ƥ���˲������
ty3=[1:1:length(y3)]*dt;%y1��ʱ����

figure
subplot(3,1,1);
plot(t,s1t);
title('�����ź�1');
axis([-0.1,2.1,-1.1,1.1]);
subplot(3,1,2);
plot(t,h1t);
title('�����Ӧh1(t)')
axis([-0.1,2.1,-1.1,1.1]);
subplot(3,1,3);
plot(ty1,y1);
%axis([0,2,-0.5,0.5]);
title('ƥ���˲���1���') 

figure
subplot(3,1,1);
plot(t,s2t);
title('�����ź�2');
axis([-0.1,2.1,-1.1,1.1]);
subplot(3,1,2);
plot(t,h2t);
title('�����Ӧh2(t)')
axis([-0.1,2.1,-1.1,1.1]);
subplot(3,1,3);
plot(ty2,y2);
%axis([0,2,-0.5,0.5]);
title('ƥ���˲���2���') 

figure
subplot(3,1,1);
plot(t,s3t);
title('�����ź�3');
subplot(3,1,2);
plot(t,h3t);
title('�����Ӧh3(t)')
subplot(3,1,3);
plot(ty3,y3);
%axis([0,2,-0.5,0.5]);
title('ƥ���˲���3���') 