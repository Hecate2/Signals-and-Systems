%��Ӧ��Ŀ2(4)����ȫ�Զ�����
%�ο������ϴ���������ʶ��İ취����һ��ʱ�䣨������Ϊһ��Frame��������͹��������ж�����������������(����)
%��γ���ử���ܶ��ͼ�������������װvoicebox�����䣬�ᱨ��
%Ҳ����ֻ��voicebox�е�enframe.m����������
%voicebox��������ʶ�𣬿��Դ��������ҳ���Щ������

%��װvoicebox������:
%��ѹvoicebox.zip��������Ŀ¼voicebox���Ƶ�MATLAB�İ�װĿ¼�µ�toolbox���ļ����С����磺D:\MATLAB\R2018a\toolbox
%�ҵ���װ·���µ�'...\MATLAB\R2018a\toolbox\local\pathdef.m'?�ļ����������ı��༭����
%�� %%% End Entries %%% ֮ǰ������������
%matlabroot,'\toolbox\voicebox;',...
%����MATLAB����MATLAB�������д�������rehash toolboxcache�������С��ⲽ��ҪһЩʱ�䡣


clear all,close all%,clc
[Y,Fs]=audioread('fmt.wav');
[head,tail,beat]=segment(Y); %segment�Զ������ֶַβ�����ÿ��������
for  m=1:length(head)
    %����ÿ�����Ŀ�ʼ�ͽ���������
    %��ȡÿ����
    eval(['y',num2str(m),'=ExtractOneNote(Y,head(m),tail(m));']);
    %eval��������һЩ����y1,y2,y3...y���±�Ϊm��ֵ��y[m]��ֵΪExtractOneNote�����Ľ��
end
for  m=1:28
    %����Ҷ����
    eval(['F',num2str(m),'=fouriernote(y',num2str(m),');']);
end
for  m=1:28
    %ʶ������
    eval(['note',num2str(m),'=freq2note(findf(F',num2str(m),'));'
        ]);
end
for  m=1:28
    %����������F1��F28��Ҳ���Բ�����
    eval(['clear  F',num2str(m),]);
    eval(['clear  y',num2str(m),]);
end



function [head,tail,beat] = segment(x)   %�Զ������ֶַβ�����ÿ��������
%�ο������ϴ����ǵİ취
%���ȹ�һ����[-1,1]
x = double(x);
x = x / max(abs(x));
%��������
FrameLen = 240; %FrameLen��ʱ�䴰��ȡֵ�������ʱ���ڵ������͹��������ж������Ƿ�ʼ���������������һ��ʱ���ڱ����ı������ŵĴ���
FrameInc = 80;
status  = 0;    %��ʾ�����ǲ���һ������
%��ʼ״̬Ϊ������״̬
%�����ʱ����
amp = sum(abs(enframe(filter([1 -0.9375], 1, x), FrameLen,FrameInc)), 2);
%�Ҳ�֪��voicebox�������е�enframe�����ڸ�ʲô��ֱ����������
%sum(A,2)����һ�����������洢��A����ÿһ�еĺ�
%��ʼ�˵���
p = 1;
%����������
%��ʼ����
%��¼��������ֵ
ampmin=5;
ampmax=0;
for  n=1:length(amp)
    switch  status
        case  0
            % 0=������״̬
            %�������ֵ
            %����ampmax
            if amp(n) > (ampmin+2)
                if ampmax < amp(n)
                    ampmax = amp(n);
                end
                head(p) = n;
                status  = 1;
                %��¼ʼ��λ��
                %��������״̬
            else
                status  = 0;
                if ampmin > amp(n)
                    ampmin = amp(n);
                end
                %���ַ�����״̬
                %����ampmin
            end
        case  1
            if ampmax < amp(n)
                ampmax = amp(n);
                % 1=����״̬
                %����ampmax���ж���һ����
            end
            if amp(n) < ampmax/2
                tail(p) = n;
                p=p+1;
                %����С�����ֵһ���ж�����
                %��¼ĩ��λ��
                %���+1
                status=0;
                ampmax=0;
                %���������״̬
                %����ampmax
                ampmin=amp(n);
            end
    end
