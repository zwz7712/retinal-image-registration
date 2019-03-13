function [ output_args ] = drawFeature( keypoints, scaleSpace, AfterMaskImage,visible)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
octave = size(keypoints{1},1);
layer = size(keypoints{1},2);
piexlHigh = scaleSpace{3};
piexlWidth = scaleSpace{4};
image = AfterMaskImage;
keyPointLocation = [];

for oct = 1:octave
    for lay = 1:layer
        [row,column] = find(keypoints{1}{oct,lay});
        realRow = piexlHigh{oct}(row);
        realColumn = piexlWidth{oct}(column);
        keyPointLocation = [keyPointLocation [realRow;realColumn]];
    end
end
size(keyPointLocation);
keyPointLocation = unique(keyPointLocation','rows')';
figure('visible',visible) ;
imshow(image);
hold on
plot(keyPointLocation(2,:),keyPointLocation(1,:),'r+');
hold off
end

