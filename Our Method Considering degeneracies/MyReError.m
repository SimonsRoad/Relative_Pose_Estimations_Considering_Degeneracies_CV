function [ ErrorSum ] = MyReError( matches,reprojection )
%Input ���룺matches��ԭͼ����ȡ������������꣬n�Ե㣬����4*n��reprojectionΪ��ͶӰ���ɵĵ�����꣬��ʽͬmatches
%Output�����ԭʼ�����Ӧ��ͶӰ���ŷ�Ͼ����ƽ����
%������Ϊ�Ż�ָ��
ErrorSum=(matches(1,1)-reprojection(1,1))^2+(matches(2,1)-reprojection(2,1))^2+(matches(3,1)-reprojection(3,1))^2+(matches(4,1)-reprojection(4,1))^2;
    for i=2:size(matches,2)
        ErrorSum=ErrorSum+(matches(1,i)-reprojection(1,i))^2+(matches(2,i)-reprojection(2,i))^2+(matches(3,i)-reprojection(3,i))^2+(matches(4,i)-reprojection(4,i))^2;
    end
end

