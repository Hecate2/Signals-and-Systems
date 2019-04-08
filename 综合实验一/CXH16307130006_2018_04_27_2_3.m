%对应2(3)
%输出的X是基频和谐波的频率


clear all, close all,  clc;
load('guitar.mat');
N=length(wave2proc)*10;
%重复10次
t=linspace(0,(N-1)/8000,N);
f=[wave2proc;wave2proc;wave2proc;wave2proc;wave2proc;
wave2proc;wave2proc;wave2proc;wave2proc;wave2proc]; %10个wave2proc
OMG=6000*pi;
K=6000;
omg=linspace(0,OMG-OMG/K,K)';
U=exp(-j*kron(omg,t));
F=(N-1)/8000/N*U*f;
F=abs(F);
%取绝对值
[X(1),Y(1)]=maxp(0,2500,omg,F);    %基波的频率和幅度
[X(2),Y(2)]=maxp(2500,5000,omg,F);   %二次谐波的频率和幅度，下为三至七次谐波的频率和幅度
[X(3),Y(3)]=maxp(5000,7500,omg,F);
[X(4),Y(4)]=maxp(7500,10000,omg,F);
[X(5),Y(5)]=maxp(10000,12000,omg,F);
[X(6),Y(6)]=maxp(12000,14000,omg,F);
[X(7),Y(7)]=maxp(14000,16000,omg,F);
X=X';
Y=Y';
  
 
figure;
hold on, box  on;
plot(omg,F);
set(gca,'XLim',[0,6000*pi]);
xlabel('\omega');
ylabel('F(\omega)');


function [X,Y]=maxp(L,R,omg,F)   %返回[L,R]区间内，F取最大值时的omg和F
[Y,x]=max(F(omg>L&omg<R));
z=omg(omg>L&omg<R);
X=z(x)/2/pi;    %将omg角频率换算为频率
end
