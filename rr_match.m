% Auther: Jian Chen
% April 2008
% Department of Biomedical imaging, Columbia University, New York, USA
% Institute of Automation, Chinese Academy of Sciences, Beijing, China
% email: jc3129@columbia.edu,  jian.chen@ia.ac.cn
% All rights reserved


function [allmatches,desc1,desc2] = rr_match(des1, loc1,des2, loc2, distRatio)

% For each descriptor in the first image, select its match to second image.
% 从点集1正向匹配
des2t = des2';                          % Precompute matrix transpose
for i = 1 : size(des1,1)
    dotprods = des1(i,:) * des2t;        % Computes vector of dot products
    [vals,indx] = sort(acos(dotprods));  % Take inverse cosine and sort results
    
    % Check if nearest neighbor has angle less than distRatio times 2nd.
    if (vals(1) < distRatio * vals(2))
        % 当最小值小于第二小值的disstRatio倍时 认为2者匹配，并记录对应点集2中该点的索引存入match（i)中
        match(i) = indx(1);
    else
        match(i) = 0;
    end
end

%%%%%%%%%%%%%%%%%%%%
% 从点集2反向匹配
des1t = des1';
for i = 1 : size(des2,1)
    dotprods = des2(i,:) * des1t;
    [vals,indx] = sort(acos(dotprods));
    if (vals(1) < distRatio * vals(2))
        % 当最小值小于第二小值的disstRatio倍时 认为2者匹配，并记录对应点集1中该点的索引存入match1（i)中
        match1(i) = indx(1);
    else
        match1(i) = 0;
    end
end

for i = 1 : size(des1,1)
    if match(i)>0
        % 双向匹配中正向对应点对应的点非该点时去掉
        if match1(match(i))~=i
            match(i)=0;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%
allmatches = [];
desc1=[];
desc2=[];
j=0;
for i = 1 : size(des1,1)
    if match(i)>0
        j=j+1;
        allmatches = [allmatches; [loc1(i,:),loc2(match(i),:)]];
        desc1(j,:) = des1(i,:);
        desc2(j,:) = des2(match(i),:);
        
        
        %             disp(['des1 ' num2str(des1(i,:)) ]);
        %              disp([   'des2 ' num2str(des2(i,:)) ]);
    end
end
