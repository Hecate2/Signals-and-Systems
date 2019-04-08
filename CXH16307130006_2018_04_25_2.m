clear

syms s t

% sigma=[-0.06:0.03:0.06];
% sigma=[sigma;sigma;sigma];
% omega=[0.5:-0.25:0]'*1i;
% omega=[omega omega omega omega omega];


for im=0:0.25:0.5
    figure
    for re=-0.06:0.03:0.06
        p=re+im*1i;
        F(s)=1/(s-p);
        f(t)=ilaplace(F(s),s,t);
        fplot(t,real(f(t)),[-20 20],'DisplayName',num2str(p));
        hold on
    end
    legend('show','Location','best')
    hold off
end
