function [ F ] = ComputeFmatrixNormalization(matches)
%Computing Fundamental Matrix
%Peike Zhang, Yuxin Wu
%步骤：1.采用SIFT进行特征提取和匹配
%2.匹配点对集构建方程Af=0
%3.对A进行奇异值分解，SVD，最小奇异值对应的奇异向量即f
%4.f转化为F，3*3矩阵
%Version:2
%步骤的修改：增加了归一化
%matches为匹配点对，4*n，n对点，一对为一列

[a,b]=size(matches);
%构造方程
%2016年1月26日11:06:37，把MyNormalizing加入
%%
x1=matches(1:2,:);
x2=matches(3:4,:);
%归一化，归一化函数有问题，函数结果无转换后的点
[T1,x1]=MyNormalizing(x1);
[T2,x2]=MyNormalizing(x2);
%%
%构造新的形式方程
%2016年2月7日11:49:31
%
%{
 A = [x2(1,:)'.*x1(1,:)'   x2(1,:)'.*x1(2,:)'  x2(1,:)' ...
         x2(2,:)'.*x1(1,:)'   x2(2,:)'.*x1(2,:)'  x2(2,:)' ...
         x1(1,:)'             x1(2,:)'            ones(npts,1) ];       

%}

A=[x2(1,1)*x1(1,1),x2(1,1)*x1(2,1),x2(1,1),x2(2,1)*x1(1,1),x2(2,1)*x1(2,1),x2(2,1),x1(1,1),x1(2,1),1];
for i=1:b-1
    A=[A;x2(1,1+i)*x1(1,1+i),x2(1,1+i)*x1(2,1+i),x2(1,1+i),x2(2,1+i)*x1(1,1+i),x2(2,1+i)*x1(2,1+i),x2(2,1+i),x1(1,1+i),x1(2,1+i),1];
end
%进行奇异值分解
[U,S,V]=svd(A);
%V的最后一列即f的顺序9个元素
%F = reshape(V(:,9),3,3)';
tempF=[V(1,9),V(2,9),V(3,9);
   V(4,9),V(5,9),V(6,9);
   V(7,9),V(8,9),V(9,9)];
%F的约束条件，rank(F)=2
[U1,S1,V1]=svd(tempF);
tempF=U1*diag([S1(1,1),S1(2,2),0])*V1';
F=T2'*tempF*T1;
