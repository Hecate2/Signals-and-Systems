clear

t=[-4:0.1:4]';
yt=exp(t);

compressed=compand(yt,87.6,max(yt),'a/compressor');
%30������
[~,Qcompressed]=quantiz(compressed,...
min(compressed)+(max(compressed)-min(compressed))/30:(max(compressed)-min(compressed))/30:max(compressed),...
min(compressed):(max(compressed)-min(compressed))/30:max(compressed));
Qcompressed=Qcompressed';
Qt=[compand(Qcompressed,87.6,max(compressed),'a/expander')]';
Err=Qt-yt;

[~,QtDirect]=quantiz(yt,...
min(yt)+(max(yt)-min(yt))/30:(max(yt)-min(yt))/30:max(yt),...
min(yt):(max(yt)-min(yt))/30:max(yt));
QtDirect=QtDirect';
ErrDirect=QtDirect-yt;

figure
title('���ò�ͬ��������,����31�������Ľ���Ƚ�');
plot(t,[yt Qt Err QtDirect ErrDirect]);
legend('ԭ�ź�','A��ѹ���󣬾��������ٻ�ԭ���ź�','A��ѹ���󣬾��������ٻ�ԭ�����','ֱ������','ֱ�����������','Location','Best');
