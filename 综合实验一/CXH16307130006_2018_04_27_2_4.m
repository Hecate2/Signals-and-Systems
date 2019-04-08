%对应题目2(4)，完全自动分析
%参考了网上大佬做语音识别的办法，用一段时间（代码中为一个Frame里）的能量和过零率来判断这是噪声还是语音(乐音)
%这段程序会画出很多个图，而且如果不安装voicebox工具箱，会报错
%也可以只把voicebox中的enframe.m函数拿来用
%voicebox用于语音识别，可以从噪声中找出哪些是语音

%安装voicebox工具箱:
%解压voicebox.zip，将整个目录voicebox复制到MATLAB的安装目录下的toolbox子文件夹中。例如：D:\MATLAB\R2018a\toolbox
%找到安装路径下的'...\MATLAB\R2018a\toolbox\local\pathdef.m'?文件，用其他文本编辑器打开
%在 %%% End Entries %%% 之前插入以下内容
%matlabroot,'\toolbox\voicebox;',...
%启动MATLAB，在MATLAB的命令行窗口输入rehash toolboxcache，并运行。这步需要一些时间。


clear all,close all%,clc
[Y,Fs]=audioread('fmt.wav');
[head,tail,beat]=segment(Y); %segment自动将音乐分段并分析每个音拍数
for  m=1:length(head)
    %返回每个音的开始和结束及拍数
    %提取每个音
    eval(['y',num2str(m),'=ExtractOneNote(Y,head(m),tail(m));']);
    %eval会新声明一些变量y1,y2,y3...y的下标为m的值。y[m]的值为ExtractOneNote函数的结果
end
for  m=1:28
    %傅里叶分析
    eval(['F',num2str(m),'=fouriernote(y',num2str(m),');']);
end
for  m=1:28
    %识别音调
    eval(['note',num2str(m),'=freq2note(findf(F',num2str(m),'));'
        ]);
end
for  m=1:28
    %清除多余变量F1到F28。也可以不清理。
    eval(['clear  F',num2str(m),]);
    eval(['clear  y',num2str(m),]);
end



function [head,tail,beat] = segment(x)   %自动将音乐分段并分析每个音拍数
%参考了网上大佬们的办法
%幅度归一化到[-1,1]
x = double(x);
x = x / max(abs(x));
%常数设置
FrameLen = 240; %FrameLen是时间窗口取值。看这段时间内的能量和过零率来判断乐音是否开始或结束。过零率是一段时间内变量改变正负号的次数
FrameInc = 80;
status  = 0;    %表示现在是不是一个乐音
%初始状态为非乐音状态
%计算短时能量
amp = sum(abs(enframe(filter([1 -0.9375], 1, x), FrameLen,FrameInc)), 2);
%我不知道voicebox工具箱中的enframe具体在干什么，直接拿来用了
%sum(A,2)返回一个列向量，存储了A矩阵每一行的和
%开始端点检测
p = 1;
%标记乐音序号
%初始门限
%记录该音最大幅值
ampmin=5;
ampmax=0;
for  n=1:length(amp)
    switch  status
        case  0
            % 0=非乐音状态
            %大于最低值
            %更新ampmax
            if amp(n) > (ampmin+2)
                if ampmax < amp(n)
                    ampmax = amp(n);
                end
                head(p) = n;
                status  = 1;
                %记录始端位置
                %进入乐音状态
            else
                status  = 0;
                if ampmin > amp(n)
                    ampmin = amp(n);
                end
                %保持非乐音状态
                %更新ampmin
            end
        case  1
            if ampmax < amp(n)
                ampmax = amp(n);
                % 1=乐音状态
                %更新ampmax并判断下一个点
            end
            if amp(n) < ampmax/2
                tail(p) = n;
                p=p+1;
                %幅度小于最大值一半判定结束
                %记录末端位置
                %序号+1
                status=0;
                ampmax=0;
                %进入非乐音状态
                %重置ampmax
                ampmin=amp(n);
            end
    end
