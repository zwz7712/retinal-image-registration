function [  ] = TP_TN_FP_FN( addgen, imageNum,removeOption)
%RECALL_PRECI 此处显示有关此函数的摘要
%   此处显示详细说明
[NUM] = xlsread([addgen 'misCorrMatr_contSca_proProceMat.xls'],1);
[NUM1] = xlsread([addgen 'groundTruthPoint.xls'],1);

block = find(isnan(NUM(:,1)));
r=1;
TP = zeros(imageNum ,1); %正匹配正分
TN = zeros(imageNum,1); %正匹配错分
FP = zeros(imageNum,1); %误匹配正分
FN = zeros(imageNum,1); %误匹配错分
Rmse = zeros(imageNum,1);
distan = 6;
switch removeOption
    case 'MoAG'
        k=0;
        %         R = [0.9 0.8 0.9 1 0.1 1 0.8 0.2 0.9 0.3 0.4 1 0.1 0.9 0.7 1 1 0.7 0.2 0.4 0.4 0.2];
        R = [0.9 0.7 0.8 0.2 0.6 0.5 0.4 0.3 1 0.1 0.5 0.3 0.9 0.2 1 0.2 0.2 0.6 0.1 1 0.9 0.4 0.7 0.2 0.4 0.7 0.8 0.1 0.1 0.6 0.2 0.1 0.1];
        R(31)= 1;%0.7;
        R(12) = 0.3;
        R(30) = 0.8;
        R(26)= 1;%0.5;
        R(7) = 0.1;%0.3;
        R(28) = 1;% 0.9;
        R(23) = 1;
        for i=1:imageNum
            if i==10 || i==16
                k=k+1;
                i=i+1;
                continue;
            end
            r=R(i-k);
            [NUM2] = xlsread([addgen 'r=' num2str(r) '_rigCorrMatr_ursift_contSca_proProceMat.xls'],1);
            block2 = find(isnan(NUM2(:,1)));
            %             %% input data
            %             if i==1
            %                 loc = NUM(1:block(i*2)-2,:);
            %             elseif i ~= imageNum
            %                 loc = NUM(block((i-1)*2)+1:block(i*2)-2,:);
            %             else
            %                 loc = NUM(block((i-1)*2)+1:end,:);
            %             end
            %             misloc1=loc(:,1:2);
            %             misloc2=loc(:,3:4);
            
            if i==1
                locr = NUM2(1:block2(i*2)-2,:);
            elseif i ~= imageNum
                
                locr = NUM2(block2((i-1)*2)+1:block2(i*2)-2,:);
            else
                locr = NUM2(block2((i-1)*2)+1:end,:);
            end
            rigloc1 = locr(:,1:2);
            rigloc2 = locr(:,3:4);
            
            im1 = imread([addgen num2str(2*i-1) '.jpg']);
            im2 = imread([addgen num2str(2*i) '.jpg']);
            if size(im1,3)>1
                im1=im1(:,:,2);
            end
            if size(im2,3)>1
                im2=im2(:,:,2);
            end
            showmatch(im1,im2,rigloc1,rigloc2,0,i);
           
            pointNum = size(rigloc1,1);
            if pointNum >=3
                % Affine
                t_fundus = cp2tform(rigloc1(:,1:2),rigloc2(:,1:2),'affine');
                I1_c = imtransform(im1,t_fundus,'XData',[1 size(im2,2)], 'YData',[1 size(im2,1)]);
                [I1_c,I2_c] = rr_imagesize(I1_c,im2);
                a1=figure('visible','on');imshow(I1_c+I2_c,[]); title([num2str(2*i-1) '_' num2str(2*i) ' fusion image (affine)']);% intensity
                saveas(a1,['E:\学习\ur-sift实验\ur-sift\paper\fig6 组图\' num2str((i*2-1)) '-' num2str((i*2)) ' imageFusion(affine).bmp']);
                disp('Affine transformation is done.');
                if pointNum >=6
                    % 2nd Polynomial
                    t_fundus = cp2tform(rigloc1(:,1:2),rigloc2(:,1:2),'polynomial',2);
                    I1_c = imtransform(im1,t_fundus,'XData',[1 size(im2,2)], 'YData',[1 size(im2,1)]);
                    %                 transformedIm = t_fundus.transformPointsInverse(t_fundus,loc1(:,1:2));
                    [I1_c,I2_c] = rr_imagesize(I1_c,im2);
                    po1=figure('visible','on');imshow(I1_c+I2_c,[]); title([num2str(2*i-1) '_' num2str(2*i)  ' fusion image (Polynomial)']);
                    saveas(po1,['E:\学习\ur-sift实验\ur-sift\paper\fig6 组图\' num2str((i*2-1)) '-' num2str((i*2)) ' imageFusion(Polynomial).bmp']);
                    disp('2nd Polynomial transformation is done.');
                end
            end
            %             indexBe = locr(:,5);
            %             for l=1:15
            %                 x1(l) =  NUM1((i-1)*17+1+l-1,1);
            %                 y1(l) =  NUM1((i-1)*17+1+l-1,2);
            %                 x2(l) =  NUM1((i-1)*17+1+l-1,3);
            %                 y2(l) =  NUM1((i-1)*17+1+l-1,4);
            %             end
            %             nummis = size(misloc1,1);
            %             t_fundus{i} = cp2tform([x1' y1'],[x2' y2'],'polynomial',2);
            %             % t_fundus 得到的是反向匹配的变换模型，是从loc2往loc1转换的系数
            %             transformedIm = tforminv(t_fundus{i},misloc2(:,1:2));
            %             dist = sqrt(sum((transformedIm-misloc1(:,1:2)).^2,2));
            %             index = find(dist<distan);
            %             for j = 1:nummis
            %                 if isempty(find(index==j))
            %                     %初匹配错误
            %                     if isempty(find(indexBe==j))
            %                         % 错分
            %                         TN(i) = TN(i)+1;
            %                     else
            %                         %正分
            %                         FP(i) = FP(i)+1;
            %                     end
            %                 else
            %                     %初匹配正确
            %                     if isempty(find(indexBe==j))
            %                         % 错分
            %                         FN(i) = FN(i)+1;
            %                     else
            %                         %正分
            %                         TP(i) = TP(i)+1;
            %                     end
            %                 end
            %             end
            %              transformedIm = tforminv(t_fundus{i},rigloc2(:,1:2));
            %             distrm = sqrt(sum((transformedIm-rigloc1(:,1:2)).^2,2));
            %             Rmse(i) = RMSE(distrm);
            %             xlswrite([addgen 'TP_TN_FP_FN_MoAG' num2str(distan) '.xls'],[TP(i) TN(i) FP(i) FN(i)],['A' num2str(i) ':D' num2str(i)]);
            %             clear NUM2
        end
        %            [NUM3] = xlsread([addgen 'TP_TN_FP_FN_MoAG' num2str(distan) '.xls'],1);
        %         for i=1:imageNum
        %             TP = NUM3(i,1);
        %             TN = NUM3(i,2);
        %             FP = NUM3(i,3);
        %             FN = NUM3(i,4);
        %             recall(i) = TP/(TP+FN);
        %             precision(i) = TP/(TP+FP);
        %             accuracy(i) = (TP+TN)/(TP+FP+TN+FN);
        %         end
        %         xlswrite([addgen 'recall_precision_accuracy_MoAG' num2str(distan) '.xls'], [recall' precision' accuracy' Rmse], ['A1:D' num2str(imageNum)]);
        %
    case 'RMSE'
        for i=1:imageNum
            
            [NUM2] = xlsread([addgen 'rigCorrMatr_ursift_rmse.xls'],1);
            block2 = find(isnan(NUM2(:,1)));
            %% input data
            if i==1
                loc = NUM(1:block(i*2)-2,:);
            elseif i ~= imageNum
                loc = NUM(block((i-1)*2)+1:block(i*2)-2,:);
            else
                loc = NUM(block((i-1)*2)+1:end,:);
            end
            misloc1=loc(:,1:2);
            misloc2=loc(:,3:4);
            
            if i==1
                locr = NUM2(1:block2(i*2)-2,:);
            elseif i ~= imageNum
                
                locr = NUM2(block2((i-1)*2)+1:block2(i*2)-2,:);
            else
                locr = NUM2(block2((i-1)*2)+1:end,:);
            end
            rigloc1 = locr(:,1:2);
            rigloc2 = locr(:,3:4);
            indexBe = locr(:,5);
            for l=1:15
                x1(l) =  NUM1((i-1)*17+1+l-1,1);
                y1(l) =  NUM1((i-1)*17+1+l-1,2);
                x2(l) =  NUM1((i-1)*17+1+l-1,3);
                y2(l) =  NUM1((i-1)*17+1+l-1,4);
            end
            nummis = size(misloc1,1);
            t_fundus{i} = cp2tform([x1' y1'],[x2' y2'],'polynomial',2);
            % t_fundus 得到的是反向匹配的变换模型，是从loc2往loc1转换的系数
            transformedIm = tforminv(t_fundus{i},misloc2(:,1:2));
            dist = sqrt(sum((transformedIm-misloc1(:,1:2)).^2,2));
            index = find(dist<distan);
            for j = 1:nummis
                if isempty(find(index==j))
                    %初匹配错误
                    if isempty(find(indexBe==j))
                        % 错分
                        TN(i) = TN(i)+1;
                    else
                        %正分
                        FP(i) = FP(i)+1;
                    end
                else
                    %初匹配正确
                    if isempty(find(indexBe==j))
                        % 错分
                        FN(i) = FN(i)+1;
                    else
                        %正分
                        TP(i) = TP(i)+1;
                    end
                end
            end
            transformedIm = tforminv(t_fundus{i},rigloc2(:,1:2));
            distrm = sqrt(sum((transformedIm-rigloc1(:,1:2)).^2,2));
            Rmse(i) = RMSE(distrm);
            xlswrite([addgen 'TP_TN_FP_FN_ursift_rmse' num2str(distan) '.xls'],[TP(i) TN(i) FP(i) FN(i)],['A' num2str(i) ':D' num2str(i)]);
            clear NUM2
        end
        [NUM3] = xlsread([addgen 'TP_TN_FP_FN_ursift_rmse' num2str(distan) '.xls'],1);
        for i=1:imageNum
            TP = NUM3(i,1);
            TN = NUM3(i,2);
            FP = NUM3(i,3);
            FN = NUM3(i,4);
            recall(i) = TP/(TP+FN);
            precision(i) = TP/(TP+FP);
            accuracy(i) = (TP+TN)/(TP+FP+TN+FN);
        end
        xlswrite([addgen 'recall_precision_accuracy_ursift_rmse' num2str(distan) '.xls'], [recall' precision' accuracy' Rmse], ['A1:D' num2str(imageNum)]);
        
    case 'RANSAC'
        %% input data
        for i=1:imageNum
            if i==1
                loc = NUM(1:block(i*2)-2,:);
            elseif i ~= imageNum
                loc = NUM(block((i-1)*2)+1:block(i*2)-2,:);
            else
                loc = NUM(block((i-1)*2)+1:end,:);
            end
            misloc1=loc(:,1:2);
            misloc2=loc(:,3:4);
            t = 0.04;
            maxtries = 2000;
            [F, inliers] = ransacfitfundmatrix(misloc1', misloc2', t,maxtries);
            indexBe=inliers;
            rigloc1 = misloc1(inliers,:);
            rigloc2 = misloc2(inliers,:);
            for l=1:15
                x1(l) =  NUM1((i-1)*17+1+l-1,1);
                y1(l) =  NUM1((i-1)*17+1+l-1,2);
                x2(l) =  NUM1((i-1)*17+1+l-1,3);
                y2(l) =  NUM1((i-1)*17+1+l-1,4);
            end
            nummis = size(misloc1,1);
            t_fundus{i} = cp2tform([x1' y1'],[x2' y2'],'polynomial',2);
            % t_fundus 得到的是反向匹配的变换模型，是从loc2往loc1转换的系数
            transformedIm = tforminv(t_fundus{i},misloc2(:,1:2));
            dist = sqrt(sum((transformedIm-misloc1(:,1:2)).^2,2));
            index = find(dist<distan);
            for j = 1:nummis
                if isempty(find(index==j))
                    %初匹配错误
                    if isempty(find(indexBe==j))
                        % 错分
                        TN(i) = TN(i)+1;
                    else
                        %正分
                        FP(i) = FP(i)+1;
                    end
                else
                    %初匹配正确
                    if isempty(find(indexBe==j))
                        % 错分
                        FN(i) = FN(i)+1;
                    else
                        %正分
                        TP(i) = TP(i)+1;
                    end
                end
            end
            transformedIm = tforminv(t_fundus{i},rigloc2(:,1:2));
            distrm = sqrt(sum((transformedIm-rigloc1(:,1:2)).^2,2));
            Rmse(i) = RMSE(distrm);
            xlswrite([addgen 'TP_TN_FP_FN_RANSAC' num2str(distan) '.xls'],[TP(i) TN(i) FP(i) FN(i)],['A' num2str(i) ':D' num2str(i)]);
            clear NUM2
        end
        [NUM3] = xlsread([addgen 'TP_TN_FP_FN_RANSAC' num2str(distan) '.xls'],1);
        for i=1:imageNum
            TP = NUM3(i,1);
            TN = NUM3(i,2);
            FP = NUM3(i,3);
            FN = NUM3(i,4);
            recall(i) = TP/(TP+FN);
            precision(i) = TP/(TP+FP);
            accuracy(i) = (TP+TN)/(TP+FP+TN+FN);
        end
        xlswrite([addgen 'recall_precision_accuracy_RANSAC' num2str(distan) '.xls'], [recall' precision' accuracy' Rmse], ['A1:D' num2str(imageNum)]);
        
end
%  recall(i) = TP./(TP+FN);
% precision(i) = TP./(TP+FP);
% accuracy(i) = (TP+TN)./(TP+FP+TN+FN);
% xlswrite([addgen 'recall_precision_accuracy_' num2str(dist) '.xls'], [recall precision accuracy], ['A1:C' num2str(imageNum)]);

end

function result = RMSE(dist)
result = sqrt(sum(dist.^2)/size(dist,1));
end