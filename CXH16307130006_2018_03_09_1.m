clear

syms x t;

x(t)=sin(2*pi*t)*heaviside(t);
y(t)=exp(-t)*heaviside(t);
z1(t)=2*x(t)
z2(t)=x(t-0.5)
z3(t)=x(2*t)
z4(t)=x(t)+y(t)
z5(t)=x(t)*y(t)

figure (1)
fplot(t,z1,[-1 2])
title('z1(t)=2*sin(2*pi*t)*heaviside(t)')
grid on
figure (2)
fplot(t,z2,[-1 2])
title('z2(t)=heaviside(t - 1/2)*sin(2*pi*(t - 1/2))')
grid on
figure (3)
fplot(t,z3,[-1 2])
title('z3(t)=sin(4*pi*t)*heaviside(t)')
grid on
figure (4)
fplot(t,z4,[-1 2])
title('z4(t)=exp(-t)*heaviside(t) + sin(2*pi*t)*heaviside(t)')
grid on
figure (5)
fplot(t,z5,[-1 2])
title('z5(t)=exp(-t)*sin(2*pi*t)*heaviside(t)^2')
grid on