function octavesNum = calculateOctaves( image, des)
%   function:
%            Input:
%                   image: 源图像
%                   topSize： 金字塔顶图像大小
%            Output:
%                   octavesNum: 金字塔octaves数

    size_im = size(image);
    min_size = min(size_im(1),size_im(2));
    octavesNum = floor(log2(min_size)-log2(topSize));
end

