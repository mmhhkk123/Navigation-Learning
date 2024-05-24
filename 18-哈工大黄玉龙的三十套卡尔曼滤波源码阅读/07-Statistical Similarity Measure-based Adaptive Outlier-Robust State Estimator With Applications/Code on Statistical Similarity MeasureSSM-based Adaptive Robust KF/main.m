%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Matlab demo code for the paper
% M. Bai, Y. Huang, Y. Zhang and J. Chambers, "Statistical Similarity Measure-based
% Adaptive Outlier-Robust State Estimator With Applications"  
% IIEEE Transactions on Automatic Control.
% URL: https://ieeexplore.ieee.org/document/9779987

% If you use our code in your publication, please cite the above paper.
% Demo code written by Mingming Bai.
% Email: mingming.bai@hrbeu.edu.cn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%׼������%%%%%%%%%%%%%%%%
clear all;
close all;
clc;
randn('state',sum(100*clock));     
format long;

%%%%%ģ�Ͳ���%%%%%%%%%%%%%%%%
nxp=1000;
nx=4;
nz=2;
T=1;        
q=0.5; 
r=100;
F=[eye(2) T*eye(2);zeros(2) eye(2)];
H=[eye(2) zeros(2)];
Q0=[T^3/3*eye(2) T^2/2*eye(2);T^2/2*eye(2) T*eye(2)]*q;
R0=r*eye(2);
ts=200;

%%%%��Ҫ����ѡ��
N=50;              %%%%%%����ֵ�������
gama=1.345;        %%%%%%���ڲ���
sigma=5;           %%%%%%��˹�˴���
v_sq=5;            %%%%%%���ɶȲ���
tao_P=2;
tao_R=2;
epsilon=1e-8;

for expt = 1:nxp
    
    fprintf('MC Run in Process = %d\n',expt); 
    
    %%%%%ϵͳ��ֵ����%%%%%%%%%%%
    x=[0;0;10;10];                        %%%��ʵ״̬��ֵ
    P=diag([10000 10000 100 100]);        %%%��ʼ�����������
    Skk=utchol(P);                        %%%��ʼ�������Э�������ķ���

    %%%%��׼KF��ֵ      (Kalman filter)
    xf=x+Skk*randn(nx,1);                 %%%״̬���Ƴ�ֵ
    Pf=P;

    %%%%SSMKF_1��ֵ     flag=3  IEEE TAC Huang
    xssm_13=xf;
    Pssm_13=Pf;
    
    %%%%SSMKF_2��ֵ     flag=3  ������� AORKF
    xssm_23=xf;
    Pssm_23=Pf;

    %%%%���ݴ洢
    xA=x;
    xfA=xf;
    xssm_13A=xssm_13;
    xssm_23A=xssm_23;
    
    for t=1:ts
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%Ұֵ���Ʋ���
        U1=1000;        %%%%%%ϵͳҰֵ�Ŵ��� 
        U2=1000;        %%%%%%����Ұֵ�Ŵ��� 
        p1=0.95;        %%%%%%ϵͳ����ֵ����    
        p2=0.90;        %%%%%%��������ֵ����   
        
        %%%%��Ч��ϵͳ������������������
        D_Q=p1*Q0+(1-p1)*U1*Q0;
        D_R=p2*R0+(1-p2)*U2*R0;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%%�����β״̬����   ��˹���
        test1=rand;
        if test1<=p1
            Q=Q0;
        else
            Q=U1*Q0;
        end
        SQ=utchol(Q);  
        vx=SQ*randn(nx,1);
        
        %%%%�����β��������   ��˹���  ��ͬҰֵ����
        test2=rand;
        if test2<=p2
            R=R0;
        else
            R=U2*R0;
        end
        %%%%
        SR=utchol(R);
        vz=SR*randn(nz,1);

        %%%%������ʵ��״̬������
        x=F*x+vx;
        z=H*x+vz;
        
        %%%%�����˲�����
        %%%%�����˲�����
        [xf,Pf]=kf(xf,Pf,F,H,z,D_Q,D_R);
        
        [xssm_13,Pssm_13]=ssmkf(xssm_13,Pssm_13,F,H,z,Q0,R0,sigma,v_sq,N,epsilon,3);

        %%%%����˲����� AORKF
        [xssm_23,Pssm_23]=aorkf(xssm_23,Pssm_23,F,H,z,Q0,R0,sigma,v_sq,tao_P,tao_R,N,epsilon,3);
        
        %%%%���ݴ洢
        xA=[xA x];
        xfA=[xfA xf];
        xssm_13A=[xssm_13A xssm_13];
        xssm_23A=[xssm_23A xssm_23];

        %%%%MSE����  ���з���
        mse_kf_1(1,t,expt)=(xA(1,t+1)-xfA(1,t+1))^2+(xA(2,t+1)-xfA(2,t+1))^2;
        mse_kf_2(1,t,expt)=(xA(3,t+1)-xfA(3,t+1))^2+(xA(4,t+1)-xfA(4,t+1))^2;
        
        mse_ssmkf_13_1(1,t,expt)=(xA(1,t+1)-xssm_13A(1,t+1))^2+(xA(2,t+1)-xssm_13A(2,t+1))^2;
        mse_ssmkf_13_2(1,t,expt)=(xA(3,t+1)-xssm_13A(3,t+1))^2+(xA(4,t+1)-xssm_13A(4,t+1))^2;

        %%%%MSE����  ������� AORKF
        mse_ssmkf_23_1(1,t,expt)=(xA(1,t+1)-xssm_23A(1,t+1))^2+(xA(2,t+1)-xssm_23A(2,t+1))^2;
        mse_ssmkf_23_2(1,t,expt)=(xA(3,t+1)-xssm_23A(3,t+1))^2+(xA(4,t+1)-xssm_23A(4,t+1))^2;

    end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
