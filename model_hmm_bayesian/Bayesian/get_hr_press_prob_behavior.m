function [Block_slopetypehr,Block_slopetypelr,Block_slopetypehr_lr_ratio] = get_hr_press_prob_behavior(actions,pressnumbers)
%UNTITLED3 Summary of this function goes here
%   work for 1 block
%20211224: remove NaN at the end of Block_slopetypehr_lr_ratio
%20220622: change remove NaN code

Block_slopetypehr=zeros(1,max(pressnumbers));
Block_slopetypelr=zeros(1,max(pressnumbers));


hrrequest=1;
    for j=1:length(actions)        
        if actions(j)==1
            hrrequest=pressnumbers(j);
            Block_slopetypehr(1,hrrequest)=Block_slopetypehr(1,hrrequest)+1;
        else
            Block_slopetypelr(1,hrrequest)=Block_slopetypelr(1,hrrequest)+1;
        end
        
     
    end

%%
Block_slopetypehr_lr_ratio=zeros(1,max(pressnumbers));


    for j=1:size(Block_slopetypehr,2)
        if (Block_slopetypehr(1,j)~=0) || (Block_slopetypelr(1,j)~=0)
            Block_slopetypehr_lr_ratio(1,j)=Block_slopetypehr(1,j)/(Block_slopetypehr(1,j)+Block_slopetypelr(1,j));
%         else
%             if (Block_slopetypehr(i,j)==0) && (Block_slopetypelr(i,j)==0)
%                 Block_slopetypehr_lr_ratio(i,j)=NaN;
%             end
        end
    end

Block_slopetypehr_lr_ratio(:,sum(Block_slopetypehr_lr_ratio,1)==0)=NaN;

%remove NaN at the end 
% while sum(isnan(Block_slopetypehr_lr_ratio(:,end)))==length(Block_slopetypehr_lr_ratio(:,end))
%     Block_slopetypehr_lr_ratio=Block_slopetypehr_lr_ratio(:,1:end-1);
% end


while isnan(Block_slopetypehr_lr_ratio(:,end))==1 %change20220622
    %Block_slopetypehr_lr_ratio=Block_slopetypehr_lr_ratio(:,1:end-1);
    Block_slopetypehr_lr_ratio(end)=[];
    if length(Block_slopetypehr_lr_ratio)==0
        break
    end
end

%plot(mean(Block_slopetypehr_lr_ratio(Block_slopetypehr_lr_ratio(:,1)==1,:),'omitnan'));
end

