function [ output_args ] = initialCorr( addgen, imageNum,imageScale,removeOption )
%         compile;

% top_folder = 'C:/User/retinal_image_registration_changeR'; % new_folder 保存要创建的文件夹，是绝对路径+文件夹名称


% option 设置
visible = 'off';        %2幅图特征点和包含无匹配以及去无匹配后对应点集图是否观看 'off' 'on'
opinion.showGreen = 0;
opinion.showMask = 0 ;
opinion.showExtend = 0;
opinion.showImageInMask = 0;
% 图28 ACI效果较好
switch removeOption
    case 'MoAG'
        preconte = 1;
        for i = 1:imageNum
            
            clc;
%             close all
            
            image1 = [addgen num2str(2*i-1) '.jpg'];
            %     image1 = [addgen num2str(i) '.bmp'];
            
            format1 = 'colored';
            image2 = [addgen num2str(2*i) '.jpg'];
            %     image2 = [addgen num2str(i) 's.bmp'];
            format2 = 'colored';
            
            % get_msk(image1,2*i-1);
            % get_msk(image2,2*i);
            [locat1,size1,im1] = ursift(image1,format1,imageScale,opinion,visible);
            % % locat1 = locat1./max(size1);
            % % figure;plot(locat1(2,:),locat1(1,:),'bo');
            %
            [locat2,size2,im2] = ursift(image2,format2,imageScale,opinion,visible);
%                             save info locat1 locat2 im1 im2
%                 load info
            % locat2 = locat2./max(size2);
            
            %% 分layer进行点对匹配
            wholeMatch = zeros(0,8);
            im1 = im2double(im1);
            im2 = im2double(im2);
            if size(im1,3)>1
                im1=im1(:,:,2);
            end
            if size(im2,3)>1
                im2=im2(:,:,2);
            end
            
            octave = max(locat1(3,:));
            layer = max(locat2(4,:));
            for oct = 1:octave
                for lay = 1:layer
                    index1 = find(locat1(3,:)==oct);
                    index2 = find(locat2(3,:)==oct);
                    l1 = round(locat1(1:2,index1(find(locat1(4,index1)==lay))));
                    l2 = round(locat2(1:2,index2(find(locat2(4,index2)==lay))));
                    cell1 = locat1(5:6,index1(find(locat1(4,index1)==lay)));
                    cell2 = locat2(5:6,index2(find(locat2(4,index2)==lay)));
                    if size(l1,2)>=2 && size(l2,2)>=2
                        p1 = l1';
                        p2 = l2';
                        cols1=p1(:,2);
                        cols2=p2(:,2);
                        rws1=p1(:,1);
                        rws2=p2(:,1);
%                         showimage(im1,im2,p1,p2,visible);
%                         showmatch(im1,im2,2*i-1,addgen,oct,lay);
%                         showmatch2(im2,l2,2*i,addgen,oct,lay);
                        I1 = im1*255;
                        I2 = im2*255;
                        
                        [match,des1,des2]=rr_desmatch(I1,I2,cols1,cols2,rws1,rws2,cell1,cell2);
                        if ~isempty(match)
                            wholeMatch = [wholeMatch;match(:,1:2) match(:,5:6) match(:,7:8) match(:,11:12)];
                        end
                    elseif size(l1,2)==0 || size(l2,2)==0
                        continue;
                    elseif locat1(5:6,index1(find(locat1(4,index1)==lay))) == locat2(5:6,index2(find(locat2(4,index2)==lay)))
%                         当前layer分别只有一个对应点时，这对点在一个cell内即认为可以对应
                        xy1 = locat1(1:2,index1(find(locat1(4,index1)==lay)));
                        xy2 = locat2(1:2,index2(find(locat2(4,index2)==lay)));
                        wholeMatch = [wholeMatch ;[ xy1' cell1' xy2' cell2']];
                    end
                    
                end
            end
            % 整体进行点对匹配
