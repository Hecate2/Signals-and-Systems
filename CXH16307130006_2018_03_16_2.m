%���ַ���y[n]-0.9y[n-1]=0.05x[n]��x[n]=u[n]
clear

%y(n)=sym(maple('rsolve({y(n)-0.9*y(n-1)=0.05*x(n),y(-1)=0},y(n))'));
Y=[1 -0.9];
X=[0.05 0];
n=1:50;

%y[-1]=0
y0=filter(X,Y,heaviside(n));
figure(1)
stem(n,y0,'k','f');
ylabel('y[n]')
xlabel('n')
title('y[n]-0.9y[n-1]=0.05x[n]��x[n]=u[n],y[-1]=0')

%y[-1]=1
xin=filtic(X,Y,1);
y1=filter(X,Y,dirac(n),xin);%dirac����ɢ�弤����
figure(2)
stem(n,y1,'k','f');
ylabel('y[n]')
xlabel('n')
title('y[n]-0.9y[n-1]=0.05x[n]��x[n]=u[n],y[-1]=1')


%��λ������Ӧ
h=impz(X,Y,n);
figure(3)
stem(n,h,'k','f');
ylabel('������Ӧh[n]')
xlabel('n')
title('y[n]-0.9y[n-1]=0.05x[n]��x[n]=u[n],��λ������Ӧ')

%filter����
%Y = filter(B,A,X) ������XΪ�˲�ǰ���У�YΪ�˲�������У�B/A �ṩ�˲���ϵ����BΪ���ӣ� AΪ��ĸ 
%�����˲�������ͨ�������ַ���ʵ�ֵģ�
%a(1)*y(n) = b(1)*x(n) + b(2)*x(n-1) + ... + b(nb+1)*x(n-nb) - a(2)*y(n-1) - ... - a(na+1)*y(n-na) 
%[Y,Zf] = filter(B,A,X,Zi)������XΪ�˲�ǰ���У�YΪ�˲�������У�B/A �ṩ�˲���ϵ����BΪ���ӣ� AΪ��ĸ��