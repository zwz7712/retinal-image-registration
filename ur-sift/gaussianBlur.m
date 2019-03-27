function gaussianBlur=gaussianBlur(image, sigma)


    kernelSize = round(sigma*6 + 1); 
    
    if(kernelSize<1)
        kernelSize = 1; 
    end 
	kernel = fspecial('gaussian', [kernelSize kernelSize], sigma);
	convImage = imfilter(image,kernel,'conv','replicate');
%	convImage = imfilter(image,kernel);
	gaussianBlur = convImage; 
end
