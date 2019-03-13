function  image  = removeOutImage( img, msk, showImage)
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明
image = img;
    ind = find(msk==0);
    if showImage
        image(ind)=0;
        figure;
        imshow(image);
        title('预处理后通过mask截取的图')
    end
end

