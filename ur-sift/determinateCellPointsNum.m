function [ lastIndex ] = determinateCellPointsNum( keypoints, scaleSpace, octaveDoGStack, weightE, weightN, pointNum, layPiexlCellInddex, mask,image )
%   function: 计算每层的网格中的点数
%   Input：
%           keypoints: 极值点信息
%           octavesStack: 尺度空间图像
%           octaveDoGStack: 差分高斯空间图像
%           weightE: E项权值
%           weightN: N项权值
%           pointNum: 每个octave每层上的点数
%           gridSize: 每个尺度上的网格个数
%
%   Output:
%           lastIndex: 选取的特征点的矩阵 6*N'   N'<=pointNum

widthNums = size(unique(layPiexlCellInddex{2}));
widthNum = max(widthNums(1,1),widthNums(1,2));
highNums = size(unique(layPiexlCellInddex{1}));
highNum = max(highNums(1,1),highNums(1,2));
clear widthNums
clear highNums
cellNum = keypoints{4}; % 每层的抓取到的极值点个数
octave = size(keypoints{1},1);
layer = size(keypoints{1},2);
avaliableFea = cell(octave,layer); 
m=0;
lastFeaMatrix = zeros(8,0);
% feaEntro = zeros(2,0);
sigma = scaleSpace{2};

%% 每层的分配的点数多于当前层抓取到的点数处理
extracredExtreme = zeros(octave,layer);
for i = 1:octave
    for j = 1:layer
        extracredExtreme(i,j) = cellNum{i}(j);
    end
end
% size(pointNum)
% size(extracredExtreme)
pointNum = inAdequacyAssign(pointNum,extracredExtreme);
%% 每层的每个cell中的点数初步判断
for oct = 1:octave
    
    for lay = 1:layer
        % 全为0 不予考虑
        if pointNum(oct,lay) ~= 0
            
            
            % 获取熵矩阵图 取局部熵的领域为半径为3σ的圆
            se = strel('disk',ceil(3*sigma(oct,lay)));
            Nhood = getnhood(se);
            entropyImage = entropyfilt(scaleSpace{1}{oct}(:,:,:,lay),Nhood);
            
            
            %此层图像的坐标点
            avaliableFea{oct,lay}.cellContrastSort = cell(highNum,widthNum);
            avaliableFea{oct,lay}.cellContrastSortInd = cell(highNum,widthNum);
            % 当前层的行索引及列索引
            row = scaleSpace{3}{oct};
            column = scaleSpace{4}{oct};
            for i = 1:highNum
                % 当前cell的行索引
                rows = find(layPiexlCellInddex{1}(row)==i);
                
                for j = 1:widthNum
                    %包含在此cell的像素坐标
                    % 当前cell的列索引
                    columns = find(layPiexlCellInddex{2}(column)==j);
                    %                 size(columns)
                    %%
                    %统计每层的每个cell的可能特征点数
                    temp = keypoints{1}{oct,lay}(rows,columns);
                    avaliableFea{oct,lay}.cellFeatureNum(i,j) = sum( temp(:) ~= 0);
                    
                    %若该cell不包含极值点，直接结束并使得该cell赋值为0
                    if avaliableFea{oct,lay}.cellFeatureNum(i,j) == 0
                        avaliableFea{oct,lay}.cellGrayEntropy(i,j)=0;
                        avaliableFea{oct,lay}.cellMeanContrast(i,j)=0;
                        continue;
                    end
                    
                    
                    %%
                    %统计每层的每个cell中的灰度熵
                    %灰度熵高的区域能否说明就是有用信息多的区域？？？？？？？？？？？？？
                    %能否通过此项造成一定程度的噪声鲁棒性？？？？？？？？？？？？？？
                    % 特征点熵的计算半径为3σ的圆形区域
                    % 熵为 1 该区域的特征点的熵的均值
                    %      2 该区域的图像熵
                    %% 2法
