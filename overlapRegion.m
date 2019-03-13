function [ overlapProport ] = overlapRegion( addgen, imageNum, transParam)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
overlapProport = zeros(imageNum,1);
for i=1:imageNum
    close all;
        mask1 = imread([addgen 'mask\' num2str(2*i-1) '.bmp']);
        mask2 = imread([addgen 'mask\' num2str(2*i) '.bmp']);
%     mask1 = imread([addgen 'mask\' num2str(i) '_mask.bmp']);
%     mask2 = imread([addgen 'mask\' num2str(i) 's_mask.bmp']);
    mask1=double(mask1)*255;
    mask2=double(mask2)*255;
    [row1,column1] = size(mask1);
    [row2,column2] = size(mask2);
    if mask1(round(row1/2),round(column1/2)) == 0
        mask1 = inverseMsk(addgen,2*i-1,mask1);
    end
    if mask2(round(row2/2),round(column2/2)) == 0
        mask2 = inverseMsk(addgen,2*i,mask2);
    end
    transMask1 = imtransform(mask1,transParam{i},'XData',[1 size(mask1,2)], 'YData',[1 size(mask1,1)]);
    [I1_c,I2_c] = rr_imagesize(transMask1,mask2);
    imFusion = I1_c + I2_c;
    imFusion(find(imFusion))=255;
    po1=figure('visible','off');imshow(imFusion,[]);title(['fusion image (Polynomial)']);
    overlapProport(i) = (length(find(I1_c))-length(find(imFusion))+length(find(I2_c)))/length(find(I1_c));
end

end

function mask = inverseMsk(addgen, imageNum,msk)
msk(find(msk~=0)) = -1;
msk(find(msk==0)) = 255;
msk(find(msk==-1)) = 0;
mask = msk;
% imwrite(msk,[addgen 'mask\' num2str(imageNum) '.bmp']);
end
