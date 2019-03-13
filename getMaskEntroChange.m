function [ mask ] = getMaskEntroChange( weigh, imSize )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
figure();
preMask =zeros(imSize);
entroPre = 0;
entroBefoPre = 0;

for j=0:20:255
    mask = zeros(imSize);
    num=0;
    % 对所有超像素的熵值进行计算，用阈值进行区分
    for i=1:BlockIndexNum
        ind = find(lab==i);
        if length(ind)>1
            num = num+1;
            if weigh(num)>j
                mask(ind) = weigh(num);
            end
        end
    end
    imshow(uint8(mask));
    inds = find(mask);
    entroNow = entropy(uint8(im(inds)));
    entroIm =  entropy(uint8(im));
    %% 固定迭代次数
    %         if entroNow > entroIm
    %             num=num+1;
    %             if num==9
    %                 break;
    %             end
    %         else
    %             num=0;
    %         end
    %% 突变点
    if sign(entroNow-entroPre)==sign(entroBefoPre-entroPre) && entroNow-entroPre~=0
        break;
    else
        preMask = mask;
    end
    figure();imshow(uint8(mask));
    entroBefoPre = entroPre;
    entroPre = entroNow;
end
h=figure('visible','off');
imshow(uint8(mask));

%
%  saveas(h,['E:\学习\ur-sift(1)\ur-sift\SlicMask\' num2str(imageNum) '.bmp']);
% %  close(h)

end

