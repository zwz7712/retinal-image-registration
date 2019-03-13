function [match,descri1,descri2] = rr_desmatch( I1, I2, cols1, cols2, rws1, rws2,cell1,cell2 )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Main orientation assignment
scale1 = 25; % 25
theta1 = rr_orientation(I1,15)/180*pi-pi;
theta2 = rr_orientation(I2,15)/180*pi-pi;
s1 = scale1 * ones(size(cols1));
s2 = scale1 * ones(size(cols2));
o11 = zeros(size(cols1));
o22 = zeros(size(cols2));
o1 = diag(theta1(rws1,cols1));
o2 = diag(theta2(rws2,cols2));
x = rws1; rws1=cols1;cols1=x;
x = rws2; rws2=cols2;cols2=x;


if exist('refine')==1
    key1 = [rws1';cols1';s1';o11';cell1];
    key2 = [rws2';cols2';s2';o22';cell2];
else
    key1 = [rws1';cols1';s1';o1';cell1];
    key2 = [rws2';cols2';s2';o2';cell2];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Local feature extraction
des1 = rr_descriptor(I1,key1);
des2 = rr_descriptor(I2,key2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Matchings the keys from two images
[match,descri1,descri2]=rr_match(des1', key1',des2', key2',0.96);

end

