function  distan  = distance( I1,I2,match )
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
scale1 = 25; % 25
theta1 = rr_orientation(I1,15)/180*pi-pi;
theta2 = rr_orientation(I2,15)/180*pi-pi;

cols1 = round(match(:,1));
cols2 = round(match(:,3));
rws1 = round(match(:,2));
rws2 = round(match(:,4));

s1 = scale1 * ones(size(cols1));
s2 = scale1 * ones(size(cols2));
o11 = zeros(size(cols1));
o22 = zeros(size(cols2));
o1 = diag(theta1(rws1,cols1));
o2 = diag(theta2(rws2,cols2));
x = rws1; rws1=cols1;cols1=x;
x = rws2; rws2=cols2;cols2=x;


if exist('refine')==1
    key1 = [rws1';cols1';s1';o11'];
    key2 = [rws2';cols2';s2';o22'];
else
    key1 = [rws1';cols1';s1';o1'];
    key2 = [rws2';cols2';s2';o2'];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Local feature extraction
des1 = rr_descriptor(I1,key1);
des2 = rr_descriptor(I2,key2);

distan = sum(des1'.*des2',2);

end

