clear

Tb=2;%输入信号参数:码元长度Tb
dt=0.001;
t=[0:dt:Tb]';
s1t=ones(length(t),1);
s2t=[ones((length(t)+1)/2,1);-1*ones((length(t)-1)/2,1)];
s3t=sin(3*pi*t.^2);

h1t=ones(length(Tb-t),1);% 匹配滤波器冲激响应h(t)
y1=conv(s1t,h1t)*dt; %计算卷积积分，匹配滤波器输出
ty1=[1:1:length(y1)]*dt;%y1的时间轴

h2t=[-1*ones((length(Tb-t)-1)/2,1);ones((length(Tb-t)+1)/2,1)];
y2=conv(s2t,h2t)*dt;
ty2=[1:1:length(y2)]*dt;

h3t=sin(3*pi*(Tb-t).^2);% 匹配滤波器冲激响应h(t)
y3=conv(s3t,h3t)*dt; %计算卷积积分，匹配滤波器输出
ty3=[1:1:length(y3)]*dt;%y1的时间轴

figure
subplot(3,1,1);
plot(t,s1t);
title('输入信号1');
axis([-0.1,2.1,-1.1,1.1]);
subplot(3,1,2);
plot(t,h1t);
title('冲击响应h1(t)')
axis([-0.1,2.1,-1.1,1.1]);
subplot(3,1,3);
plot(ty1,y1);
%axis([0,2,-0.5,0.5]);
title('匹配滤波器1输出') 

figure
subplot(3,1,1);
plot(t,s2t);
title('输入信号2');
axis([-0.1,2.1,-1.1,1.1]);
subplot(3,1,2);
plot(t,h2t);
title('冲击响应h2(t)')
axis([-0.1,2.1,-1.1,1.1]);
subplot(3,1,3);
plot(ty2,y2);
%axis([0,2,-0.5,0.5]);
title('匹配滤波器2输出') 

figure
subplot(3,1,1);
plot(t,s3t);
title('输入信号3');
subplot(3,1,2);
plot(t,h3t);
title('冲击响应h3(t)')
subplot(3,1,3);
plot(ty3,y3);
%axis([0,2,-0.5,0.5]);
title('匹配滤波器3输出') 