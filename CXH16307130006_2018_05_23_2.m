clear
%生成10个1秒的高斯白噪声，计算高斯白噪声的自相关函数和功率谱密度，画出图形

dt=0.001;
t=0:dt:1;
corr=zeros(2/dt+1,1);
tries=100;   %做100次看平均值
for i=1:tries
    GN=wgn(1/dt+1,1,2);
    
    corr=xcorr(GN,GN)/tries;
    
end


figure
plot(t,GN);
title('生成的一个高斯白噪声');
xlabel('t')
ylabel('振幅');

t=[-1:dt:1];
figure
plot(t,corr);
title('高斯白噪声的自相关');
xlabel('\tau');
ylabel('R(\tau)');


%功率谱密度
dw=dt*10*pi;
w=[-10*pi:dw:10*pi]';
Sw=dt*exp(-1i*w*t)*corr;
figure
plot(w,Sw);
title('功率谱密度')


t=0:dt:1;