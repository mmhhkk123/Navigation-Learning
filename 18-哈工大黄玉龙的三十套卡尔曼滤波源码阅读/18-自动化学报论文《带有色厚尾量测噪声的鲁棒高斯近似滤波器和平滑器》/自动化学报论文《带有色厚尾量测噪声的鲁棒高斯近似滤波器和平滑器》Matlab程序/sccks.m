function [xkNA,PkNA]=sccks(xs,Ps,yA,Q,phi,ts,R)

%%%%��ʼ����
nx=size(xs,1);

%%%%�˲���ֵ
xkk=xs;
Pkk=Ps;

%%%%�˲��洢
xkkA=xkk;
PkkA=Pkk;
xk_1kA=[];
Pk_1kA=[];
KsA=[];

for t=1:ts
    
    y=yA(:,t);
        
    %%%%%%�����˲�����
    [xkk,Pkk,xk_1k,Pk_1k,Ks] = cckf(xkk,Pkk,y,Q,R,phi);

    %%%%�˲��洢
    xkkA=[xkkA xkk];
    PkkA=[PkkA Pkk];
    xk_1kA=[xk_1kA xk_1k];
    Pk_1kA=[Pk_1kA Pk_1k];
    KsA=[KsA Ks];

end

%%%%ƽ����ֵ
xkN=xkk;
PkN=Pkk;
    
%%%%ƽ���洢
xkNA=xkN;
PkNA=PkN;

for t=(ts-1):-1:0
        
    %%%%%%��ȡ�˲�����
    xkk=xkkA(:,t+2);
    Pkk=PkkA(:,(t+1)*nx+1:(t+2)*nx);
    xkk1=xk_1kA(:,t+1);
    Pkk1=Pk_1kA(:,t*nx+1:(t+1)*nx);
    Ak=KsA(:,t*nx+1:(t+1)*nx);

    %%%%%%����ƽ������
    [xkN,PkN]=ccks(xkN,PkN,xkk,Pkk,xkk1,Pkk1,Ak);

    %%%%ƽ���洢
    xkNA=[xkN xkNA];
    PkNA=[PkN PkNA];

end