%                     [~,~,grayPro] = histRate(scaleSpace{1}{oct}(rows,columns,:,lay));
%                     avaliableFea{oct,lay}.cellGrayEntropy(i,j) = -sum(grayPro.*log2(grayPro));
                    %% 1法
                    [x,y] = find(temp);
                    
                    cellFeatureIndexInLay = rows(x)+(columns(y)-1)*size(row,2);
                    featureEntropy = entropyImage(cellFeatureIndexInLay);
                    avaliableFea{oct,lay}.cellGrayEntropy(i,j) = sum(featureEntropy(:))/avaliableFea{oct,lay}.cellFeatureNum(i,j);
                    
                    
                    %%
                    %统计每层每个cell的极值点的平均对比度
                    %对比度高的区域能否说明就是有用信息多的区域？？？？？？？？？？？？？
                    %能否通过此项造成一定程度的噪声鲁棒性？？？？？？？？？？？？？？
                    cellij = octaveDoGStack{oct}(rows,columns,:,lay);
                    cellFeatureIndexInCell = size(rows,2);
                    cellFeatureInd = x+(y-1)*cellFeatureIndexInCell;
                    cellij = cellij(cellFeatureInd);
                    avaliableFea{oct,lay}.cellMeanContrast(i,j) = sum(abs(cellij(:)))/numel(cellij);
                    %sum(abs(cellij(:)))/numel(cellij)
                    
                    % cellContrastSortInd 该cell中的特征点在当前的cell中的一维索引
                    avaliableFea{oct,lay}.cellFeatureInd{i,j} = cellFeatureInd;
                    clear grayPro
                end
                
            end
            % 每层的每个cell的取点个数
            % 为何可能造成分到的cell点数比该层可能的关键点数还多??????????????????????????????????????
            % 会造成分配值大于实际能抓取到的值
            avaliableFea{oct,lay}.cell = pointNum(oct,lay)*(weightE*avaliableFea{oct,lay}.cellGrayEntropy/sum(avaliableFea{oct,lay}.cellGrayEntropy(:))...
                + weightN*avaliableFea{oct,lay}.cellFeatureNum/(sum(avaliableFea{oct,lay}.cellFeatureNum(:)))...
                + (1-weightE-weightN)*avaliableFea{oct,lay}.cellMeanContrast/sum(avaliableFea{oct,lay}.cellMeanContrast(:)));
            
            %         avaliableFea{oct,lay}.cell
            
            %% 对于点数不够的cell在当前层进行处理
            cellExtracted = zeros(highNum,widthNum);
            for cellHighInade = 1:highNum
                rowInade = find(layPiexlCellInddex{1}(row) == cellHighInade);
                for cellWidthInade = 1:widthNum
                    columnInade = find(layPiexlCellInddex{2}(column) == cellWidthInade);
                    cellExtracted(cellHighInade,cellWidthInade) = sum(sum(keypoints{1}{oct,lay}(rowInade,columnInade) ~= 0));
                end
            end
            avaliableFea{oct,lay}.cell = inAdequacyAssign(avaliableFea{oct,lay}.cell, cellExtracted);
            %% 对于当前层的cell中选择对比度最大的3倍n_cell个数的点
            for cellit = 1:highNum
                % 当前cell的在该层的行索引
                rowsi = find(layPiexlCellInddex{1}(row)==cellit);
                cellRow = size(rowsi,2);
                for celljt = 1:widthNum
                    % 当前cell在该层的列索引
                    columnsi = find(layPiexlCellInddex{2}(column) == celljt);
                    % 当前cell点数=0
                    if(round(avaliableFea{oct,lay}.cell(cellit,celljt)) == 0)
                        continue;
                        % 当前cell特征点数>0 <=3*n_cell
                    elseif 0 < cellExtracted(cellit,celljt) &&...
                            avaliableFea{oct,lay}.cell(cellit,celljt)*3 >= cellExtracted(cellit,celljt)
                        allowIndNum = round(cellExtracted(cellit,celljt));
                        % 当前cell特征点数>3*n_cell
                    elseif avaliableFea{oct,lay}.cell(cellit,celljt)*3 < cellExtracted(cellit,celljt)
                        allowIndNum = round(avaliableFea{oct,lay}.cell(cellit,celljt)*3);
                    end
                    curCellFeaInd = avaliableFea{oct,lay}.cellFeatureInd{cellit,celljt};
                    dotRegion = octaveDoGStack{oct}(rowsi,columnsi,:,lay);
                    % 对比度最高的allowIndNum个点
                    [~,I1] = sort(dotRegion(curCellFeaInd));
                    curCellFeaInd = curCellFeaInd(I1);
                    curCellFeaInd = curCellFeaInd(1:allowIndNum);
                    
                    % 在该cell范围内的行列索引
                    y = ceil(curCellFeaInd/cellRow);
                    x = mod(curCellFeaInd,cellRow);
                    x(x==0)=cellRow;
                    
                    cellIndex = rowsi(x)+(columnsi(y)-1)*size(row,2);
                    featureEntropy = entropyImage(cellIndex);
                    [pointEntropy,I] = sort(featureEntropy,'descend');
                    pointEntropy = pointEntropy(1:round(avaliableFea{oct,lay}.cell(cellit,celljt)));
                    I = I(1:round(avaliableFea{oct,lay}.cell(cellit,celljt)));
                    
                    % 该cell中最终选取的n_cell个点在当前层的位置
                    finalKeypointIndex = cellIndex(I);
                    rowsize = size(row,2);
                    realKeypointColumn = column(ceil(finalKeypointIndex/rowsize));
                    % 真实坐标位置
                    realKeypointRow = mod(finalKeypointIndex,rowsize);
                    realKeypointRow(realKeypointRow==0) = rowsize;
                    realKeypointRow = row(realKeypointRow);
                    [finalLocat,pointEntropy,I] =  ditributedFeaSele([realKeypointRow;realKeypointColumn], round(avaliableFea{oct,lay}.cell(cellit,celljt)),6,pointEntropy,I);
%                     if ~isempty(finalLocat)
%                         m = figure();
%                         imshow(image);
%                         hold on
%                         plot(finalLocat(2,:),finalLocat(1,:),'r+');
%                         hold off
%                         saveas(m,['E:\学习\ur-sift\单layer特征点提取情况\oct ' num2str(octave) '-lay ' num2str(layer) '-cellH ' num2str(it) '-cellW ' num2str(jt) '.bmp']);
%                         lastIndex = [lastIndex finalLocat];
                        dotRegion = octaveDoGStack{oct}(:,:,:,lay);
                        % 最终8维特征：2维图像空间坐标，2维尺度空间坐标，2维cell索引，图像熵，图像对比度，当前cell能取到的特征点数，当前层特征点数
                        lastFeaMatrix = [lastFeaMatrix [finalLocat;repmat([oct;lay],1,length(I));repmat([cellit;celljt],1,length(I));...
                            pointEntropy;dotRegion(cellIndex(I)); ...
                            repmat(avaliableFea{oct,lay}.cell(cellit,celljt),1,length(I));repmat(pointNum(oct,lay),1,length(I))]];         
%                     end
                end
            end
   
        end
        
    end
end

[~,lastFeaInd,~] = unique(lastFeaMatrix(1:4,:)','rows');
lastFeaMatrix = lastFeaMatrix(:,lastFeaInd);
% lastIndex = GlobalPointSelect(lastFeaMatrix,5);  % 过于相邻点的处理
lastIndex = lastFeaMatrix;
 
