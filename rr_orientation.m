% Auther: Jian Chen
% April 2008
% Department of Biomedical imaging, Columbia University, New York, USA
% Institute of Automation, Chinese Academy of Sciences, Beijing, China
% email: jc3129@columbia.edu,  jian.chen@ia.ac.cn
% All rights reserved


function Theta = orientation(I,tc)

[Gx,Gy] = gradient(I);

h=ones(tc,tc)/tc/tc;
Gxx = conv2(Gx.*Gx, h, 'same');
Gyy = conv2(Gy.*Gy, h, 'same');
Gxy = conv2(Gx.*Gy, h, 'same');

Phi = 0.5*mytan(Gxx-Gyy,2*Gxy);  %梯度方向
Theta = (Phi+0.5*pi).*(Phi<=0) + (Phi-0.5*pi).*(Phi>0);  %方向场
Theta = Theta + (Theta<0)*pi; %从[-0.5pi, 0.5pi] ===> [0, pi]
Theta = Theta*180/pi;         %由弧度变为角度表示
Theta = 180-Theta;



function r = mytan(x,y)
r1 = (x>=0).*atan(y./(x+(x==0)*eps));
r2 = ((x<0) & (y>=0)) .* (atan(y./(x+(x==0)*eps)) + pi);
r3 = ((x<0) & (y<0)) .* (atan(y./(x+(x==0)*eps)) - pi);
r = r1+r2+r3;