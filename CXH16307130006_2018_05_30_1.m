clear

dt=0.001;
t=(0:dt:2*pi)';
yt=sin(t);

[~,Qyt11]=quantiz(yt,-1+2/10:2/10:1,-1:2/10:1);
Qyt11=Qyt11';
Err11=Qyt11-yt;

figure
plot(t,[yt Qyt11 Err11]);
legend('����ǰ','������','���');
title('11������');

[a,Qyt21]=quantiz(yt,-1+2/20:2/20:1,-1:2/20:1);
Qyt21=Qyt21';
Err21=Qyt21-yt;

figure
plot(t,[yt Qyt21 Err21]);
legend('����ǰ','������','���');
title('21������');