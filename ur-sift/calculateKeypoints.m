function keyPointsData = calculateKeypoints( octaveDoGStack, image, imageName )
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

keypointsMap = cell(size(octaveDoGStack,2), size(octaveDoGStack{1},4)-2);
keyPointsMap = cell(size(octaveDoGStack,2), size(octaveDoGStack{1},4)-2);
cant = 0;
totalNum = 0;
%    size(dogDescriptors,1)
si = size(octaveDoGStack{1},3);
fileName = [imageName '的尺度系数与keypoints数关系.txt'];
delete(fileName);
fp = fopen(fileName,'a');
for octave = 1:size(octaveDoGStack,2)
    for layer = 2:(size(octaveDoGStack{octave},4)-1)
        
        keypointsMap{octave,layer-1} = zeros(size(octaveDoGStack{octave},1), size(octaveDoGStack{octave},2));
        % 边缘一圈不予考虑
        for row = 2:size(octaveDoGStack{octave},1)-1
            for column = 2:size(octaveDoGStack{octave},2)-1
                %checks if it is maxima
                if octaveDoGStack{octave}(row,column,1,layer) > octaveDoGStack{octave}(row-1,column,1,layer) && ...
                        octaveDoGStack{octave}(row,column,1,layer) > octaveDoGStack{octave}(row-1,column-1,1,layer) && ...
                        octaveDoGStack{octave}(row,column,1,layer) > octaveDoGStack{octave}(row,column-1,1,layer) && ...
                        octaveDoGStack{octave}(row,column,1,layer) > octaveDoGStack{octave}(row+1,column-1,1,layer) && ...
                        octaveDoGStack{octave}(row,column,1,layer) > octaveDoGStack{octave}(row+1,column,1,layer) && ...
                        octaveDoGStack{octave}(row,column,1,layer) > octaveDoGStack{octave}(row+1,column+1,1,layer) && ...
                        octaveDoGStack{octave}(row,column,1,layer) > octaveDoGStack{octave}(row,column+1,1,layer) && ...
                        octaveDoGStack{octave}(row,column,1,layer) > octaveDoGStack{octave}(row-1,column+1,1,layer) && ...
                        octaveDoGStack{octave}(row,column,1,layer) > octaveDoGStack{octave}(row-1,column,1,layer-1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) > octaveDoGStack{octave}(row-1,column-1,1,layer-1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) > octaveDoGStack{octave}(row,column-1,1,layer-1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) > octaveDoGStack{octave}(row+1,column-1,1,layer-1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) > octaveDoGStack{octave}(row+1,column,1,layer-1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) > octaveDoGStack{octave}(row+1,column+1,1,layer-1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) > octaveDoGStack{octave}(row,column+1,1,layer-1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) > octaveDoGStack{octave}(row-1,column+1,1,layer-1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) > octaveDoGStack{octave}(row,column,1,layer-1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) > octaveDoGStack{octave}(row-1,column,1,layer+1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) > octaveDoGStack{octave}(row-1,column-1,1,layer+1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) > octaveDoGStack{octave}(row,column-1,1,layer+1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) > octaveDoGStack{octave}(row+1,column-1,1,layer+1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) > octaveDoGStack{octave}(row+1,column,1,layer+1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) > octaveDoGStack{octave}(row+1,column+1,1,layer+1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) > octaveDoGStack{octave}(row,column+1,1,layer+1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) > octaveDoGStack{octave}(row-1,column+1,1,layer+1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) > octaveDoGStack{octave}(row,column,1,layer+1)
                    
                    if(keypointsMap{octave,layer-1}(row,column) == 0 && abs(octaveDoGStack{octave}(row,column,1,layer))>0.001)
                        keypointsMap{octave,layer-1}(row,column) = octaveDoGStack{octave}(row,column,1,layer);
                        cant = cant + 1;
                        
                    end
                end
                
                
                %checks if it is minima
                if octaveDoGStack{octave}(row,column,1,layer) < octaveDoGStack{octave}(row-1,column,1,layer) && ...
                        octaveDoGStack{octave}(row,column,1,layer) < octaveDoGStack{octave}(row-1,column-1,1,layer) && ...
                        octaveDoGStack{octave}(row,column,1,layer) < octaveDoGStack{octave}(row,column-1,1,layer) && ...
                        octaveDoGStack{octave}(row,column,1,layer) < octaveDoGStack{octave}(row+1,column-1,1,layer) && ...
                        octaveDoGStack{octave}(row,column,1,layer) < octaveDoGStack{octave}(row+1,column,1,layer) && ...
                        octaveDoGStack{octave}(row,column,1,layer) < octaveDoGStack{octave}(row+1,column+1,1,layer) && ...
                        octaveDoGStack{octave}(row,column,1,layer) < octaveDoGStack{octave}(row,column+1,1,layer) && ...
                        octaveDoGStack{octave}(row,column,1,layer) < octaveDoGStack{octave}(row-1,column+1,1,layer) && ...
                        octaveDoGStack{octave}(row,column,1,layer) < octaveDoGStack{octave}(row-1,column,1,layer-1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) < octaveDoGStack{octave}(row-1,column-1,1,layer-1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) < octaveDoGStack{octave}(row,column-1,1,layer-1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) < octaveDoGStack{octave}(row+1,column-1,1,layer-1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) < octaveDoGStack{octave}(row+1,column,1,layer-1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) < octaveDoGStack{octave}(row+1,column+1,1,layer-1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) < octaveDoGStack{octave}(row,column+1,1,layer-1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) < octaveDoGStack{octave}(row-1,column+1,1,layer-1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) < octaveDoGStack{octave}(row,column,1,layer-1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) < octaveDoGStack{octave}(row-1,column,1,layer+1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) < octaveDoGStack{octave}(row-1,column-1,1,layer+1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) < octaveDoGStack{octave}(row,column-1,1,layer+1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) < octaveDoGStack{octave}(row+1,column-1,1,layer+1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) < octaveDoGStack{octave}(row+1,column,1,layer+1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) < octaveDoGStack{octave}(row+1,column+1,1,layer+1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) < octaveDoGStack{octave}(row,column+1,1,layer+1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) < octaveDoGStack{octave}(row-1,column+1,1,layer+1) && ...
                        octaveDoGStack{octave}(row,column,1,layer) < octaveDoGStack{octave}(row,column,1,layer+1)
                    
                    if(keypointsMap{octave,layer-1}(row,column) == 0 && abs(octaveDoGStack{octave}(row,column,1,layer))>0.001)
                        keypointsMap{octave,layer-1}(row,column) = octaveDoGStack{octave}(row,column,1,layer);
                        cant = cant + 1;
                    end
                end
                %                 % 输入相邻26个点来判断是否为极值点
                %                 tempPointsArray = zeros(1,26);
                %                 tempPointsArray(1) = octaveDoGStack{octave}(row-1,column,si,layer);
                %                 tempPointsArray(2) = octaveDoGStack{octave}(row-1,column-1,si,layer);
                %                 tempPointsArray(3) = octaveDoGStack{octave}(row,column-1,si,layer);
                %                 tempPointsArray(4) = octaveDoGStack{octave}(row+1,column-1,si,layer);
                %                 tempPointsArray(5) = octaveDoGStack{octave}(row+1,column+1,si,layer);
                %                 tempPointsArray(6) = octaveDoGStack{octave}(row,column+1,si,layer);
                %                 tempPointsArray(7) = octaveDoGStack{octave}(row+1,column,si,layer);
                %                 tempPointsArray(8) = octaveDoGStack{octave}(row-1,column+1,si,layer);
                %                 tempPointsArray(9) = octaveDoGStack{octave}(row-1,column,si,layer-1);
                %                 tempPointsArray(10) = octaveDoGStack{octave}(row-1,column-1,si,layer-1);
                %                 tempPointsArray(11) = octaveDoGStack{octave}(row,column-1,si,layer-1);
                %                 tempPointsArray(12) = octaveDoGStack{octave}(row+1,column-1,si,layer-1);
                %                 tempPointsArray(13) = octaveDoGStack{octave}(row+1,column,si,layer-1);
                %                 tempPointsArray(14) = octaveDoGStack{octave}(row+1,column+1,si,layer-1);
                %                 tempPointsArray(15) = octaveDoGStack{octave}(row,column+1,si,layer-1);
                %                 tempPointsArray(16) = octaveDoGStack{octave}(row-1,column+1,si,layer-1);
                %                 tempPointsArray(17) = octaveDoGStack{octave}(row,column,si,layer-1);
                %                 tempPointsArray(18) = octaveDoGStack{octave}(row-1,column-1,si,layer+1);
                %                 tempPointsArray(19) = octaveDoGStack{octave}(row-1,column,si,layer+1);
                %                 tempPointsArray(20) = octaveDoGStack{octave}(row,column-1,si,layer+1);
                %                 tempPointsArray(21) = octaveDoGStack{octave}(row+1,column-1,si,layer+1);
                %                 tempPointsArray(22) = octaveDoGStack{octave}(row+1,column,si,layer+1);
                %                 tempPointsArray(23) = octaveDoGStack{octave}(row+1,column+1,si,layer+1);
                %                 tempPointsArray(24) = octaveDoGStack{octave}(row,column+1,si,layer+1);
                %                 tempPointsArray(25) = octaveDoGStack{octave}(row-1,column+1,si,layer+1);
                %                 tempPointsArray(26) = octaveDoGStack{octave}(row,column,si,layer+1);
                %
                %                 compareArray = repmat(octaveDoGStack{octave}(row,column,si,layer),1,26);
                %                 %判定该点是否为极大值或极小值点（等于不包含在内）
                %                 tempPointsArray = tempPointsArray - compareArray;
                %                 checkMaxArray = find(tempPointsArray>=0, 1);
                %                 checkMinArray = find(tempPointsArray<=0, 1);
                %                 if (isempty(checkMaxArray) || isempty(checkMinArray))
                % %                     if octaveDoGStack{octave}(row,column,si,layer)>0
                % %                         if ~isempty(find(tempPointsArray>0))
                % %                             wrongnum = wrongnum+1;
                % %                         end
                % %                     end
                % %                     if octaveDoGStack{octave}(row,column,si,layer)<0
                % %                        if ~isempty(find(tempPointsArray<0))
                % %                            wrongnum = wrongnum+1;
                % %                        end
                % %                     end
                %                     keypointsMap{octave,layer-1}(row,column)=octaveDoGStack{octave}(row,column,si,layer);
                %                     cant = cant+1;
                %                 end
            end
        end
        
        % 根据每个点在差分高斯中的绝对值进行排序并平均分为10份，去掉对比度绝对值较小的1份
        cant = round(cant*9/10);
        totalNum = totalNum + cant;
        str = ['Octave ' num2str(octave) ' Layer ' num2str(layer-1) ' Key point num ' num2str(cant)];
        disp(str);
        str = [str,char(13,10)'];
        fprintf(fp,'%s',str);
        [ro,col] = find(keypointsMap{octave,layer-1}(:,:));
        index = (col-1).*size(keypointsMap{octave,layer-1},1)+ro;
        keypointsMap{octave,layer-1}(index)
        [~,inx] = sort(abs(keypointsMap{octave,layer-1}(index)),'descend');
        %         inx = inx(1:round(size(inx,1)*9/10));
        inx = inx(1:cant);
        keyPointsMap{octave,layer-1} = zeros(size(keypointsMap{octave,layer-1}));
        keyPointsMap{octave,layer-1}(index(inx)) = keypointsMap{octave,layer-1}(index(inx));
        
        cant = 0;
        clear str
    end
end
fclose(fp);
% size(keyPointsMap)
keyPointsData{1} = keyPointsMap;
keyPointsData{2} = image;
keyPointsData{3} = octaveDoGStack;
keyPointsData{4} = totalNum;% 极值点总数
end

