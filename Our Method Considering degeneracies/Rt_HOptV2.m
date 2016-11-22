function [ Rt,isPureRotation ] = Rt_HOptV2( H,K1,K2,matches )
% Pose estiamting considering planar strucutre
% imsize [w,h]
% Reference: Faugeras 1988
% ����� 2016
% 2016��7��31��20:51:21
% DiagEq=0.001;
% MVG P
A=K2\H*K1;
%A=H;
[~,w,~]=svd(A);
d2=w(2,2);
A=A/d2;
[U,w,Vt]=svd(A);
% 2016��10��9��16:12:30
%U=det(U)*U;
%Vt=det(Vt)*Vt;
s=det(U)*det(Vt');
d1=w(1,1);
d2=w(2,2);
d3=w(3,3);
%fprintf('Diag Matrix in SVD of A��%.5f %.5f %.5f\n',d1,d2,d3);
%if abs(d1-d2)<=DiagEq&&abs(d2-d3)<=DiagEq%e-3
if abs(d1/d3)<=1.07
    fprintf('Pure Rotation is found!\n');
    %fprintf('�����㷨Q���:%.4f\n',QError(frame));
    isPureRotation=true;
    Rt=[A,zeros(3,1)];
    return;
else
    isPureRotation=false;
end

aux1=sqrt((d1^2-d2^2)/(d1^2-d3^2));
aux3=sqrt((d2^2-d3^2)/(d1^2-d3^2));
x1=[aux1;aux1;-aux1;-aux1];
x3=[aux3;-aux3;aux3;-aux3];
aux_sin_Theta=sqrt((d1^2-d2^2)*(d2^2-d3^2))/((d1+d3)*d2);
cos_Theta=(d2^2+d1*d3)/((d1+d3)*d2);
sin_Theta=[aux_sin_Theta;-aux_sin_Theta;-aux_sin_Theta;aux_sin_Theta];
for i=1:4
    %(13)
    Rp(:,:,i)=[cos_Theta,0,-sin_Theta(i);
        0,        1,         0;
        sin_Theta(i),0,cos_Theta];
    % Faugeras (8)
    R(:,:,i)=s*U*Rp(:,:,i)*Vt;
    Eula(i,:)=dcm2eul(R(:,:,i))*180/pi;
    %(14)
    tp(:,i)=(d1-d3)*[x1(i);0;-x3(i)];
    t(:,i)=U*tp(:,i);
end
aux_sin_Phi=sqrt((d1^2-d2^2)*(d2^2-d3^2))/((d1-d3)*d2);
cos_Phi=(d1*d3-d2^2)/((d1-d3)*d2);
sin_Phi=[aux_sin_Phi;-aux_sin_Phi;-aux_sin_Phi;aux_sin_Phi];
for i=5:8
    Rp(:,:,i)=[cos_Phi,   0,sin_Phi(i-4);
                0,       -1,         0;
                sin_Phi(i-4),0,-cos_Phi];
    R(:,:,i)=s*U*Rp(:,:,i)*Vt;
    Eula(i,:)=dcm2eul(R(:,:,i))*180/pi;
    tp(:,i)=(d1+d3)*[x1(i-4);0;x3(i-4)];
    t(:,i)=U*tp(:,i);
end
%{
P1=K1*[1 0 0 0;...
 0 1 0 0;...
 0 0 1 0];
%}
for i=1:8
    %P2=K2*[R(:,:,i),t(:,i)];
    Vote(i)=0;
    %ע�⺯�������룬��ά������    
    X=TriangulationOptV2( K1,K2,eye(3),R(:,:,i),zeros(3,1),t(:,i),matches);
    %��Ϊ�����
    X = X(1:3,:) ./ X([4 4 4],:);
    for m=1:size(X,2)
        %�������ת��Ϊ�����
        %X(:,m)=X(1:3,m)./X([4 4 4],m);
        %�жϴӵڶ���������㵽X���ʸ��(X(:,m)-Rt(:,4,i))��ڶ�������Ĺ���ĵ��
        %R����ĵ�����Rt(3,1:3,i)��Z�᷽��ĵ�λʸ������������ϵ������
        %�ĸ�����жϷ�����SFMedu�ıȽ����
        %2016��5��25��17:00:04���������ڶ�������Ľǵ�����C=-R'*t
        %������ �ع�������������ļн�
        mmcos(m)=R(3,:,i)*(X(:,m)+R(:,:,i)'*t(:,i));        
        Vote(i)=(X(3,m)>0&mmcos(m)>0)+Vote(i);
    end    
end
%{
disp('��ѡ��');
disp(Vote);
%}
%disp(dcm2eul(R{1})*180/pi);
%disp(dcm2eul(R{2})*180/pi);
[~,index]=max(Vote);
R=R(:,:,index);
t=t(:,index);
Rt=[R t];
%{
fprintf('the real 1 of 8 solutions:%.4f %.4f %.4f\n',dcm2eul(R)*180/pi);
fprintf('the real 1 of 8 solutions:%.4f %.4f %.4f\n',t);
%}
end
