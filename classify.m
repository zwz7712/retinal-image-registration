function mask = classify(img,lab,BlockIndexNum,Ck,imageNum)
[imSize(1),imSize(2),dim] = size(img);
if dim>1
    im = rgb2gray(img);
else 
    im = img;
end
num = 1;
% im = im2double(img);
for in=1:BlockIndexNum
    %
    i=in-1;
    ind = find(lab==i);
    % 一个点的区域不考虑
    if length(ind)>1
        % entro值过小，需要和距离在同一量级上
        entro(num) = entropy(uint8(im(ind)))^2;                      % 该超像素熵值
        blackWeight(num) = length(find(im(ind)<20))/length(ind);        % 该超像素灰度较小点个数
        distan(num) = (Ck(in,2)-imSize(1)/2)^2+(Ck(in,1)-imSize(2)/2)^2;  % 该超像素距离中心距离
        
        saliency(num) = sqrt(entro(num)+blackWeight(num)+distan(num)/10);
        num = num+1;
    end
end
entro = (entro-min(entro))/(max(entro)-min(entro))*255;
blackWeight = (1-(blackWeight-min(blackWeight))/(max(blackWeight)-min(blackWeight)))*255;
distan = (1-(distan-min(distan))/(max(distan)-min(distan)))*255;
saliency  = mod(0.15*entro + 0.05*blackWeight + 0.8*distan,256);
mask = zeros(imSize);
mask1 = zeros(imSize);
mask2 = zeros(imSize);
mask3 = zeros(imSize);
num=0;
for in=1:BlockIndexNum
    i=in-1;
    ind = find(lab==i);
    if length(ind)>1
        num = num+1;
        mask(ind) = saliency(num);
        mask1(ind) = entro(num);
        mask2(ind) = blackWeight(num);
        mask3(ind) = distan(num);
    end
end
figure;
imshow(uint8(mask1));
title('entropy image');
figure;
imshow(uint8(mask2));
title('blackWeight image');
figure;
imshow(uint8(mask3));
title('distance image');
% h = figure('visible','off');
h = figure();
imshow(uint8(mask));

weight = length(find(blackWeight<100))/BlockIndexNum;
b = sort(reshape(mask,imSize(1)*imSize(2),1),'ascend');
b(ceil(length(b)*weight))
ind = find(mask>b(ceil(length(b)*weight)));
finMsk = zeros(imSize);
finMsk(ind) = 255;
h = figure();
imshow(uint8(finMsk));
% saveas(h,['E:\学习\ur-sift(1)\ur-sift\SlicMask2\' num2str(imageNum) '.bmp']);
% %  close(h)
end