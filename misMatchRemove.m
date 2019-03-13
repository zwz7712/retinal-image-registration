function [ output_args ] = misMatchRemove( addgen, imageNum, imageScale, removeOption )
clc
close all


switch removeOption
    %% % ------ Roubst Point Matching for outliers with MoAG ------ %
    case 'MoAG'
        r = 0.1;
        [NUM] = xlsread([addgen 'misCorrMatr_contSca_proProceMat.xls'],1);
        block = find(isnan(NUM(:,1)));
        while r <= 1
            clc
            close all
            preconte = 1;
            
            for i = 1:imageNum
                image1 = [addgen num2str(2*i-1) '.jpg'];
%                                                                 image1 = [addgen num2str(i) '.bmp'];
                image2 = [addgen num2str(2*i) '.jpg'];
%                                                                 image2 = [addgen num2str(i) 's.bmp'];
                im1 = imread(image1);
                im2 = imread(image2);
                if size(im1,3)>1
                    im1=im1(:,:,2);
                end
                if size(im2,3)>1
                    im2=im2(:,:,2);
                end
                im1 = imresize(im1,imageScale);
                im2 = imresize(im2,imageScale);
                %% input data
                if i==1
                    loc = NUM(1:block(i*2)-2,:);
                elseif i ~= imageNum
                    loc = NUM(block((i-1)*2)+1:block(i*2)-2,:);
                else
                    loc = NUM(block((i-1)*2)+1:end,:);
                end
                x1=loc(:,1:2);
                x2=loc(:,3:4);
%                                                 showmatch(im1,im2,x1,x2,0);
                [ys,indx]=RPM(x1,x2,r);
                loc1=loc(indx,1:2);
                loc2=loc(indx,3:4);
                conte = size(loc1,1);
                loc1(:,1:2) = cpcorr(loc1(:,1:2),loc2(:,1:2),im1,im2);
                %                 showmatch(im1,im2,loc1,loc2,0); %改变非对称高斯模型参数r的图像保存
                %                 showmatch(im1,im2,loc1,loc2,0);                       %默认不保存图像文件
                %                 showmatch(im1,im2,loc1,loc2,0);
                locat = [loc1(:,1:2),loc2(:,1:2) indx];
                if isempty(locat)
                    locat = [0 0 0 0 0];
                    conte = 1;
                end
                xlswrite([addgen 'r=' num2str(r) '_rigCorrMatr_ursift_contSca_proProceMat.xls'],locat,['A' num2str(preconte+2) ':E' num2str(preconte+conte+1)]);
                preconte = preconte+conte+2;
            end
            r=r+0.1;
        end
        
        %% % ------ remove Mismatch with rmse ------ %
    case 'RMSE'
        [NUM] = xlsread([addgen 'misCorrMatr_contSca_proProceMat.xls'],1);
        block = find(isnan(NUM(:,1)));
        preconte = 1;
        for i=1:imageNum
            clc;
            close all
            %                         image1 = [addgen num2str(2*i-1) '.jpg'];
            image1 = [addgen num2str(i) '.bmp'];
            %                         image2 = [addgen num2str(2*i) '.jpg'];
            image2 = [addgen num2str(i) 's.bmp'];
            im1 = imread(image1);
            im2 = imread(image2);
            if size(im1,3)>1
                im1=im1(:,:,2);
            end
            if size(im2,3)>1
                im2=im2(:,:,2);
            end
            im1 = imresize(im1,imageScale);
            im2 = imresize(im2,imageScale);
            %% input data
            if i==1
                loc = NUM(1:block(i*2)-2,:);
            elseif i ~= imageNum
                loc = NUM(block((i-1)*2)+1:block(i*2)-2,:);
            else
                loc = NUM(block((i-1)*2)+1:end,:);
            end
            x1=loc(:,1:2);
            x2=loc(:,3:4);
            %             showmatch(im1,im2,x1,x2,0);
            [loc1,loc2,indx] = outlierRejectRmse(im1,im2,x1,x2,addgen,i);
            conte = size(loc1,1);
            %                   showmatch(im1,im2,loc1,loc2,0);
            i
            locat = [loc1 loc2 indx];
            if isempty(locat)
                locat = [0 0 0 0 0];
                conte = 1;
            end
            xlswrite([addgen 'rigCorrMatr_ursift_rmse.xls'],locat,['A' num2str(preconte+2) ':E' num2str(preconte+conte+1)]);
            preconte = preconte+conte+2;
        end
end
end
