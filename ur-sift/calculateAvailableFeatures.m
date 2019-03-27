function [ cellNum, cellNums, availableFeatureNum, probality ] = calculateAvailableFeatures(matrix, gridSize)
%   function:
%               Input:
%                      matrix 待统计的参数矩阵
%                      gridSize 网格个数
%               Output:
%                      cellNums 参数值
%                      availableFeatureNum 对应参数在矩阵中出现的次数
%                      probality 对应参数在矩阵出现的频率
    highNum = gridSize(1);
    widthNum = gridSize(2);
    widthSize = size(matrix,2)/widthNum;
    highSize = size(matrix,1)/highNum;
    [x,y] = find(matrix);
    % 将有数据的点值换成对应cell的索引下标值
    xCell = ceil(x./highSize);
    yCell = ceil(y./widthSize);
    cellNum = xCell+(yCell-1)*highNum;
    % 在整个矩阵统计每个cell索引值的出现个数、频率
    [cellNums, availableFeatureNum, probality] = histRate(cellNum);
end