%                 im1 = im2double(im1);
%                 im2 = im2double(im2);
%                 if size(im1,3)>1
%                     im1=im1(:,:,2);
%                 end
%                 if size(im2,3)>1
%                     im2=im2(:,:,2);
%                 end
%                 l1 = round(locat1(1:2,:));
%                 l2 = round(locat2(1:2,:));
%                 cell1 = locat1(5:6,:);
%                 cell2 = locat2(5:6,:);
%                 p1 = l1';
%                 p2 = l2';
%                 cols1=p1(:,2);
%                 cols2=p2(:,2);
%                 rws1=p1(:,1);
%                 rws2=p2(:,1);
%                 show corner points
%                 showimage(im1,im2,p1,p2,visible);
%                 I1 = im1*255;
%                 I2 = im2*255;
%                 [match,des1,des2]=rr_desmatch(I1,I2,cols1,cols2,rws1,rws2,cell1,cell2);
%                 wholeMatch = [wholeMatch;match];
            
            %%
            % internet 第10幅图处理不好 第16幅图基本找不到初始匹配点
            locori1 = wholeMatch(:,1:2);
            locori2 = wholeMatch(:,5:6);
            showmatch(im1,im2,locori1,locori2,0);
            [tempMatch,wholeMatch2] = proProcessMatch(wholeMatch);
            oct = max(locat1(3,:));
            lay = max(locat1(4,:));
            if size(wholeMatch2,1) >= 7
                loc1 = wholeMatch2(:,1:4);
                loc2 = wholeMatch2(:,5:8);
                % temploc1 = tempMatch(:,1:4);
                % temploc2 = tempMatch(:,5:8);
                % showmatch(im1,im2,temploc1,temploc2,0);
                showmatch(im1,im2,loc1,loc2,0);
            else
                loc1 = wholeMatch(:,1:4);
                loc2 = wholeMatch(:,5:8);
            end
            
            locatMis1 = loc1(:,1:2);
            locatMis2 = loc2(:,1:2);
            conte = size(loc1,1);
%             xlswrite([addgen 'misCorrMatr_contSca_proProceMat.xls']...
%                 ,[locatMis1 locatMis2 repmat([oct lay],size(locatMis1,1),1)],['A' num2str(preconte+2) ':F' num2str(preconte+1+conte)]);
            preconte = preconte+conte+2;
            clear wholeMatch wholeMatch2
        end
    case 'RMSE'
        preconte = 1;
        for i = 1:imageNum
            
            clc;
            close all;
            
            image1 = [addgen num2str(2*i-1) '.jpg'];
            %     image1 = [addgen num2str(i) '.bmp'];
            
            format1 = 'colored';
            image2 = [addgen num2str(2*i) '.jpg'];
            %     image2 = [addgen num2str(i) 's.bmp'];
            format2 = 'colored';
            
            % get_msk(image1,2*i-1);
            % get_msk(image2,2*i);
            [locat1,size1,im1] = ursift(image1,format1,imageScale,opinion,visible);
            % % locat1 = locat1./max(size1);
            % % figure;plot(locat1(2,:),locat1(1,:),'bo');
            %
            [locat2,size2,im2] = ursift(image2,format2,imageScale,opinion,visible);
            %                 save info locat1 locat2 im1 im2
            %     load info
            % locat2 = locat2./max(size2);
            %% 整体进行点对匹配
            im1 = im2double(im1);
            im2 = im2double(im2);
            if size(im1,3)>1
                im1=im1(:,:,2);
            end
            if size(im2,3)>1
                im2=im2(:,:,2);
            end
            l1 = round(locat1(1:2,:));
            l2 = round(locat2(1:2,:));
            p1 = l1';
            p2 = l2';
            cols1=p1(:,2);
            cols2=p2(:,2);
            rws1=p1(:,1);
            rws2=p2(:,1);
            % show corner points
            showimage(im1,im2,p1,p2,visible);
            I1 = im1*255;
            I2 = im2*255;
            [match,des1,des2]=rr_desmatch(I1,I2,cols1,cols2,rws1,rws2);
            wholeMatch = [wholeMatch;match];
            locatMis1 = loc1(:,1:2);
            locatMis2 = loc2(:,1:2);
            conte = size(loc1,1);
            xlswrite([addgen 'misCorrMatr_contSca.xls']...
                ,[locatMis1 locatMis2 repmat([oct lay],size(locatMis1,1),1)],['A' num2str(preconte+2) ':F' num2str(preconte+1+conte)]);
            preconte = preconte+conte+2;
            clear wholeMatch wholeMatch2
        end
end
end
