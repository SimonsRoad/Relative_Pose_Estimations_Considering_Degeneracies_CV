function [ ReprojectionPointHomo, ReprojectionPointInHomo ] = MyReprojection( P1,P2,X )
%���ؽ�����ά�ռ����ͶӰ����άƽ��
%���ߣ������
%Input:�������Camera Matrix 3*4��P1��P2���ؽ�����ά��������꣬n���㣬����4*n
%Output:��ά�����꣬������εĺͷ���εģ�x{1}��Σ�x{2}����Σ�x{1}����6*n��x{2}����4*n
%���ܴ��ڱ�����ԭʼ�Ķ�άͼ�������������Ϊ�߶ȣ���SFMedu��õ���ά�ؽ��������߶��Լ�δ֪
%2016��3��
ReprojectionPointHomo(1:3,:)=P1*X;
ReprojectionPointHomo(4:6,:)=P2*X;
ReprojectionPointInHomo(1:2,:)=ReprojectionPointHomo(1:2,:)./ReprojectionPointHomo([3 3],:);
ReprojectionPointInHomo(3:4,:)=ReprojectionPointHomo(4:5,:)./ReprojectionPointHomo([6 6],:);
end

