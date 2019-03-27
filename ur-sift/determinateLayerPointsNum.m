function  [ pointNum, cellNum]  = determinateLayerPointsNum(totalKeyNum, scaleSpace, N, cell_size, imageName)
%   function:   计算每层的计划分配点数和cell的行、列索引矩阵
%   Input:
%               scaleSpace 尺度空间
%               N:  总的点数
%               cell_size 网格尺寸
%   Output:
%               pointNum 尺度空间中每层每个尺度上的点数
%               gridSize 每个尺度上的网格个数
%% 问题 ： 强行凑了个各比例和为1 不考虑每层实际能取多少特征点
%   解决猜想：    比例和尺度系数成负相关 可否使用一个函数使得尺度系数越小时，其变化速度越快
%% 问题 ： 对于视网膜图像 每个octave的每层实际抓取点数呈现低、高、中趋势 而非高、中、低趋势
%   解决猜想：改变系数函数与尺度系数accumSigma（oct,lay)的关系 octave呈现
%% 输入点数超出能检测到的极值点数时报错
if N>totalKeyNum
   error(['Error: You can not input the features number larger than the total number ' num2str(totalKeyNum)]) 
end
%% 
% fp = fopen([imageName '的尺度系数与keypoints数关系.txt'],'a');
% str=[char(13,10)' '用户输入的特征点数在每层的预设值' char(13,10)'];
% fprintf(fp,'%s',str);
%%
accumSigma = scaleSpace{2};

oct = size(accumSigma,1);
lay = size(accumSigma,2);
pointProportion  = zeros(oct,lay);
k = 2^(1/lay);
f0 = countf0(oct,lay,k);
for octave = 1:oct
    for layer = 1:lay
        pointProportion(octave,layer) = accumSigma(1,1)^2/accumSigma(octave,layer)^2*f0;
%         str =['Octave ' num2str(octave) ' Layer ' num2str(layer) ' Key point num ' num2str(pointProportion(octave,layer)*N),char(13,10)'];
%         fprintf(fp,'%s',str);
    end
end
% sum(sum(pointProportion))
pointNum = pointProportion*N;
% fclose(fp);
% %% 计算图像的每个像素对应的cell编号
highNum = floor(size(scaleSpace{3}{1},2)/cell_size(1));
cellNum{1} = zeros(1,size(scaleSpace{3}{1},2));
redu = mod(size(scaleSpace{3}{1},2),cell_size(1));
addToNum = floor(redu/highNum);
restPot = mod(redu,highNum)/2;
addRest = cell_size(1)+addToNum;
comIndexHead = floor(restPot)*(addRest+1);
comIndexRear = ceil(restPot)*(addRest+1);
cellNum{1}(1:comIndexHead) = ceil(scaleSpace{3}{1}(1:comIndexHead)/(addRest+1));
cellNum{1}(comIndexHead+1:end-comIndexRear) = ceil(scaleSpace{3}{1}(comIndexHead+1:end-comIndexRear)/(addRest));
cellNum{1}(end-comIndexRear+1:end) = ceil(scaleSpace{3}{1}(end-comIndexRear+1:end)/(addRest+1));


widthNum= floor(size(scaleSpace{4}{1},2)/cell_size(2));
cellNum{2} = zeros(1,size(scaleSpace{4}{1},2));
redu = mod(size(scaleSpace{4}{1},2),cell_size(2));
addToNum = floor(redu/widthNum);
restPot = mod(redu,widthNum)/2;
addRest = cell_size(2)+addToNum;
comIndexHead = floor(restPot)*(addRest+1);
comIndexRear = ceil(restPot)*(addRest+1);
cellNum{2}(1:comIndexHead) = ceil(scaleSpace{4}{1}(1:comIndexHead)/(addRest+1));
cellNum{2}(comIndexHead+1:end-comIndexRear) = ceil(scaleSpace{4}{1}(comIndexHead+1:end-comIndexRear)/(addRest));
cellNum{2}(end-comIndexRear+1:end) = ceil(scaleSpace{4}{1}(end-comIndexRear+1:end)/(addRest+1));
% widthNum = floor(size(scaleSpace{4}{1},2)/cell_size(2));
% cellNum{2} = zeros(1,size(scaleSpace{4}{1},2));
% redu = mod(size(scaleSpace{4}{1},2),cell_size(2))
% completeCell = widthNum-redu;
% comIndex = (completeCell)*cell_size(2);
% cellNum{2}(1:comIndex) = ceil(scaleSpace{4}{1}(1:comIndex)/cell_size(2));
% comIndex
% cellNum{2}(comIndex+1:end) = ceil(scaleSpace{4}{1}(comIndex+1:end)/(cell_size(2)+1));
end

