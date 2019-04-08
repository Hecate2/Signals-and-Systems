clear

%��ʱ���Ƶ�򷽷��ֱ����x1,x2�Ļ����

dt=0.001;
t=[-2:dt:2]';
x1t=[ones(1,1+1/dt) 2*ones(1,1/dt)]';
x2t=[ones(1,1+1/dt) zeros(1,1/dt)]';
corr=dt*xcorr(x1t,x2t);

figure(1)
plot(t,corr);
xlabel('t');
ylabel('corr(x1,x2)');
title('ʱ�����');
hold on

%��x1t,x2t�任��Ƶ��[-10pi.10pi]
t=[0:dt:2];
dw=dt*10*pi;
w=[-10*pi:dw:10*pi]';
% x1t=[zeros(1,2/dt) x1t];
% x2t=[zeros(1,2/dt) x2t];
X1w=dt*exp(-1i*w*t)*x1t;
X2w=dt*exp(-1i*w*t)*x2t;

Fcorr=X1w.*conj(X2w);
%��Fcorr���ʱ��
t=[-2:dt:2];
fcorr=(1/2/pi)*(exp(1i*(t')*(w')))*Fcorr*dw;

plot(t,fcorr);
legend('x1t','x2t');

figure(2)    %X1w,X2w����w��ͼ��
plot(w,abs(X1w));
hold on
plot(w,abs(X2w));
title('|X1\omega|,|X2\omega|');
xlabel('\omega');
legend('|X1\omega|','|X2\omega|');