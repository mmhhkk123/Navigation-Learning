function [xkk,Pkk,Pu_x,Pu_z]=ssmkf_2(xkk,Pkk,F,H,z,Q,R,sigma,v,N,flag)

%%%%%%׼��
nx=size(xkk,1);

nz=size(z,1);

%%%%%ʱ�����
xk1k=F*xkk;

Pk1k=F*Pkk*F'+Q;
%%%%%�������
xkk=xk1k;

Pkk=Pk1k;

%%%%%���㷽��
Sk1k=utchol(Pk1k);

SR=utchol(R);

I_Sk1k=inv(Sk1k);

I_SR=inv(SR);

Pu_x=eye(nx);

Pu_z=eye(nz);

for i=1:N
    
    %%%%%%%
    xkk_i=xkk;
      
    %%%%%%%����IMCCKF״̬����
    D_Pk1k=Sk1k*inv(Pu_x)*Sk1k';

    D_R=SR*inv(Pu_z)*SR';

    zk1k=H*xk1k;
    
    Pzzk1k=H*D_Pk1k*H'+D_R;
    
    Pxzk1k=D_Pk1k*H';
    
    Kk=Pxzk1k*inv(Pzzk1k);
    
    xkk=xk1k+Kk*(z-zk1k);
    
    Pkk=D_Pk1k-Kk*H*D_Pk1k;
    
    %%%%%%%%�ж�
    td=norm(xkk-xkk_i)/norm(xkk);
    
    if td<=1e-16
        break;
    end

    %%%%%%���㸨������
    Dk1=(xkk-xk1k)*(xkk-xk1k)'+Pkk;
    
    Dk2=(z-H*xkk)*(z-H*xkk)'+H*Pkk*H';
    
    ex=diag(I_Sk1k*Dk1*I_Sk1k');
    
    ez=diag(I_SR*Dk2*I_SR');
    
    Pu_x=fun_pu_i(ex,sigma,v,flag);
    
    Pu_z=fun_pu_i(ez,sigma,v,flag);

end