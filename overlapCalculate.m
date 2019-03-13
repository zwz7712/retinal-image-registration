function [ overlapProport ] = overlapCalculate( addgen,imageNum )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
[NUM1] = xlsread([addgen 'groundTruthPoint.xls'],1);
for i=1:imageNum
    for j=1:15
        x1(j) =  NUM1((i-1)*17+1+j-1,1);
        y1(j) =  NUM1((i-1)*17+1+j-1,2);
        x2(j) =  NUM1((i-1)*17+1+j-1,3);
        y2(j) =  NUM1((i-1)*17+1+j-1,4);
    end
    t_fundus{i} = cp2tform([x1' y1'],[x2' y2'],'polynomial',2);
end
overlapProport = overlapRegion(addgen,imageNum,t_fundus);
xlswrite([addgen 'overlapProport.xls'],overlapProport);
end

