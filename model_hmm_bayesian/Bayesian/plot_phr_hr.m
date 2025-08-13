function [h2] = plot_phr_hr(mat_block)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    %%

        addpath 'D:\paper_code_20250317\model_hmm_bayesian'     
        for blocki=1:length(mat_block)
            
            %20250405 remove trials where hr.reward=0 but hr.
            
            unfinishtrial=(mat_block{blocki}.LRchoice==0)&(mat_block{blocki}.HRreward==0);
            filterunfinishtrial=~unfinishtrial;
            
            if sum(strcmp(fieldnames(mat_block{blocki}),'blockOnset'))>0
                if mat_block{blocki}.blockOnset>0
                    blockonset=mat_block{blocki}.blockOnset;
                    %actions{blocki}=mat_block{blocki}.HRreward(blockonset:end)>0;
                    %pressn{blocki}=mat_block{blocki}.HRpress(blockonset:end).*actions{blocki};
                elseif mat_block{blocki}.blockOnset==0
                    blockonset=find(mat_block{blocki}.HRreward(1:find(mat_block{blocki}.HRpress==2)-4)>0,1,'last');
                    %actions{blocki}=mat_block{blocki}.HRreward(blockonset:end)>0;
                    %pressn{blocki}=mat_block{blocki}.HRpress(blockonset:end).*actions{blocki};

                end
            else
                blockonset=find(mat_block{blocki}.HRreward(1:find(mat_block{blocki}.HRpress==2)-4)>0,1,'last');
                %actions{blocki}=mat_block{blocki}.HRreward(blockonset:end)>0;
                %pressn{blocki}=mat_block{blocki}.HRpress(blockonset:end).*actions{blocki};
            end
            
            blockonset_to_end=ones(length(mat_block{blocki}.HRreward),1);
            blockonset_to_end(1:blockonset-1)=0;
            
            
            %trialtokeep=blockonset_to_end.*filterunfinishtrial;
            trialtokeep=blockonset_to_end;
            
            action_b=(mat_block{blocki}.HRreward);
            pressn_b=(mat_block{blocki}.HRpress);
            action_b=action_b(trialtokeep>0);
            pressn_b=pressn_b(trialtokeep>0);
            
            actions{blocki}=action_b>0;
            pressn{blocki}=pressn_b;

           
        end
        
        actions=actions(~cellfun('isempty',actions));
        pressn=pressn(~cellfun('isempty',pressn));
        
        
        

    PHRratio=nan(length(actions),100);

    for blocki=1:length(actions)
        if ~isempty(actions{blocki})
            [~,~,Block_slopetypehr_lr_ratio] = get_hr_press_prob_behavior(actions{blocki},pressn{blocki});
            PHRratio(blocki,1:length(Block_slopetypehr_lr_ratio))=Block_slopetypehr_lr_ratio;
            clearvars Block_slopetypehr_lr_ratio
        end
    end

    PHRratio=PHRratio(:,sum(isnan(PHRratio))<size(PHRratio,1));

    PHRratio=PHRratio(isnan(PHRratio(:,1))==0,:);

    PHRratio=PHRratio(PHRratio(:,1)==1,:);

    %change PHRratio NaN to zero

    for i=1:size(PHRratio,1)
       PHRratio(i,isnan(PHRratio(i,:)))=0; 

    end
    
    h2=shadedErrorBar(1:1:size(PHRratio,2),median(smoothdata(PHRratio,'gaussian',2),'omitnan'),std(PHRratio,[],'omitnan')/sqrt(size(PHRratio,1)),'lineprop','m');

    xlim([0 40]);
    ylim([0 1]);
    alpha(0.7)
    xlabel('HR request')
    ylabel('Prob. (HR choice)')

    legend([h2.mainLine],{'real wt'});
    legend('boxoff');

    %saveas(gcf,strcat('fig_generated_data_wt','.fig'));
    %close all

    save(strcat('generated_data_wt20240707','.mat'));
end