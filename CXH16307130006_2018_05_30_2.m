clear

t=[-4:0.1:4]';
yt=exp(t);

compressed=compand(yt,87.6,max(yt),'a/compressor');
%30级量化
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
title('采用不同量化方法,进行31级量化的结果比较');
plot(t,[yt Qt Err QtDirect ErrDirect]);
legend('原信号','A律压缩后，均匀量化再还原的信号','A律压缩后，均匀量化再还原的误差','直接量化','直接量化的误差','Location','Best');
