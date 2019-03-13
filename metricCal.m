function [ output_args ] = metricCal(addgen, imageNum, removeOption)
%METRICCAL 此处显示有关此函数的摘要
%   此处显示详细说明
[NUM1] = xlsread([addgen 'groundTruthPoint.xls'],1);
visible = 'off';
r=0.1;
preconte = 0;
t_fundus = cell(1,imageNum);
switch removeOption
    %% MoAG metric
    case 'MoAG'
        while r <= 1
            [NUM2] = xlsread([addgen 'r=' num2str(r) '_rigCorrMatr_ursift_contSca_proProceMat.xls'],1);
            block = find(isnan(NUM2(:,1)));
            xlswrite([addgen 'metric_ursift_contSca_proProceMat.xls'],{['r=' num2str(r)]},['A' num2str(preconte+1) ':A' num2str(preconte+1)]);
            for i=1:imageNum
                %% input data
                if i==1
                    loc = NUM2(1:block(i*2)-2,:);
                else if i ~= imageNum
                        loc = NUM2(block((i-1)*2)+1:block(i*2)-2,:);
                    else
                        loc = NUM2(block((i-1)*2)+1:end,:);
                    end
                end
                for j=1:15
                    x1(j) =  NUM1((i-1)*17+1+j-1,1);
                    y1(j) =  NUM1((i-1)*17+1+j-1,2);
                    x2(j) =  NUM1((i-1)*17+1+j-1,3);
                    y2(j) =  NUM1((i-1)*17+1+j-1,4);
                end
                conte = size(loc,1);
                loc1=loc(:,1:2);
                loc2=loc(:,3:4);
                t_fundus{i} = cp2tform([x1' y1'],[x2' y2'],'polynomial',2);
                % t_fundus 得到的是反向匹配的变换模型，是从loc2往loc1转换的系数
                transformedIm = tforminv(t_fundus{i},loc2(:,1:2));
                dist = sqrt(sum((transformedIm-loc1(:,1:2)).^2,2));
                
                mee = MEE(dist);
                mae = MAE(dist);
                rmse = RMSE(dist);
                xlswrite([addgen 'metric_ursift_contSca_proProceMat.xls'],[mee mae rmse i],1,['A' num2str(i+preconte+1) ':D' num2str(i+preconte+1)]);
                clear transformedIm
            end
            r=r+0.1;
            preconte = preconte + imageNum + 4;
        end
        %% rmse metric
    case 'RMSE'
        %         [NUM2] = xlsread([addgen 'rigCorrMatr_ursift_rmse.xls'],1);
        [NUM2] = xlsread([addgen 'rigCorrMatr_ursift_rmse.xls'],1);
        block = find(isnan(NUM2(:,1)));
        for i=1:imageNum
            %% input data
            if i==1
                loc = NUM2(1:block(i*2)-2,:);
            else if i ~= imageNum
                    loc = NUM2(block((i-1)*2)+1:block(i*2)-2,:);
                else
                    loc = NUM2(block((i-1)*2)+1:end,:);
                end
            end
            for j=1:15
                x1(j) =  NUM1((i-1)*17+1+j-1,1);
                y1(j) =  NUM1((i-1)*17+1+j-1,2);
                x2(j) =  NUM1((i-1)*17+1+j-1,3);
                y2(j) =  NUM1((i-1)*17+1+j-1,4);
            end
            conte = size(loc,1);
            loc1=loc(:,1:2);
            loc2=loc(:,3:4);
            t_fundus{i} = cp2tform([x1' y1'],[x2' y2'],'polynomial',2);
            % t_fundus 得到的是反向匹配的变换模型，是从loc2往loc1转换的系数
            transformedIm = tforminv(t_fundus{i},loc2(:,1:2));
            dist = sqrt(sum((transformedIm-loc1(:,1:2)).^2,2));
            
            mee = MEE(dist);
            mae = MAE(dist);
            rmse = RMSE(dist);
                        xlswrite([addgen 'metric_ursift_rmse.xls'],[mee mae rmse i],1,['A' num2str(i+preconte+1) ':D' num2str(i+preconte+1)]);
%             xlswrite([addgen 'metric_surf_piifd_rpm.xls'],[mee mae rmse i],1,['A' num2str(i+preconte+1) ':D' num2str(i+preconte+1)]);
        end
        
end

end


% 中位误差，误差阈值为1.5个像素 高于即认为是错误，阈值确定根据论文piifd、2002 hierarchiacal
function result = MEE(dist)
[B,I] = sort(dist);
num = size(dist,1);
if mod(num,2)==0
    result = B(num/2)+B(num/2+1)/2;
else
    result = B((num+1)/2);
end
end
% 最大误差
function result = MAE(dist)
result = max(dist);
end
% 均方根误差
function result = RMSE(dist)
result = sqrt(sum(dist.^2)/size(dist,1));
end