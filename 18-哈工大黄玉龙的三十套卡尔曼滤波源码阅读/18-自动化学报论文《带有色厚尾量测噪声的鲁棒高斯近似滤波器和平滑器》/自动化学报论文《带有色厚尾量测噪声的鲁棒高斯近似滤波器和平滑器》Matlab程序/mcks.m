function [xkNA,PkNA]=mcks(xi,Pi,zA,ts,Q,R0,v,N)

%%%%��ʼ����
nx=size(xi,1);
nz=size(zA,1);
E_lamda=ones(1,ts);

for i=1:N

    %%%%�˲���ֵ
    xkk=xi;
    Pkk=Pi;
    %%%%�˲��洢
    xkkA=xkk;
    PkkA=Pkk;
    xkk_1A=[];
    Pkk_1A=[];
    Pk_1kk_1A=[]; 
    
    for t=1:ts
        
        %%%%%����R
        R=R0/E_lamda(t);
        
        %%%%%%�����˲�����
        [xkk,Pkk,xkk_1,Pkk_1,Pk_1kk_1]=ckf(xkk,Pkk,zA(:,t),Q,R);   
        
        %%%%�˲��洢
        xkkA=[xkkA xkk];
        PkkA=[PkkA Pkk];
        xkk_1A=[xkk_1A xkk_1];
        Pkk_1A=[Pkk_1A Pkk_1];
        Pk_1kk_1A=[Pk_1kk_1A Pk_1kk_1];

    end
    
    %%%%ƽ����ֵ
    xkN=xkk;
    PkN=Pkk;
    
    %%%%ƽ���洢
    xkNA=xkN;
    PkNA=PkN;

    for t=(ts-1):-1:0
        
        %%%%%%��ȡ�˲�����
        xkk=xkkA(:,t+1);
        Pkk=PkkA(:,t*nx+1:(t+1)*nx);
        xkk_1=xkk_1A(:,t+1);
        Pkk_1=Pkk_1A(:,t*nx+1:(t+1)*nx);
        Pk_1kk_1=Pk_1kk_1A(:,t*nx+1:(t+1)*nx);
        
        %%%%%%����ƽ������
        [xkN,PkN,Ks]=cks(xkN,PkN,xkk,Pkk,xkk_1,Pkk_1,Pk_1kk_1);
        
        %%%%ƽ���洢
        xkNA=[xkN xkNA];
        PkNA=[PkN PkNA];

    end
    
    for t=1:ts
        
        %%%%%%%%%%%��ȡ�������
        xkN=xkNA(:,t+1);
        PkN=PkNA(:,t*nx+1:(t+1)*nx);
        z=zA(:,t);
        
        %%%%%%%%%%%���㸨����
        XkN=CR(xkN,PkN);
        F_R=(repmat(z,1,2*nx)-ckf_Mst(XkN))*(repmat(z,1,2*nx)-ckf_Mst(XkN))'/(2*nx);
        
        %%%%%%%%%%%����lamda�ľ�ֵ
        gama=trace(F_R*inv(R0));
        E_lamda(t)=(v+nz)/(v+gama);

    end

end
