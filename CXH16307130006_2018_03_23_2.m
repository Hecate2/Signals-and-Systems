clear

syms k t

T=1;T1=1/4;
M=80;N=1000;    %N是每周期对xt采样的次数
dt=T/N;
xt=[ones(1,T1/dt),zeros(1,(T-2*T1)/dt),ones(1,T1/dt+1)]';
L=size(xt,1);   %L是xt矩阵的行数
ak=(1/T/L)*exp(-1i*(-M/2:1:M/2).'*(-N/2:1:N/2).*2*pi*dt/T)*xt;
k=[-M/2:M/2];
figure
plot(k,ak);
title('ak');

xt1=exp(1i*(-N/2:N/2)'*(-M/2:M/2)*2*pi*dt/T)*ak; %还原出时域信号
t=[-1/2:dt:1/2];
figure
plot(t,xt1)
title('还原的xt')



% clear
% 
% T=2;dt=0.0001;t=-2:dt:2;
% x1=heaviside(t)-heaviside(t-1-dt);x=0;
% for m=-1:1
%         x=x+heaviside(t-m*T)-heaviside(t-1-m*T-dt);
% end
% w0=2*pi/T;
% N=10;
% L=2*N+1;
% for k=-N:N
%     ak(N+1+k)=(1/T)*x1*exp(-1i*k*w0*t)*dt;
% end
% phi=angle(ak);