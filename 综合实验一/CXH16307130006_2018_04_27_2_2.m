%对应题目2(2)
%去除realwave中的噪声和非线性谐波，并与Guitar.mat中的wave2proc比较（这个函数处理得到的结果将与wave2proc完全相同）


clear;clc;
load Guitar.mat;
%realwave里有243个数值点
wave=resample(realwave,250,243);    %重采样，将点数变为250
w=zeros(1,25);
for i=1:25
    for k=0:9
        w(i)=w(i)+wave(25*k+i);		%10个周期的对应点分别求和
    end
end
w=w/10;             %取平均值
wave2=repmat(w,1,10);       %将1个周期的10个点延拓至250个点
wave2=resample(wave2,243,250); %重采样，将点数变回243
hold on,plot(wave2,'r'),hold off; %将处理后的数据绘出，红色
hold on,plot(wave2proc); %将所给的数据绘出，蓝色
%蓝线完全盖住了红线。也就是处理后的realwave和wave2proc完全相同
