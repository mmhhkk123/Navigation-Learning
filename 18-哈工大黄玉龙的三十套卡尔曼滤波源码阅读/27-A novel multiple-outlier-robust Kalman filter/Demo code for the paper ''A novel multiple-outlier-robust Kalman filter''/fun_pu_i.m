function Pu=fun_pu_i(c,sigma,v,flag)

n=size(c,1);

sigma2=sigma^2;

pu=zeros(n,1);

for i=1:n
    
    %%%%%%%%%%
    ci=c(i);

    %%%%%%%%%%��һ��ѡ��
    if flag==1
        pu(i)=exp(0.5/sigma2*(1-ci));
    end
    
    %%%%%%%%%%�ڶ���ѡ��
    if flag==2
        pu(i)=(v+1)/(v+ci);
    end
    
    %%%%%%%%%%������ѡ��
    if flag==3
        pu(i)=sqrt((v+1)/(v+ci));
    end
    
    %%%%%%%%%%��ֹ����
    if pu(i)<1e-8
        pu(i)=pu(i)+1e-8;
    end

end

Pu=diag(pu);