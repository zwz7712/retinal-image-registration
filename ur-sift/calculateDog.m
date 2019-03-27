function calculateDog = calculateDog(scaleSpace)
%   function: 通过高斯金字塔来生成高斯差分金字塔
octaveStack = scaleSpace{1};

calculateDog = cell(1,size(octaveStack,2));


octaves = size(octaveStack,2);
layer = size(octaveStack{1},4);
% figure
for i = 1:octaves
    
    %each octave do the substraction of gaussians
    calculateDog{i} = zeros (size(octaveStack{i},1), size(octaveStack{i},2), size(octaveStack{i},3), size(octaveStack{i},4)-1);
    
    for j = 1:layer-1
        %substraction of the previous from the current
        calculateDog{i}(:,:,:,j) = octaveStack{i}(:,:,:,j+1) - octaveStack{i}(:,:,:,j);
%     subplot(octaves,layer-1,(i-1)*(layer-1)+j)
%     imshow(uint8(calculateDog{i}(:,:,:,j)));
    end
end

end
