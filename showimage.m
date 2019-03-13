function showimage( image1,image2,point1,point2,visible )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
im = rr_appendimages(image1,image2);
switch visible
    case 'on'
    h =  figure('visible',visible);
    imshow(im,[]);
    hold on
    cols = size(image1,2);
    
    for i=1:size(point1,1)
        plot(point1(i,1),point1(i,2),'g.')
        plot(point1(i,1),point1(i,2),'go')
        
    end
    for i=1:size(point2,1)
        plot(point2(i,1)+cols,point2(i,2),'g.')
        plot(point2(i,1)+cols,point2(i,2),'go')
    end
    hold off
    case 'off'
        
end

end

