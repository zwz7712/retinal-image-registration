function [output_args] = constrGroundtruth(input_args)

addpath(genpath(pwd));
global addgen
% addgen = './batchdata2/internet multi-model retinal dataset/';
addgen = '.\batchdata2\STARE_mono-model_retianl_dataset\';

for i=11
    
clc;
close all;

image1 = [addgen num2str(i) '.bmp'];
% image1 = [addgen num2str(i*2-1) '.jpg'];
image2 = [addgen num2str(i) 's.bmp'];
% image2 = [addgen num2str(i*2) '.jpg'];

imageNum = i;

ground_truth(image1,image2,imageNum,addgen);
end

end



function ground_truth(im1,im2,num,addgen)
im1 = imread(im1);
im2 = imread(im2);

contrPointNum = 6;


if ndims(im1)>2
    im1 = im1(:,:,2);
end
if ndims(im2)>2
    im2 = im2(:,:,2);
end
col = size(im1,2);
im3 = rr_appendimages(im1,im2);
figure();imshow(im3);


hold on
for i=1:contrPointNum
    [x1(i),y1(i)] = ginput(1);
    plot(x1,y1,'y+');
    [x2(i),y2(i)] = ginput(1);
    plot(x2,y2,'go');
end
hold off

point1 = [x1' y1'];
point2 = [(x2-col)' y2'];


t_fundus2 = cp2tform([x1' y1'],[(x2-col)' y2'],'polynomial',2);
I1_c = imtransform(im1,t_fundus2,'XData',[1 size(im2,2)], 'YData',[1 size(im2,1)]);
[I1_c,I2_c] = rr_imagesize(I1_c,im2);
figure('visible','on');imshow(I1_c+I2_c,[]);title(['fusion image (Polynomial)']);
% xlswrite([addgen 'groundTruthPoint.xls']...
%     ,point1,1,['A' num2str((num-1)*17+1) ':B' num2str((num-1)*17+contrPointNum)]);
% xlswrite([addgen 'groundTruthPoint.xls']...
%     ,point2,1,['C' num2str((num-1)*17+1) ':D' num2str((num-1)*17+contrPointNum)]);
% point1 = [x1' y1'];
% point2 = [x2' y2'];
% save correspond point1 point2
end

