%对应题目1(4)或3(2)（有谐波，但还不是很好听）

% 1=F 2/4 |5 (56)|
% 东方红 太阳升

clear;clc
f0=349.23*2^(-2/12);    %这里可以主观修改一下音调

fs=10000;   %抽样频率
f=[f0*2^(5/12) f0*2^(5/12) f0*2^(0/12) f0*2^(5/12) f0*2^(8/12) f0*2^(7/12) f0*2^(5/12) f0*2^(7/12) ...
   ...
]/2;  %随便写的音调。这不是东方红
time=fs*[1 0.5 0.5 2 1 0.5 0.5 2];

N=length(time);	%这段音乐的总抽样点数
east=zeros(1,N);	%用east向量来储存抽样点
%可能是因为曲名东方红，所以网上大佬都用east做变量名？
n=1;
for num=1:N		%产生抽样数据，num表示乐音编号
    t=1/fs:1/fs:(time(num))/fs;		%产生第num个乐音的抽样点
    P=zeros(1,time(num));		%P为存储包络数据的向量
L=(time(num))*[0 1/5 333/1000 333/500 1];
								%包络线端点对应的横坐标
    T=[0 1.5 1 1 0];				%包络线端点对应的纵坐标
    s=1;
    b=1:1:time(num);		%产生包络线抽样点
    for k=1:4   P(s:L(k+1)-1)=(T(k+1)-T(k))/(L(k+1)-L(k))*(b(s:L(k+1)-1)-L(k+1)*ones(1,L(k+1)-s))+T(k+1)*ones(1,L(k+1)-s);
						%包络线直线方程通式
        s=L(k+1);
    end
    m=[1 0.3 0.2];		    %波形幅值矩阵
    ss=zeros(1,length(t));
    for i=1:length(m)
        ss=ss+m(i)*sin(2*i*pi*f(num)*t);		%加谐波
    end
east(n:n+time(num)-1)=ss.*P(1:time(num)); 
%给第num个乐音加上包络
    n=n+time(num);
end
sound(2*east,8192*2);
plot(east);
