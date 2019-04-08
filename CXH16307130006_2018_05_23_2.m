clear
%����10��1��ĸ�˹�������������˹������������غ����͹������ܶȣ�����ͼ��

dt=0.001;
t=0:dt:1;
corr=zeros(2/dt+1,1);
tries=100;   %��100�ο�ƽ��ֵ
for i=1:tries
    GN=wgn(1/dt+1,1,2);
    
    corr=xcorr(GN,GN)/tries;
    
end


figure
plot(t,GN);
title('���ɵ�һ����˹������');
xlabel('t')
ylabel('���');

t=[-1:dt:1];
figure
plot(t,corr);
title('��˹�������������');
xlabel('\tau');
ylabel('R(\tau)');


%�������ܶ�
dw=dt*10*pi;
w=[-10*pi:dw:10*pi]';
Sw=dt*exp(-1i*w*t)*corr;
figure
plot(w,Sw);
title('�������ܶ�')


t=0:dt:1;