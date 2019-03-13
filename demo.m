function [ output_args ] = demo( input_args )
%DEMO 此处显示有关此函数的摘要
%   此处显示详细说明
clc
close all
addpath(genpath(pwd));
addgen = '.\batchdata2\internet_multi-model_retinal_dataset\'; % 图像集源位置
imageNum = 35;  % 图像对数量
imageScale = 1;  % 缩放尺寸
removeOption = 'MoAG';
str2num
%
% STARE数据集 第5幅图仅有低r值时可行
% inrternet数据集 第10、16
% initialCorr(addgen,imageNum,imageScale,removeOption);
% misMatchRemove(addgen,imageNum,imageScale,removeOption);
% metricCal(addgen,imageNum,removeOption);
% % overlapCalculate(addgen,imageNum);
TP_TN_FP_FN(addgen,imageNum,removeOption);
% ReCall_Precision_Accuracy(addgen,imageNum,dist);
%% 找出各r值对应点集对的最优值
% r=0.1;
% preconte = 0;
% [NUM] = xlsread([addgen 'metric_ursift_contSca.xls'],1);
% block = find(isnan(NUM(:,1)));
% num = size(block,1)/4;
% nums = 1;
% for i=1:imageNum
%     x = NUM((0:num)*18+i,:);
%     [B,I] = sort(x(:,2));
%     value(i,1) = x(I(1),1);
%     value(i,2) = B(1);
%     value(i,3) = x(I(1),3);
%     value(i,4) = I(1);
%     xlswrite([addgen 'finalmetric_contSca.xls'],[value(i,:) i],['A' num2str(i),':E' num2str(i)]);
% end

end

