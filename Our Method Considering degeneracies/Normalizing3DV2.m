function [ T,Tpoint ] = Normalizing3DV2( point )
%��3D���ƵĹ�һ������
%Normalization
%point�Ƿ��������
%���̣�����ʹͼ��������ƽ�Ƶ�����ԭ�㣬
%ƽ�ƺ�������3*3�����ʾ
%�ο�MVG P109
%�������ģ�����ƽ������
%T=[*,*,*;*,*,*;0,0,1]
%���ߣ������
%2016�� 2��6��10:32:25 
%2016��10��4��10:59:44
%Version 3
%Inhomogeneous points
%V2 2017-04-06 15:50
%%
%��㼯����������
centroid=mean(point);
newpoint(1,:)=point(1,:)-centroid(1);
newpoint(2,:)=point(2,:)-centroid(2);
newpoint(3,:)=point(3,:)-centroid(3);
dist=sqrt(newpoint(1,:).^2+newpoint(2,:).^2+newpoint(3,:).^2);
meandist=mean(dist(:));
%���ŵ㼯���꣬��ʹƽ������Ϊ����3         
scale=sqrt(3)/meandist;
T=[scale,0,0,-scale*centroid(1);
   0,scale,0,-scale*centroid(2);
   0,0,scale,-scale*centroid(3);
   0,0,0,1];
%%
Newpoint=T*[point;ones(1,size(point,2))];
%��һ����ĵ�ķ��������
Tpoint=Newpoint(1:3,:);
end 