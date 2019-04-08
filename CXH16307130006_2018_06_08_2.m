clear

dt=0.001;
t=[0:dt:4]';
tpiece=1/16;    %最小时间片
s1t=sin(2*pi*1.6*t);
s2t=square(2*pi*0.8*t);
s3t=sawtooth(2*pi*0.4*t);

figure
title('画出三路信号');
plot(t,[s1t s2t s3t]);
legend('正弦','方波','锯齿波');
xlabel('t');
axis([0 4 -1.1 1.1]);

remain(1)=0;
samp=s1t(1);
for ti=0:dt:4   %ti是当前时间
    if (ti==2)
       1; 
    end
    subscript=ti/dt+1;  %subscript即下标，可以用来取出信号序列的一个值
    remain(2)=rem((ti/tpiece),8);
    if( remain(1)<floor(remain(2)) || ( remain(1)==7 && floor(remain(2))==0 ) )
        remain(1)=floor(remain(2));
        switch(remain(1))
            case 0
                samp=s1t(floor(subscript));
            case 1
                samp=0;
            case 2
                samp=s2t(floor(subscript));
            case 3
                samp=0;
            case 4
                samp=s3t(floor(subscript));
            case 5
                samp=0;
            case 6
                %samp=s4t(floor(subscript));
                samp=0;
            case 7
                samp=0;
        end
    end
    out(round(subscript))=samp;   %ti时刻的输出值
end
figure
plot(t,out);
title('PAM四路时分复用输出');

% %对时域波形采样。
% sampOmega=2*pi*10; %采样角频率！角频率！
% sampFreq=sampOmega/2/pi;%采样频率
%
% %N=length(xt)/sampFreq;%需要采样的点数
% samp1=downsample(s1t,1/sampFreq/dt);
% %,(rem(length(xt),1/sampFreq/dt)-1)/2
% Tsamp1=(reshape((samp1*ones(1,1/sampFreq/dt))',1,ceil(length(samp1)/sampFreq/dt)))';
% tsamp1=[0:8/length(Tsamp1):8-8/length(Tsamp1)];
%
% %N=length(xt)/sampFreq;%需要采样的点数
% samp2=downsample(s2t,1/sampFreq/dt);
% %,(rem(length(xt),1/sampFreq/dt)-1)/2
% Tsamp2=(reshape((samp2*ones(1,1/sampFreq/dt))',1,ceil(length(samp1)/sampFreq/dt)))';
% tsamp2=[0:8/length(Tsamp2):8-8/length(Tsamp2)];
%
% %N=length(xt)/sampFreq;%需要采样的点数
% samp3=downsample(s3t,1/sampFreq/dt);
% %,(rem(length(xt),1/sampFreq/dt)-1)/2
% Tsamp3=(reshape((samp3*ones(1,1/sampFreq/dt))',1,ceil(length(samp3)/sampFreq/dt)))';
% tsamp3=[0:8/length(Tsamp3):8-8/length(Tsamp3)];
%
% figure
% subplot(311);
% plot(tsamp1,Tsamp1);
% title('正弦波采样结果');
% subplot(312);
% plot(tsamp2,Tsamp2);
% title('方波采样结果');
% subplot(313);
% plot(tsamp3,Tsamp3);
% title('锯齿波采样结果');
%
