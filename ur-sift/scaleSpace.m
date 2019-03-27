%function that returns the scale space as described in the David Lowe paper
%To build it I used as reference the following papers of David Lowe:
%[1] - Object Recognition from Local Scale-Invariant Features - http://www.cs.ubc.ca/~lowe/papers/iccv99.pdf
%[2] - Distinctive Image Features from Scale-Invariant Keypoints - http://www.cs.ubc.ca/~lowe/papers/ijcv04.pdf


function scaleSpace=scaleSpace(image, octaves, scales,initialSigma)
%       function:
%             生成高斯金字塔
%       Input:
%             image :  原图图像
%             octaves: 组数
%             scales:  每组层数（这里只最终生成的尺度空间的在每组内的尺度数)
%             initialSigma: 初始高斯函数中参数Sigma值
%
%       Output:
%             scaleSpace: 尺度空间结构体
%                         scaleSpace{1}:
%                            cellOctaves{octaves}(rows,column,dim,scales+3)
%                            即高斯金字塔某组中某层的图像结构体
%                         sacleSpace{2}:
%                            accumsigmas(octaves,scales)
%                            最终尺度空间中某组某尺度对应的尺度系数
if ndims(image)==3
    grayScaleIm = rgb2gray(image);
else
    grayScaleIm = image;
end
% 归一化操作
grayScaleIm = im2double(grayScaleIm);
%     grayScaleIm = double(grayScaleIm);
%     grayScaleIm = grayScaleIm-min(grayScaleIm(:));
%     grayScaleIm = grayScaleIm/max(grayScaleIm(:));

%     grayScaleIm = double(grayScaleIm)/double(255.0);
firstBlurSigma = 0.5;

%step 1: double the image size prior to building the first level of the pyramid
%this must be done after bluring the original image with gaussian of sigma = 0.5.
%This is suggested in the section 3.3 in paper [2].


initialBluredImage = gaussianBlur(grayScaleIm,firstBlurSigma);
% size(initialBluredImage)
initialDoubleSizeImage = imresize(initialBluredImage, 2, 'bicubic'); %grayScaleIm; %imresize(grayScaleIm, 2, 'bilinear');


%	initialDoubleSizeImage = gaussianBlur(initialDoubleSizeImage,1,kernelSize);



%in section 3.3 of [2] is suggested to use sigma = 1.6
% 	initialSigma = sqrt(2); %1.6; %sqrt(2);
currentSigma = initialSigma;

totScales = scales + 3;

previousDoubleSizeImage = initialDoubleSizeImage ;


cellOctaves = cell(1,5);
lastSigma = 0;
%记录每个像素点在原图中的x，y坐标
piexlHigh = cell(1,octaves);
piexlWidth = cell(1,octaves);
piexlHigh{1} = 1:1:size(grayScaleIm,1);
piexlWidth{1} = 1:1:size(grayScaleIm,2);
%     figure
%%
for octave = 1:octaves+1
    sigma = zeros(size(initialDoubleSizeImage,1), size(initialDoubleSizeImage,2), size(initialDoubleSizeImage,3) ,totScales);
    % 初始化对应组的图像库
    cellOctaves{octave} = sigma;
    if octave >= 3
        piexlHigh{octave-1} = reduceInHalf(piexlHigh{octave-2});
        piexlWidth{octave-1} = reduceInHalf(piexlWidth{octave-2});
    end
    % it is done for 5 blur levels
    for blur_level = 1:totScales
        %in case of the first blur, in section 3.3 of [2] it states that since the original image was pre-smoothed with sigma = 0.5,
        %"This means that little additional smoothing is needed prior to creation of the first octave os scale space". Basically, we know that the image is already blurred with
        %sigma = 1 (0.5 * 2 since it was upscaled) , we have to complete the rest of the blur until reaching sigma = 1.6 (initialSigma), which can be calculated using the following equation:
        %sqrt(initialSigma^2 - (2*0.5)^2), this is what I do next in the code
        if(octave==1 && blur_level == 1)
            bluredImage = gaussianBlur(previousDoubleSizeImage,sqrt(initialSigma^2 - (firstBlurSigma*2)^2));
        else if (blur_level == 1)
                %TODO: the 3 must be parametrized as round(totScales/2)
                bluredImage = previousDoubleSizeImage;
            else
                bluredImage = gaussianBlur(previousDoubleSizeImage,sqrt(currentSigma^2-lastSigma^2));
            end
        end
        k = (2^((blur_level)/scales));
        previousDoubleSizeImage = bluredImage;
        disp(['Octave ' num2str(octave) ' blur level ' num2str(blur_level) '  sigma ' num2str(currentSigma)]);
        cellOctaves{octave}(:, :, :,blur_level) = bluredImage;
% %         find(isnan(bluredImage))
%                 subplot(octaves+1,6,(octave-1)*totScales+blur_level)
%                 imshow(uint8(bluredImage));
        lastSigma = currentSigma;
        currentSigma  = initialSigma * k;
    end
    currentSigma = initialSigma;
    %in [2] it states to resample two images from the top (totScales-3)
    initialDoubleSizeImage = reduceInHalf(cellOctaves{octave}(:,:,:,totScales-2)); %imresize(initialDoubleSizeImage, 0.5, 'bilinear'); %reduceInHalf(cellOctaves{octave}(:,:,:,3)); %imresize(initialDoubleSizeImage, 0.5, 'bilinear');
    previousDoubleSizeImage = initialDoubleSizeImage;
    
end
%%
returnData = cell(1,5);
celloctaves = cell(1,4);
for i=1:octaves
    celloctaves{i} = cellOctaves{i+1};
end
% accumsigmas(octaves,totScales)
accumsigmas = calcuCoefficient(initialSigma ,octaves,scales);
returnData{1} = celloctaves;
returnData{2} = accumsigmas;
returnData{3} = piexlHigh;
returnData{4} = piexlWidth;
returnData{5} = image;

scaleSpace = returnData;

%As suggested in section 3 of paper [2], the reduction is done by taking every second pixel
%% 隔点采样
    function reduceInHalf = reduceInHalf(image)
        if  size(image,2)==1
            reduceInHalf = (image(1:2:end));
        else
            reduceInHalf = image(1:2:end,1:2:end) ;
        end
    end
end