end
subplot(211)
plot(x)
%音乐图像
axis([1 length(x) -1 1])
ylabel('Speech');
for n=1:length(head)      %红线为始端，黄线为末端
    line([head(n)*FrameInc head(n)*FrameInc], [-1 1],  'Color','red');
    line([tail(n)*FrameInc tail(n)*FrameInc], [-1 1],  'Color','yellow');
    
    
end
subplot(212)
plot(amp);
%短时平均能量图像
axis([1 length(amp) 0 max(amp)])
ylabel('Energy');
for  n=1:length(head)
    %红线为始端，黄线为末端
    line([head(n) head(n)], [min(amp),max(amp)],  'Color','red');
    line([tail(n) tail(n)], [min(amp),max(amp)],  'Color','yellow');
end
head=(head*80)';
tail=(tail*80)';
t=zeros(length(head));
for  m=1:length(head)-1
    t(m)=head(m+1)-head(m);
    if  t(m)<=2800
        %节拍判断
        %相邻节拍的始端间距
        %半拍
        beat(m)=0.5;
    elseif  t(m)>2800&&t(m)<=5600
        beat(m)=1;
        %一拍
    elseif  t(m)>5600&&t(m)<=11000
        beat(m)=2;
        %两拍
    elseif  t(m)>11000&&t(m)<=16000
        %三拍
        beat(m)=3;
    elseif t(m)>=16000 beat(m)=4;
    end
    %四拍
end
beat(m+1)=0;
beat=beat';
end


function note=ExtractOneNote(s,L,R) %从s中提取L、R两点间的一段数据
note=s(L:R);
end


function  F=fouriernote(y)
N=length(y);
t=linspace(0,(N-1)/8000,N);
f=y;
OMG=4000*pi;
K=4000;
omg=linspace(0,OMG-OMG/K,K)';
U=exp(-j*kron(omg,t));
F=(N-1)/8000/N*U*f;
F=abs(F);
%取绝对值
figure;
hold on, box  on;
plot(omg,real(F));
set(gca,'XLim',[0,4000*pi]);
xlabel('\omega');
ylabel('F(\omega)');
line([174.61*2*pi 174.61*2*pi], [0,max(F)],  'Color','red');  %在最低音和最高音处划线
line([659.25*2*pi 659.25*2*pi], [0,max(F)], 'Color', 'red');
end


function  f=findf(F)
[~,f]=max(F(360:1361));
if (F(round((f+360)/2))>(F(360+f)*3/7)&&(f>360))  %判断是否为谐波
    f=(f+360)/2-360;
end
f=(f-1+360)/2;
end


function  note=freq2note(f) %我不知道这些音的名字标得对不对！
if  f>=169&&f<179.61
    note='F';
elseif  f>=179.61&&f<190.5
    note='bG';
elseif  f>=190.5&&f<201.7
    note='G';
elseif  f>=201.7&&f<213.8
    note='bA';
elseif  f>=213.8&&f<226.5
    
    
    note='A';
elseif  f>=226.5&&f<240
    note='bB';
elseif  f>=240&&f<254.2
    note='B';
elseif  f>=254.2&&f<269.4
    note='C1';
elseif  f>=269.4&&f<285.4
    note='bD1';
elseif  f>=285.4&&f<302.4
    note='D1';
elseif  f>=302.4&&f<320.4
    note='bE1';
elseif  f>=320.4&&f<339.4
    note='E1';
elseif  f>=339.4&&f<359.6
    note='F1';
elseif  f>=359.6&&f<381
    note='bG1';
elseif  f>=381&&f<403.65
    note='G1';
elseif  f>=403.65&&f<427.6
    note='bA1';
elseif  f>=427.6&&f<453.1
    note='A1';
elseif  f>=453.1&&f<480
    note='bB1';
elseif  f>=480&&f<508.6
    note='B1';
elseif  f>=508.6&&f<538.8
    note='C2';
elseif  f>=538.8&&f<570.8
    note='bD2';
elseif  f>=570.8&&f<604.8
    note='D2';
elseif  f>=604.8&&f<640.75
    note='bE2';
elseif  f>=640.75&&f<=680
    note='E2';
end
end