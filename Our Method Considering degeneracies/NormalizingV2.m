function [ T,Tpoint ] = NormalizingV2( point )
%��ͼ���Ĺ�һ������
%Normalization
%point�Ƿ�������꣬Newpoint��ʱ��������꣬��תΪ�����
%���̣�����ʹͼ��������ƽ�Ƶ�����ԭ�㣬
%ƽ�ƺ�������3*3�����ʾ
%�ο�MVG P109
%�������ģ�����ƽ������
%T=[*,*,*;*,*,*;0,0,1]
%���ߣ������
%2016��2��6��10:32:25 
%Version 2
%Newpoint����������꣨*��*��1������ȡ�������ʽ
%����������Ƿ��������
%%
%��������
centroid=mean(point);
%%
%�����������ƶ���Զ��
newpoint(1,:)=point(1,:)-centroid(1);
newpoint(2,:)=point(2,:)-centroid(2);
dist=sqrt(newpoint(1,:).^2+newpoint(2,:).^2);
meandist = mean(dist(:));  % Ensure dist is a column vector for Octave 3.0.1
scale = sqrt(2)/meandist;
T = [scale   0   -scale*centroid(1)
     0     scale -scale*centroid(2)
     0       0      1      ];
Newpoint=T*[point;ones(1,size(point,2))];
%��һ����ĵ�ķ��������
Tpoint=Newpoint(1:2,:);
end 