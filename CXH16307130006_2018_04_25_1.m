clear

syms s t

x(t)=sin(3*t)*heaviside(t);
figure
fplot(t,x(t),[-1,5]);
title('输入信号波形');

X(s)=laplace(x(t),t,s);
H(s)=10/(s+1);
Y(s)=H(s)*X(s);
y(t)=ilaplace(Y(s),s,t);
%figure
%fplot(s,Y(s));
figure
fplot(t,y(t));
title('输出信号波形');