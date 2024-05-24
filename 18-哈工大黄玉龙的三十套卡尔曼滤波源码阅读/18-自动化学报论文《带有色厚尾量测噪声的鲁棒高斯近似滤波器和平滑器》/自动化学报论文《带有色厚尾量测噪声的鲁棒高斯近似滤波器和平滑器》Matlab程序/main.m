%%%%%׼������%%%%%%%%%%%%%%%%
clear all;
close all;
clc;
randn('state',sum(100*clock));     %%%���÷�������ÿ�ε�״̬����ͬ
format long;

%%%%%ģ�Ͳ���%%%%%%%%%%%%%%%%
raddeg=pi/180;                     %%%�ȱ仡��
nx=5;                              %%%״̬ά��
nz=2;                              %%%�۲�ά��
nxp=200;                           %%%Monte Carlo simulation ����
ts=100;                            
T=1;
M=[T^3/3 T^2/2;T^2/2 T];
%%%%������������%%%%%%%%%%%%%%
q1=0.1;
q2=1.75e-4;
Cr=10;
Co=sqrt(10)*1e-3;
Q=[q1*M zeros(2,2) zeros(2,1);zeros(2,2) q1*M zeros(2,1);zeros(1,2) zeros(1,2) q2*T]; 
R0=diag([Cr^2 Co^2]);

%%%%��ز���
phi=[0.5 0;0 0.5];

%%%%����ֵ����
p=0.95;

%%%%��ֵ�������
N=5;

