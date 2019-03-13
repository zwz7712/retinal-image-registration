function [ output_args ] = lineChart( input_args )
%TEST2 此处显示有关此函数的摘要
%   此处显示详细说明


clc;
close all
addgen = '.\batchdata2\FIRE\Images\A人的视网膜图片\';
[NUM] = xlsread([addgen 'r通过退火率维0.93的α进行改变\metric_ursift.xls'],1);
block = find(isnan(NUM(:,1)));
num = size(block,1)/4;
figure();hold on
a = 1:num+1;
% for i = 1:14
%    (0:num)*18+i
%    x=NUM((0:num)*18++i,:);
%    plot(a,x,'k-o'); 
% end
hold off
end

