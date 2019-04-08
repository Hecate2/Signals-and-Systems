clear

t=0:1/8192:1;
y=[sin(2*pi*349.23*t) sin(2*pi*349.23*2*t)];
sound(y,8192);