end
subplot(211)
plot(x)
%����ͼ��
axis([1 length(x) -1 1])
ylabel('Speech');
for n=1:length(head)      %����Ϊʼ�ˣ�����Ϊĩ��
    line([head(n)*FrameInc head(n)*FrameInc], [-1 1],  'Color','red');
    line([tail(n)*FrameInc tail(n)*FrameInc], [-1 1],  'Color','yellow');
    
    
end
subplot(212)
plot(amp);
%��ʱƽ������ͼ��
axis([1 length(amp) 0 max(amp)])
ylabel('Energy');
for  n=1:length(head)
    %����Ϊʼ�ˣ�����Ϊĩ��
    line([head(n) head(n)], [min(amp),max(amp)],  'Color','red');
    line([tail(n) tail(n)], [min(amp),max(amp)],  'Color','yellow');
end
head=(head*80)';
tail=(tail*80)';
t=zeros(length(head));
for  m=1:length(head)-1
    t(m)=head(m+1)-head(m);
    if  t(m)<=2800
        %�����ж�
        %���ڽ��ĵ�ʼ�˼��
        %����
        beat(m)=0.5;
    elseif  t(m)>2800&&t(m)<=5600
        beat(m)=1;
        %һ��
    elseif  t(m)>5600&&t(m)<=11000
        beat(m)=2;
        %����
    elseif  t(m)>11000&&t(m)<=16000
        %����
        beat(m)=3;
    elseif t(m)>=16000 beat(m)=4;
    end
    %����
end
beat(m+1)=0;
beat=beat';
end


function note=ExtractOneNote(s,L,R) %��s����ȡL��R������һ������
note=s(L:R);
end


function  F=fouriernote(y)
N=length(y);
t=linspace(0,(N-1)/8000,N);
f=y;
OMG=4000*pi;
K=4000;
omg=linspace(0,OMG-OMG/K,K)';
U=exp(-j*kron(omg,t));
F=(N-1)/8000/N*U*f;
F=abs(F);
%ȡ����ֵ
figure;
hold on, box  on;
plot(omg,real(F));
set(gca,'XLim',[0,4000*pi]);
xlabel('\omega');
ylabel('F(\omega)');
line([174.61*2*pi 174.61*2*pi], [0,max(F)],  'Color','red');  %��������������������
line([659.25*2*pi 659.25*2*pi], [0,max(F)], 'Color', 'red');
end


function  f=findf(F)
[~,f]=max(F(360:1361));
if (F(round((f+360)/2))>(F(360+f)*3/7)&&(f>360))  %�ж��Ƿ�Ϊг��
    f=(f+360)/2-360;
end
f=(f-1+360)/2;
end


function  note=freq2note(f) %�Ҳ�֪����Щ�������ֱ�öԲ��ԣ�
if  f>=169&&f<179.61
    note='F';
elseif  f>=179.61&&f<190.5
    note='bG';
elseif  f>=190.5&&f<201.7
    note='G';
elseif  f>=201.7&&f<213.8
    note='bA';
elseif  f>=213.8&&f<226.5
    
    
    note='A';
elseif  f>=226.5&&f<240
    note='bB';
elseif  f>=240&&f<254.2
    note='B';
elseif  f>=254.2&&f<269.4
    note='C1';
elseif  f>=269.4&&f<285.4
    note='bD1';
elseif  f>=285.4&&f<302.4
    note='D1';
elseif  f>=302.4&&f<320.4
    note='bE1';
elseif  f>=320.4&&f<339.4
    note='E1';
elseif  f>=339.4&&f<359.6
    note='F1';
elseif  f>=359.6&&f<381
    note='bG1';
elseif  f>=381&&f<403.65
    note='G1';
elseif  f>=403.65&&f<427.6
    note='bA1';
elseif  f>=427.6&&f<453.1
    note='A1';
elseif  f>=453.1&&f<480
    note='bB1';
elseif  f>=480&&f<508.6
    note='B1';
elseif  f>=508.6&&f<538.8
    note='C2';
elseif  f>=538.8&&f<570.8
    note='bD2';
elseif  f>=570.8&&f<604.8
    note='D2';
elseif  f>=604.8&&f<640.75
    note='bE2';
elseif  f>=640.75&&f<=680
    note='E2';
end
end