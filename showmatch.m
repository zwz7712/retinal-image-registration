function showmatch(I1_p,I2_p,loc1,loc2,s,imageNum,r,top_folder,rigFlag,visible)
% r 非对称高斯参数

I1 = I1_p(s+1:end-s,s+1:end-s);
I2 = I2_p(s+1:end-s,s+1:end-s);
loc1 = loc1-s;
loc2 = loc2-s;

im3 = rr_appendimages(I1,I2);

h =  figure('visible','on');
imshow(im3,[])
title(['matched points (' num2str(size(loc1,1)) ')']);
hold on
cols = size(I1,2);

for i=1:size(loc1,1)
    line([loc1(i,1) loc2(i,1)+cols],[loc1(i,2) loc2(i,2)], 'Color', 'y');
    plot(loc1(i,1),loc1(i,2),'g.')
    plot(loc1(i,1),loc1(i,2),'go')
    plot(loc2(i,1)+cols,loc2(i,2),'g.')
    plot(loc2(i,1)+cols,loc2(i,2),'go')
end
hold off

    saveas(h,['E:\学习\ur-sift实验\ur-sift\paper\fig6 组图\' num2str((imageNum*2-1)) '-' num2str((imageNum*2)) '.bmp']);
end