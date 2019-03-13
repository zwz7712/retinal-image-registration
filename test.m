
function [ output_args ] = test( input_args )
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
clc;
close all;
addpath(genpath(pwd));
imread()
dt = DelaunayTri(x(:),y(:));
k = convexHull(dt);
abs(trapz(dt.X(k,1),dt.X(k,2)))

end