for expt = 1:nxp
    
    fprintf('MC Run in Process = %d\n',expt); 
    
    %%%%%ϵͳ��ֵ����%%%%%%%%%%%
    x=[1000;300;1000;0;-3*raddeg];        %%%��ʵ״̬��ֵ
    P=diag([100 10 100 10 1e-4]);         %%%��ʼ����������� 
    Skk=utchol(P);                        %%%��ʼ�������Э�������ķ���
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%������ʼ����
    test=rand;
    if test<=p
        R=R0;
    else
        R=100*R0;
    end
    %%%%���㷽������
    SR=utchol(R);
    v=SR*randn(nz,1);
    z=MstEq(x)+v;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%�Ľ�CKS��ֵ
    xi=x+Skk*randn(nx,1);                 %%%״̬���Ƴ�ֵ
    Pi=P;
    
    %%%%����MCKS��ֵ 
    xm=xi;
    Pm=Pi;
    
    %%%%���б�׼��ɫCKS��ֵ 
    xs=xi;
    Ps=Pi;
    
    %%%%�Ľ�CKF��ֵ
    xif=xi;
    Pif=Pi;
    aif=5;
    bif=1;
    uif=nz+2;
    Uif=R0;
    
    %%%%����MCKF��ֵ
    xmf=xi;
    Pmf=Pi;
    
    %%%%���б�׼��ɫCKF��ֵ 
    xsf=xi;
    Psf=Pi;

    %%%%���ݴ洢
    xA=x;
    zA=z;
    yA=[];
    xifA=xif;
    xmfA=xmf;
    xsfA=xsf;

    %%%%������ʵ��״̬������
    for t=1:ts
        
        test=rand;

        if test<=p
            R=R0;
        else
            R=100*R0;
        end

        %%%%���㷽������
        SQ=utchol(Q);    
        SR=utchol(R);
        
        %%%%������ʵ��״̬������
        x=ProssEq(x)+SQ*randn(nx,1);
        %%%%������ɫ��β��������
        v=phi*v+SR*randn(nz,1);
        %%%%��������
        z=MstEq(x)+v;
        
        %%%%������ɫ����
        y=z-phi*zA(:,t);
        
        %%%%�����˲�����
        [xif,Pif,uif,Uif,aif,bif]=icckf(xif,Pif,y,Q,phi,uif,Uif,aif,bif,N);
        
        [xmf,Pmf]=orckf(xmf,Pmf,z,Q,R0,5,N); 
        
        [xsf,Psf,xsfkk1,Psfkk1,Ask]=cckf(xsf,Psf,y,Q,R0,phi);

        %%%%�洢״̬������
        xA=[xA x];  
        zA=[zA z];
        yA=[yA y];
        
        %%%%%�˲��洢
        xifA=[xifA xif];  
        xmfA=[xmfA xmf];  
        xsfA=[xsfA xsf];  
        
    end

    %%%%�Ľ�CKS�ĳ�ʼ����
    a0=5;
    b0=1;
    u0=nz+2;
    U0=R0;
    %%%%��ȡ����
    zA=zA(:,2:end);
    
    %%%%����ƽ������
    [ixsBA,iPsBA]=iccks(xi,Pi,yA,Q,phi,ts,a0,b0,u0,U0,N);
    
    [mxsBA,mPsBA]=mcks(xm,Pm,zA,ts,Q,R0,5,N);
    
    [sxsBA,sPsBA]=sccks(xs,Ps,yA,Q,phi,ts,R0);

    %%%%MSE����
    %%%%%%�˲�
    mse_ickf_1(expt,:)=(xA(1,:)-xifA(1,:)).^2+(xA(3,:)-xifA(3,:)).^2;
    mse_ickf_2(expt,:)=(xA(2,:)-xifA(2,:)).^2+(xA(4,:)-xifA(4,:)).^2;
    mse_ickf_3(expt,:)=(xA(5,:)-xifA(5,:)).^2;
    
    mse_mckf_1(expt,:)=(xA(1,:)-xmfA(1,:)).^2+(xA(3,:)-xmfA(3,:)).^2;
    mse_mckf_2(expt,:)=(xA(2,:)-xmfA(2,:)).^2+(xA(4,:)-xmfA(4,:)).^2;
    mse_mckf_3(expt,:)=(xA(5,:)-xmfA(5,:)).^2;
    
    mse_sckf_1(expt,:)=(xA(1,:)-xsfA(1,:)).^2+(xA(3,:)-xsfA(3,:)).^2;
    mse_sckf_2(expt,:)=(xA(2,:)-xsfA(2,:)).^2+(xA(4,:)-xsfA(4,:)).^2;
    mse_sckf_3(expt,:)=(xA(5,:)-xsfA(5,:)).^2;
    
    %%%%%ƽ��
    mse_icks_1(expt,:)=(xA(1,:)-ixsBA(1,:)).^2+(xA(3,:)-ixsBA(3,:)).^2;
    mse_icks_2(expt,:)=(xA(2,:)-ixsBA(2,:)).^2+(xA(4,:)-ixsBA(4,:)).^2;
    mse_icks_3(expt,:)=(xA(5,:)-ixsBA(5,:)).^2;
    
    mse_mcks_1(expt,:)=(xA(1,:)-mxsBA(1,:)).^2+(xA(3,:)-mxsBA(3,:)).^2;
    mse_mcks_2(expt,:)=(xA(2,:)-mxsBA(2,:)).^2+(xA(4,:)-mxsBA(4,:)).^2;
    mse_mcks_3(expt,:)=(xA(5,:)-mxsBA(5,:)).^2;
    
    mse_scks_1(expt,:)=(xA(1,:)-sxsBA(1,:)).^2+(xA(3,:)-sxsBA(3,:)).^2;
    mse_scks_2(expt,:)=(xA(2,:)-sxsBA(2,:)).^2+(xA(4,:)-sxsBA(4,:)).^2;
    mse_scks_3(expt,:)=(xA(5,:)-sxsBA(5,:)).^2;

end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%�˲�
rmse_ickf_1=sqrt(mean(mse_ickf_1,1));
rmse_ickf_2=sqrt(mean(mse_ickf_2,1));
rmse_ickf_3=sqrt(mean(mse_ickf_3,1));

rmse_mckf_1=sqrt(mean(mse_mckf_1,1));
rmse_mckf_2=sqrt(mean(mse_mckf_2,1));
rmse_mckf_3=sqrt(mean(mse_mckf_3,1));

rmse_sckf_1=sqrt(mean(mse_sckf_1,1));
rmse_sckf_2=sqrt(mean(mse_sckf_2,1));
rmse_sckf_3=sqrt(mean(mse_sckf_3,1));

