function [ pointIndex ] = adjacentPoint(pointSet, cell, index )
% 功能：在wholeMatch中寻找以该cell为中心的邻接cell内的点
% pointSet 1:2维是点二维坐标，3:4维是对应cell索引
pointIndex = [];
set = pointSet;
set(index,:) = [];
for i=-1:1
    for j=-1:1       
        indexS = set(:,3:4)==[cell(1)+i cell(2)+j];
        pointIndex = [pointIndex;set(indexS(:,2),1:2)];
    end
end

end

