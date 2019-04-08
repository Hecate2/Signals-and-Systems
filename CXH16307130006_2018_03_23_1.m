clear

syms n k
N=10;N1=2;
xn=[ones(1,N1),zeros(1,N-2*N1-1),ones(1,N1+1)]';
xn=[xn];
k=[1:1:N];
ak=(1/N)*dftmtx(N)*xn;
figure
stem(k,abs(ak));
title('N=10,N1=2');

clear

syms n k
N=10;N1=1;
xn=[ones(1,N1),zeros(1,N-2*N1-1),ones(1,N1+1)]';
xn=[xn];
k=[1:1:N];
ak=(1/N)*dftmtx(N)*xn;
figure
stem(k,abs(ak));
title('N=10,N1=1');

clear

syms n k
N=20;N1=2;
xn=[ones(1,N1),zeros(1,N-2*N1-1),ones(1,N1+1)]';
xn=[xn];
k=[1:1:N];
ak=(1/N)*dftmtx(N)*xn;
figure
stem(k,abs(ak));
title('N=20,N1=2');


% clear
% 
% syms n k
% k=-15:1:15;	%如果fplot出错则使用这行代码
% N=10;N1=2;
% ak=symsum((1/N)*exp(-1i*k*2*pi*n./N),-N1,N1);
% figure
% stem(k,ak);    %如果fplot出错则使用这行代码
% %fplot(k,ak,[-15,15]);
% title('N=10,N1=2');
% 
% clear
% 
% syms n k
% k=-15:1:15;	%如果fplot出错则使用这行代码
% N=10;N1=1;
% ak=symsum((1/N)*exp(-1i*k*2*pi*n./N),-N1,N1);
% figure
% stem(k,ak);	%如果fplot出错则使用这行代码
% %fplot(k,ak,[-15,15]);
% title('N=10,N1=1');
% 
% clear
% 
% syms n k
% k=-30:1:30;	%如果fplot出错则使用这行代码
% N=20;N1=2;
% ak=symsum((1/N)*exp(-1i*k*2*pi*n./N),-N1,N1);
% figure
% stem(k,ak);	%如果fplot出错则使用这行代码
% %fplot(k,ak,[-30,30]);
% title('N=20,N1=2');


% N=10;N1=2
% xn=[ones(1,2*N1+1),zeros(1,N-2*N1-1)];
% xn=[xn,xn,xn];
% n=0:3*N-1;
% k=0:3*N-1;
% Xk=xn*exp(-j*2*pi/N).^(n'*k);  %离散傅里叶级数变换
% x=Xk*exp(j*2*pi/N).^(n'*k)/(3*3*N);  %离散傅里叶级数 逆变换
% %subplot(2,2,1),stem(n,xn);
% %title('x(n)');
% %axis([-1,3*N,1.1*min(xn),1.1*max(xn)]);
% %subplot(2,2,2),stem(n,abs(x));   %显示逆变换结果
% %title('IDFS|X(k)|');
% %axis([-1,3*N,1.1*min(x),1.1*max(x)]);
% subplot(2,2,3),stem(k,abs(Xk));  %显示序列的幅度谱
% title('|X(k)|');
% axis([-1,3*N,1.1*min(abs(Xk)),1.1*max(abs(Xk))]);
% %subplot(2,2,4),
% %stem(k,angle(Xk));  %显示序列的相位谱
% %title('arg|X(k)|'); 
% %axis([-1,3*N,1.1*min(angle(Xk)), 1.1*max(angle(Xk))]);