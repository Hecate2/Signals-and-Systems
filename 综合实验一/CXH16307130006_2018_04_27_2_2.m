%��Ӧ��Ŀ2(2)
%ȥ��realwave�е������ͷ�����г��������Guitar.mat�е�wave2proc�Ƚϣ������������õ��Ľ������wave2proc��ȫ��ͬ��


clear;clc;
load Guitar.mat;
%realwave����243����ֵ��
wave=resample(realwave,250,243);    %�ز�������������Ϊ250
w=zeros(1,25);
for i=1:25
    for k=0:9
        w(i)=w(i)+wave(25*k+i);		%10�����ڵĶ�Ӧ��ֱ����
    end
end
w=w/10;             %ȡƽ��ֵ
wave2=repmat(w,1,10);       %��1�����ڵ�10����������250����
wave2=resample(wave2,243,250); %�ز��������������243
hold on,plot(wave2,'r'),hold off; %�����������ݻ������ɫ
hold on,plot(wave2proc); %�����������ݻ������ɫ
%������ȫ��ס�˺��ߡ�Ҳ���Ǵ�����realwave��wave2proc��ȫ��ͬ