%%%%%%%ƽ��
rmse_icks_1=sqrt(mean(mse_icks_1,1));
rmse_icks_2=sqrt(mean(mse_icks_2,1));
rmse_icks_3=sqrt(mean(mse_icks_3,1));

rmse_mcks_1=sqrt(mean(mse_mcks_1,1));
rmse_mcks_2=sqrt(mean(mse_mcks_2,1));
rmse_mcks_3=sqrt(mean(mse_mcks_3,1));

rmse_scks_1=sqrt(mean(mse_scks_1,1));
rmse_scks_2=sqrt(mean(mse_scks_2,1));
rmse_scks_3=sqrt(mean(mse_scks_3,1));

%%%%%%%%%%%��ͼ
figure;
j = 0:ts;
plot(j,rmse_sckf_1(1,:),'--g',j,rmse_mckf_1(1,:),'--b',j,rmse_ickf_1(1,:),'--r',j,rmse_scks_1(1,:),'-g',j,rmse_mcks_1(1,:),'-b',j,rmse_icks_1(1,:),'-r','linewidth',2.5);
xlabel('ʱ�� (s)');
ylabel('λ�õ�RMSE (m)');
legend('���е���ɫCKF','���е�³��CKF','�����³��CKF','���е���ɫCKS','���е�³��CKS','�����³��CKS');

figure;
j = 0:ts;
plot(j,rmse_sckf_2(1,:),'--g',j,rmse_mckf_2(1,:),'--b',j,rmse_ickf_2(1,:),'--r',j,rmse_scks_2(1,:),'-g',j,rmse_mcks_2(1,:),'-b',j,rmse_icks_2(1,:),'-r','linewidth',2.5);
xlabel('ʱ�� (s)');
ylabel('�ٶȵ�RMSE (m/s)');
legend('���е���ɫCKF','���е�³��CKF','�����³��CKF','���е���ɫCKS','���е�³��CKS','�����³��CKS');

figure;
j = 0:ts;
plot(j,rmse_sckf_3(1,:)./raddeg,'--g',j,rmse_mckf_3(1,:)./raddeg,'--b',j,rmse_ickf_3(1,:)./raddeg,'--r',j,rmse_scks_3(1,:)./raddeg,'-g',j,rmse_mcks_3(1,:)./raddeg,'-b',j,rmse_icks_3(1,:)./raddeg,'-r','linewidth',2.5);
xlabel('ʱ�� (s)');
ylabel('ת�����ʵ�RMSE (Deg/s)');
legend('���е���ɫCKF','���е�³��CKF','�����³��CKF','���е���ɫCKS','���е�³��CKS','�����³��CKS');


%%%%%%%%%%%%%%%%%%
armse_ickf_1=sqrt(mean(mean(mse_ickf_1,1)))
armse_ickf_2=sqrt(mean(mean(mse_ickf_2,1)))
armse_ickf_3=sqrt(mean(mean(mse_ickf_3,1)))./raddeg

armse_icks_1=sqrt(mean(mean(mse_icks_1,1)))
armse_icks_2=sqrt(mean(mean(mse_icks_2,1)))
armse_icks_3=sqrt(mean(mean(mse_icks_3,1)))./raddeg

armse_mckf_1=sqrt(mean(mean(mse_mckf_1,1)))
armse_mckf_2=sqrt(mean(mean(mse_mckf_2,1)))
armse_mckf_3=sqrt(mean(mean(mse_mckf_3,1)))./raddeg
 
armse_mcks_1=sqrt(mean(mean(mse_mcks_1,1)))
armse_mcks_2=sqrt(mean(mean(mse_mcks_2,1)))
armse_mcks_3=sqrt(mean(mean(mse_mcks_3,1)))./raddeg

armse_sckf_1=sqrt(mean(mean(mse_sckf_1,1)))
armse_sckf_2=sqrt(mean(mean(mse_sckf_2,1)))
armse_sckf_3=sqrt(mean(mean(mse_sckf_3,1)))./raddeg
 
armse_scks_1=sqrt(mean(mean(mse_scks_1,1)))
armse_scks_2=sqrt(mean(mean(mse_scks_2,1)))
armse_scks_3=sqrt(mean(mean(mse_scks_3,1)))./raddeg

