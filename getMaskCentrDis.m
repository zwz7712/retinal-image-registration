function [ output_args ] = getMaskCentrDis( saliency, imSize )
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
ind = find(weigh==max(weigh));
%% 判断该区域是否是中心凹区域
% 部分血管区域显著性值高于中心凹区域需要消除该影响
%方法： 中心凹区域一般不为细长型，且超像素点一般即为中心点



end

