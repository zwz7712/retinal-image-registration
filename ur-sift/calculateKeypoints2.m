function keyPointsData = calculateKeypoints2( dogDescriptors, mask, scaleSpace )
%       function:
%               计算极值点
%       Input:
%               dogDescriptors: 差分高斯金字塔
%               image: 源图像
%       Output:
%               keyPointsData: 关键点结构体
%                   {1}:keyPointsMap 关键点在尺度空间的位置
%                   {2}:image 源图像
%                   {3}:dogDescriptors 差分高斯金字塔
%                   {4}:cant 关键点个数
keypointsMap = cell(size(dogDescriptors,2), size(dogDescriptors{1},4)-2);
keyPointsMap = cell(size(dogDescriptors,2), size(dogDescriptors{1},4)-2);
piexlHigh = scaleSpace{3};
piexlWidth = scaleSpace{4};
cantNum=cell(size(dogDescriptors,1));

size(dogDescriptors,2)
%    size(dogDescriptors,1)
si = size(dogDescriptors{1},3);
for octave = 1:size(dogDescriptors,2)
    cantNum{octave}=zeros(size(dogDescriptors{octave},4)-2);
    
    for layer = 2:(size(dogDescriptors{octave},4)-1)
        
        keypointsMap{octave,layer-1} = zeros(size(dogDescriptors{octave},1), size(dogDescriptors{octave},2));
        for row = 2:size(dogDescriptors{octave},1)-1
            for column = 2:size(dogDescriptors{octave},2)-1
                % 输入相邻26个点来判断是否为极值点
                tempPointsArray = zeros(26);
                tempPointsArray(1) = dogDescriptors{octave}(row-1,column,si,layer);
                tempPointsArray(2) = dogDescriptors{octave}(row-1,column-1,si,layer);
                tempPointsArray(3) = dogDescriptors{octave}(row,column-1,si,layer);
                tempPointsArray(4) = dogDescriptors{octave}(row+1,column-1,si,layer);
                tempPointsArray(5) = dogDescriptors{octave}(row+1,column+1,si,layer);
                tempPointsArray(6) = dogDescriptors{octave}(row,column+1,si,layer);
                tempPointsArray(7) = dogDescriptors{octave}(row+1,column,si,layer);
                tempPointsArray(8) = dogDescriptors{octave}(row-1,column+1,si,layer);
                tempPointsArray(9) = dogDescriptors{octave}(row-1,column,si,layer-1);
                tempPointsArray(10) = dogDescriptors{octave}(row-1,column-1,si,layer-1);
                tempPointsArray(11) = dogDescriptors{octave}(row,column-1,si,layer-1);
                tempPointsArray(12) = dogDescriptors{octave}(row+1,column-1,si,layer-1);
                tempPointsArray(13) = dogDescriptors{octave}(row+1,column,si,layer-1);
                tempPointsArray(14) = dogDescriptors{octave}(row+1,column+1,si,layer-1);
                tempPointsArray(15) = dogDescriptors{octave}(row,column+1,si,layer-1);
                tempPointsArray(16) = dogDescriptors{octave}(row-1,column+1,si,layer-1);
                tempPointsArray(17) = dogDescriptors{octave}(row,column,si,layer-1);
                tempPointsArray(18) = dogDescriptors{octave}(row-1,column-1,si,layer+1);
                tempPointsArray(19) = dogDescriptors{octave}(row-1,column,si,layer+1);
                tempPointsArray(20) = dogDescriptors{octave}(row,column-1,si,layer+1);
                tempPointsArray(21) = dogDescriptors{octave}(row+1,column-1,si,layer+1);
                tempPointsArray(22) = dogDescriptors{octave}(row+1,column,si,layer+1);
                tempPointsArray(23) = dogDescriptors{octave}(row+1,column+1,si,layer+1);
                tempPointsArray(24) = dogDescriptors{octave}(row,column+1,si,layer+1);
                tempPointsArray(25) = dogDescriptors{octave}(row-1,column+1,si,layer+1);
                tempPointsArray(26) = dogDescriptors{octave}(row,column,si,layer+1);
                
                compareArray = repmat(dogDescriptors{octave}(row,column,si,layer),26);
                
                tempPointsArray = tempPointsArray - compareArray;
                checkMaxArray = find(tempPointsArray>0, 1);
                checkMinArray = find(tempPointsArray<0, 1);
                if (isempty(checkMaxArray) || isempty(checkMinArray)) && abs(dogDescriptors{octave}(row,column,si,layer))>0.001...
                        && mask(piexlHigh{octave}(row),piexlWidth{octave}(column))~=0
                    tempRow =row;
                    tempCol=column;
                    tempLayer=layer;
                    ansRight=0;
                    for i=1:5
                        try
                        difRow=(dogDescriptors{octave}(tempRow+1,tempCol,si,tempLayer)-dogDescriptors{octave}(tempRow-1,tempCol,si,tempLayer))/2;
                        catch
                           tempRow
                           row
                           error('wrong');
                        end
                        difCol=(dogDescriptors{octave}(tempRow,tempCol+1,si,tempLayer)-dogDescriptors{octave}(tempRow,tempCol-1,si,tempLayer))/2;
                        difLayer=(dogDescriptors{octave}(tempRow,tempCol,si,tempLayer+1)-dogDescriptors{octave}(tempRow,tempCol,si,tempLayer-1))/2;
                        vector3dif=[difRow,difCol,difLayer]';
                        dif2Row=dogDescriptors{octave}(tempRow+1,tempCol,si,tempLayer)+dogDescriptors{octave}(tempRow-1,tempCol,si,tempLayer)-2*dogDescriptors{octave}(tempRow,tempCol,si,tempLayer);
                        dif2Col=dogDescriptors{octave}(tempRow,tempCol+1,si,tempLayer)+dogDescriptors{octave}(tempRow,tempCol-1,si,tempLayer)-2*dogDescriptors{octave}(tempRow,tempCol,si,tempLayer);
                        dif2Layer=dogDescriptors{octave}(tempRow,tempCol,si,tempLayer+1)+dogDescriptors{octave}(tempRow,tempCol,si,tempLayer-1)-2*dogDescriptors{octave}(tempRow,tempCol,si,tempLayer);
                        
                        difRowCol=dogDescriptors{octave}(tempRow+1,tempCol+1,si,tempLayer)+dogDescriptors{octave}(tempRow-1,tempCol-1,si,tempLayer)-dogDescriptors{octave}(tempRow+1,tempCol-1,si,tempLayer)-dogDescriptors{octave}(tempRow-1,tempCol+1,si,tempLayer);
                        difColLayer=dogDescriptors{octave}(tempRow,tempCol+1,si,tempLayer+1)+dogDescriptors{octave}(tempRow,tempCol-1,si,tempLayer-1)-dogDescriptors{octave}(tempRow,tempCol+1,si,tempLayer-1)-dogDescriptors{octave}(tempRow,tempCol-1,si,tempLayer+1);
                        difLayerRow=dogDescriptors{octave}(tempRow+1,tempCol,si,tempLayer+1)+dogDescriptors{octave}(tempRow-1,tempCol,si,tempLayer-1)-dogDescriptors{octave}(tempRow+1,tempCol,si,tempLayer-1)-dogDescriptors{octave}(tempRow-1,tempCol,si,tempLayer+1);
                        
                        matric3dif=[dif2Row,difRowCol,difLayerRow;difRowCol,dif2Col,difColLayer;difLayerRow,difColLayer,dif2Layer];
                        
                        vector3ans=matric3dif*vector3dif;
                        tempRowAns=vector3ans(1);
                        tempColAns=vector3ans(2);
                        tempLayerAns=vector3ans(3);
                        
                        if abs(tempRowAns)<0.5 &&abs(tempColAns)<0.5 &&abs(tempLayerAns)<0.5
                            ansRight=1;
                            break;
                        end
                        
                        tempRow=tempRow+round(tempRowAns);
                        tempCol=tempCol+round(tempColAns);
                        tempLayer=tempLayer+round(tempLayerAns);
                        
                        if tempRow<2 || tempCol<2 ||tempLayer<2 || tempRow>size(dogDescriptors{octave},1)-1 || tempCol>size(dogDescriptors{octave},2)-1 || tempLayer>(size(dogDescriptors{octave},4)-1)
                            break;
                        end
                        
                        
                    end
                    if ansRight==1
                        keypointsMap{octave,tempLayer-1}(tempRow,tempCol)=dogDescriptors{octave}(tempRow,tempCol,si,tempLayer);
                        cantNum{octave}(tempLayer-1)=cantNum{octave}(tempLayer-1)+1;
                    end
                end
            end
        end
        
        % 根据每个点在差分高斯中的绝对值进行排序并平均分为10份，去掉绝对值较小的1份
        cantNum{octave} = round(cantNum{octave}*9/10);
        
        [ro,col] = find(keypointsMap{octave,layer-1}(:,:)~=0);
        index = (col-1).*size(keypointsMap{octave,layer-1},1)+ro;
        [B,inx] = sort(abs(keypointsMap{octave,layer-1}(index)),'descend');
        inx = inx(1:round(size(inx,1)*9/10));
        keyPointsMap{octave,layer-1} = zeros(size(keypointsMap{octave,layer-1}));
        keyPointsMap{octave,layer-1}(index(inx)) = keypointsMap{octave,layer-1}(index(inx));
    end
end
cant = 0;
for octave = 1:size(dogDescriptors,2)
    for layer = 2:(size(dogDescriptors{octave},4)-1)
        disp(['Octave ' num2str(octave) ' Layer ' num2str(layer-1) ' Key point num ' num2str( cantNum{octave}(layer-1))]);
        cant= cant+cantNum{octave}(layer);
    end
end

size(keyPointsMap)
keyPointsData{1} = keyPointsMap;
keyPointsData{2} = dogDescriptors;
keyPointsData{3} = cant;% 极值点总个数
keyPointsData{4} = cantNum;
end