%%%%%%%%%RMSE����  ���з���
rmse_kf_1=sqrt(mean(mse_kf_1,3));
rmse_kf_2=sqrt(mean(mse_kf_2,3));

rmse_ssmkf_13_1=sqrt(mean(mse_ssmkf_13_1,3));
rmse_ssmkf_13_2=sqrt(mean(mse_ssmkf_13_2,3));

%%%%%%%%%RMSE����  ������� AORKF
rmse_ssmkf_23_1=sqrt(mean(mse_ssmkf_23_1,3));
rmse_ssmkf_23_2=sqrt(mean(mse_ssmkf_23_2,3));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ƽ������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ƽ������
%%%%%%%%%SRMSE����  ���з���
srmse_kf_1=smooth(rmse_kf_1,10);
srmse_kf_2=smooth(rmse_kf_2,10);

srmse_ssmkf_13_1=smooth(rmse_ssmkf_13_1,10);
srmse_ssmkf_13_2=smooth(rmse_ssmkf_13_2,10);

%%%%%%%%%SRMSE����  ������� AORKF
srmse_ssmkf_23_1=smooth(rmse_ssmkf_23_1,10);
srmse_ssmkf_23_2=smooth(rmse_ssmkf_23_2,10);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%SRMSE����  ���з�������������Ա�
figure;
subplot(211);
j=1:ts;
plot(j*T,srmse_kf_1,'-k','linewidth',2.5);
hold on;
plot(j*T,srmse_ssmkf_13_1,'-c',j*T,srmse_ssmkf_23_1,'-r','linewidth',2.5)
xlabel('Time (s)');
ylabel('SRMSE_{pos} (m)');
axis tight;

subplot(212);
j=1:ts;
plot(j*T,srmse_kf_2,'-k','linewidth',2.5);
hold on;
plot(j*T,srmse_ssmkf_13_2,'-c',j*T,srmse_ssmkf_23_2,'-r','linewidth',2.5)
xlabel('Time (s)');
ylabel('SRMSE_{vel} (m/s)');
legend('KFTNCM','SSMKF-sqrt','Proposed AORSE-sqrt');
axis tight;


