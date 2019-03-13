function [ msk ] = get_msk( imageName, imageNum )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
image = imread(imageName);



if ndims(image)>2
    imageGreen = image(:,:,2);
    imageRed = image(:,:,1);
else
    imageGreen = image;
    imageRed = image;
end
%图像预处理
%         imageRed = double(imageRed);
        imagered = imageRed/max(imageRed(:))*255;
%         imEdge = edge(imagered,'Canny',0.03);
% %         figure;imshow(imEdge);
%         imEdge=double(imEdge);
%         imEdge(imEdge==1)=255;
            
            
%            [msk,~] = rr_msk(imagered,30);
%%
% if 1
%             h=figure;
%             imshow(msk);
%             title('mask');
%         end
%         keyIndex =1;
%         saveas(h,['E:\学习\ur-sift(1)\ur-sift\mskImage\' num2str(imageNum) '.bmp']);
end
% function roi = getROI(image,center)
% 
% end
