function RightRt = EtoRtV3(E,K1,K2,matches)
%Recover the relative pose from the essential matrix
%Input��E��essential matrix,3*3 
%K1��camera 1 internal parameter matrix
%K2��camera 2 internal parameter matrix
%matches��4*n for n point correspondence
%Output: the relative pose [R t]
%Reference Multiple View Geometry in Computer Vision, 2nd edition,P257
%Author: Peike Zhang, Yuanxin Wu, Qi Cai and Danping Zou
%2016
%Version 2
%Version��3
W=[0,-1,0;
    1,0,0;
    0,0,1];
Z=[0,1,0;
  -1,0,0;
   0,0,0];
[U,w,V]=svd(E);
w_diag=(w(1,1)+w(2,2))/2;
%2016-08-12 11:03:48
w(1,1)=w_diag;
w(2,2)=w_diag;
w(3,3)=0;
U=det(U)*U;
V=det(V)*V;
E=U*w*V';
[U,~,V]=svd(E);
%MVG P258 Equation9.14
S=U*Z*U';
%U=det(U)*U;
%V=det(V)*V;
R{1}=U*W*V';
R{2}=U*W'*V';
%Nister 5points algo Theorem 2
%{
disp('E2Rt Theorem2 by Nister');
fprintf('det(U)%.3f\n',det(U));
fprintf('det(V)%.3f\n',det(V));
fprintf('det(R1)%.3f\n',det(R{1}));
fprintf('det(R2)%.3f\n',det(R{2}));
%}
%���ӵ�����ʽ�жϣ����Ӻ�����ȷ
if det(R{1})<0
    R{1}=-R{1};
end
if det(R{2})<0
    R{2}=-R{2};
end
t{1}=U(:,3);
t{2}=-t{1};
%Find out the right pose by the positive depth constraint.
l=1;
for j=1:2
    for k=1:2
        Rt(:,:,l)=[R{j} t{k}];
        l=l+1;
    end
end
%׼������
P1=K1*[1 0 0 0;...
     0 1 0 0;...
     0 0 1 0];
for i=1:4
    P2=K2*Rt(:,:,i);
    Vote(i)=0;
    %ע�⺯�������룬��ά������    
    X=Triangulation(P1,P2,matches);
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
        mmcos(m)=Rt(3,1:3,i)*(X(:,m)+Rt(:,1:3,i)'*Rt(:,4,i));        
        Vote(i)=(X(3,m)>0&mmcos(m)>0)+Vote(i);
    end    
end
%disp('��ѡ��');
%disp(Vote);
%disp(dcm2eul(R{1})*180/pi);
%disp(dcm2eul(R{2})*180/pi);
[~,index]=max(Vote);
RightRt=Rt(:,:,index);
end