function  XSet  = Triangulation(P1,P2,matches)
%����˼�룬�������X����ķ���
%���Ż�����
%ע�⣬��������matches��4*n��ǰ���ж�ӦP1�������ж�ӦP2��
%������������
%Author:Peike Zhang
%x���PX=0�����췽�̣�MVG P312
for i=size(matches,2):-1:1
A=[matches(1,i)*P1(3,:)-P1(1,:);
   matches(2,i)*P1(3,:)-P1(2,:);
   matches(1,i)*P1(2,:)-matches(2,i)*P1(1,:);
   matches(3,i)*P2(3,:)-P2(1,:);
   matches(4,i)*P2(3,:)-P2(2,:);
   matches(3,i)*P2(2,:)-matches(4,i)*P2(1,:)];
[~,~,V]=svd(A,0);
%V�����һ��Ϊ�⼯��ÿ4��Ϊ��ά����
XSet(:,i)=V(:,end);
end
end

