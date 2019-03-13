function [ value ] = rmse( model,scene )
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明

t_fundus = cp2tform(model,scene,'polynomial',2);
    % t_fundus 得到的是反向匹配的变换模型，是从loc2往loc1转换的系数
    x1 = tforminv(t_fundus,scene(:,1:2));
if size(model,2)==size(scene,2)
    value = sqrt(sum(sum((model-x1).^2))/size(model,1));
end

end

