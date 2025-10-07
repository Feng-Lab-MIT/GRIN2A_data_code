load('D:\GRIN2A_data_code\model_hmm_bayesian\Bayesian\2025results\best_fitting_individual_animal_hr_025.mat')

%load('C:\Users\admin\MIT Dropbox\Tingting Zhou\CareerDevelopment\Grin2aManuscript\submit to science\data for figures\Data_final.mat')
load('D:\GRIN2A_data_code\data for figures\Data_final.mat')
%SSFO_ON_sub=structure_data_into_animalID(SSFO_ON);
%SSFO_OFF_sub=structure_data_into_animalID(SSFO_OFF);
%MD_ON_sub=structure_data_into_animalID(MD_ON);
%MD_OFF_sub=structure_data_into_animalID(MD_OFF);
WT_sub=structure_data_into_animalID(WT);
grin2a_sub=structure_data_into_animalID(grin2a);

%%
addpath('D:\paper_code_20250317\model_hmm_bayesian\HMM')

data=[WT_ind_bestparameters];
F=fieldnames(WT_sub);
       
overlap_hr_lr_all_WT=[];

for i=1:size(data,1)
    
    [~,overlap_hr_lr_all_mean]=get_hr_lr_overlap_over_hr(data(i,1),data(i,2),data(i,3),data(i,4));
    overlap_hr_lr_all_WT(i,:)=overlap_hr_lr_all_mean;
    
    mat_block=WT_sub.(F{i});
    [overlap_per_trial,blockonset,actions, pressn]=get_overlaparea_per_trial(mat_block,overlap_hr_lr_all_mean);
    
    [hrrequest_per_trial]=get_hr_request_from_actions_n_pressn(actions, pressn);

    [~,~,~,PSTATES,~,~,~,~,~,~,~]=gethmmstate(mat_block,0.8);
    
    for blocki=1:length(PSTATES)
        y=PSTATES{blocki}(2,blockonset{blocki}:end);
        %x=overlap_per_trial{blocki};
        %%scatter(x,y',15,"filled");
        %%hold on
        %RsquareWT{i}(blocki)=get_r_square(x,y'); 
        Exploration_prob_WT{i}{blocki}=y;
    end
    
    [exploration_prob_per_hrrequest]=get_exploration_prob_per_hr_request(Exploration_prob_WT{i}, hrrequest_per_trial)
        
    %RsquareWT_mean(i)=mean(RsquareWT{i});
    overlap_per_trial_WT{i}=overlap_per_trial;
    blockonset_WT{i}=blockonset;
    Exploration_prob_per_hr_WT{i}=exploration_prob_per_hrrequest;
    Exploration_prob_per_hr_WT{i}(isnan(Exploration_prob_per_hr_WT{i}))=0;
    
end

%%
data=[grin2a_ind_bestparameters];
F=fieldnames(grin2a_sub);

overlap_hr_lr_all_grin2a=[];

for i=1:size(data,1)
    
    [~,overlap_hr_lr_all_mean]=get_hr_lr_overlap_over_hr(data(i,1),data(i,2),data(i,3),data(i,4));
    overlap_hr_lr_all_grin2a(i,:)=overlap_hr_lr_all_mean;
    
    mat_block=grin2a_sub.(F{i});
    [overlap_per_trial,blockonset,actions,pressn]=get_overlaparea_per_trial(mat_block,overlap_hr_lr_all_mean)
    
    [hrrequest_per_trial]=get_hr_request_from_actions_n_pressn(actions, pressn);
    
    [~,~,~,PSTATES,~,~,~,~,~,~,~]=gethmmstate(mat_block,0.8);
    
    %figure()
    for blocki=1:length(PSTATES)
        y=PSTATES{blocki}(2,blockonset{blocki}:end);
        %x=overlap_per_trial{blocki};
        %%scatter(x,y',15,"filled");
        %%hold on
        %RsquareGrin{i}(blocki)=get_r_square(x,y');
        Exploration_prob_grin2a{i}{blocki}=y;
    end
    
    [exploration_prob_per_hrrequest]=get_exploration_prob_per_hr_request(Exploration_prob_grin2a{i}, hrrequest_per_trial)
    
    %RsquareGrin_mean(i)=mean(RsquareGrin{i});
    overlap_per_trial_grin2a{i}=overlap_per_trial;
    blockonset_grin2a{i}=blockonset;
    Exploration_prob_per_hr_grin2a{i}=exploration_prob_per_hrrequest;
    Exploration_prob_per_hr_grin2a{i}(isnan(Exploration_prob_per_hr_grin2a{i}))=0;
    
end

%%
%plot scatter
figure()

fw=fieldnames(WT_sub);

Rsquare_WT=zeros(numel(Exploration_prob_per_hr_WT),1);
for si=1:numel(Exploration_prob_per_hr_WT)
    subplot(4,6,si)
    x=overlap_hr_lr_all_WT(si,4:end); %overlap start from hr=1,1,1,1,2,3,....
    y=mean(Exploration_prob_per_hr_WT{si}(:,1:70));
  
       
    scatter(x,y,15,"filled");
    hold on;
    plot([0,1],[0,1],'k-')
    
    rsquare=get_r_square(x,y);
    
    predy=x;
        
    text(0.8,0.2,num2str(rsquare));
    
    Rsquare_WT(si)=rsquare;
    title(fw{si})
    xlabel('overlap area');
    ylabel('P(exploration)');

end

%%
figure()

fg=fieldnames(grin2a_sub);

Rsquare_gr=zeros(numel(Exploration_prob_per_hr_grin2a),1);
for si=1:numel(Exploration_prob_per_hr_grin2a)
    subplot(4,6,si)
    x=overlap_hr_lr_all_grin2a(si,4:end) %overlap start from hr=1,1,1,1,2,3,....
    y=mean(Exploration_prob_per_hr_grin2a{si}(:,1:70))
  
       
    scatter(x,y,15,"filled");
    hold on;
    plot([0,1],[0,1],'k-')
    
    rsquare=get_r_square(x,y);
    
    predy=x;
        
    text(0.8,0.2,num2str(rsquare));
    
    Rsquare_gr(si)=rsquare;
    title(fg{si})
    
    xlabel('overlap area');
    ylabel('P(exploration)');

end

%%
%plot curve
figure()
for si=1:numel(Exploration_prob_per_hr_WT)
    subplot(4,6,si)
    yyaxis left
    h1=plot(1:1:70,overlap_hr_lr_all_WT(si,4:end));
    hold on;
    xlabel('HR request')
    ylabel('Ambiguity')
    ylim([0 0.8])
    
    yyaxis right
    shadedErrorBar_yyaxis(1:1:70,mean(Exploration_prob_per_hr_WT{si}(:,1:70)),std(Exploration_prob_per_hr_WT{si}(:,1:70),[],'omitnan')/sqrt(size(Exploration_prob_per_hr_WT{si},1)),'lineprop','m');
    xlim([0 70]);
    ylim([0 0.8])
    ylabel('Prob. (Exploration)')
    title(fw{si})

    legend('off');
end

%%
figure()
for si=1:numel(Exploration_prob_per_hr_grin2a)
    subplot(4,6,si)
    yyaxis left
    h1=plot(1:1:70,overlap_hr_lr_all_grin2a(si,4:end));
    hold on;
    xlabel('HR request')
    ylabel('Ambiguity')
    ylim([0 0.8])
    
    yyaxis right
    shadedErrorBar_yyaxis(1:1:70,mean(Exploration_prob_per_hr_grin2a{si}(:,1:70)),std(Exploration_prob_per_hr_grin2a{si}(:,1:70),[],'omitnan')/sqrt(size(Exploration_prob_per_hr_grin2a{si},1)),'lineprop','m');
    xlim([0 70]);
    ylim([0 0.8])
    ylabel('Prob. (Exploration)')
    title(fg{si})

    legend('off');
end

%%
function [exploration_prob_per_hrrequest]=get_exploration_prob_per_hr_request(exploration_prob_WT_per_ani, hrrequest_per_trial)
    
    exploration_prob_per_hrrequest=zeros(length(hrrequest_per_trial),100); %blcok n x hrrequest
    
    for blocki=1:length(hrrequest_per_trial) %block #
        
        for hrrequest=1:100
            exploration_prob_per_hrrequest(blocki,hrrequest)=mean(exploration_prob_WT_per_ani{blocki}(hrrequest_per_trial{blocki}==hrrequest));
            
        end
        
    end

end

%%
function [hrrequest_per_trial]=get_hr_request_from_actions_n_pressn(actions, pressn)

   for block=1:length(actions)
        hrrequest_per_trial{block}=zeros(length(actions{block}),1);

        hrrequest_prior=1;
        for trial=1:length(actions{block}) 

            if actions{block}(trial)>0                    
                hrrequest_per_trial{block}(trial)=pressn{block}(trial);
                hrrequest_prior=hrrequest_per_trial{block}(trial);
            else
                hrrequest_per_trial{block}(trial)=hrrequest_prior;

            end
        end
    end

end


%%
function [overlap_per_trial,blockonset, actions, pressn]=get_overlaparea_per_trial(mat_block,overlap_hr_lr_all_mean)

    for blocki=1:length(mat_block)
        if sum(strcmp(fieldnames(mat_block{blocki}),'blockOnset'))>0
            if mat_block{blocki}.blockOnset>0
                blockonset{blocki}=mat_block{blocki}.blockOnset;
                actions{blocki}=mat_block{blocki}.HRreward(mat_block{blocki}.blockOnset:end)>0;
                pressn{blocki}=mat_block{blocki}.HRpress(mat_block{blocki}.blockOnset:end);
            elseif mat_block{blocki}.blockOnset==0
                blockonset{blocki}=find(mat_block{blocki}.HRreward(1:find(mat_block{blocki}.HRpress==2)-4)>0,1,'last');
                actions{blocki}=mat_block{blocki}.HRreward(blockonset{blocki}:end)>0;
                pressn{blocki}=mat_block{blocki}.HRpress(blockonset{blocki}:end);

            end
        else
            blockonset{blocki}=find(mat_block{blocki}.HRreward(1:find(mat_block{blocki}.HRpress==2)-4)>0,1,'last');
            actions{blocki}=mat_block{blocki}.HRreward(blockonset{blocki}:end)>0;
            pressn{blocki}=mat_block{blocki}.HRpress(blockonset{blocki}:end);
        end
    end

    for block=1:length(actions)

        overlap_per_trial{block}=zeros(length(actions{block}),1);

        numberofhr1s=1;
        overlap_per_trial_prior=overlap_hr_lr_all_mean(1);
        for trial=1:length(actions{block}) %number of trials

            %determine inertia term based on pressn


            if actions{block}(trial)>0
                if pressn{block}(trial)==1
                    
                    overlap_per_trial{block}(trial)=overlap_hr_lr_all_mean(min([numberofhr1s,4]),1);
                    overlap_per_trial_prior=overlap_per_trial{block}(trial);
                    numberofhr1s=numberofhr1s+1;
                else
                    
                    overlap_per_trial{block}(trial)=overlap_hr_lr_all_mean(pressn{block}(trial)+3);
                    overlap_per_trial_prior=overlap_per_trial{block}(trial);
                end

            else
                overlap_per_trial{block}(trial)=overlap_per_trial_prior;

            end
            %fprintf('Trial %d\n',trial);

        end
        overlap_per_trial_prior=[];
        

    end

end
    
%%
%get r^2
%load('phr_hr_generated_from_bayesian_ind_plus_real.mat')

function [rsquare]=get_r_square(x,y)

    %subplot(4,6,si)    
    %if length(x)>length(y)
    %    y=[y,zeros(1,(length(x)-length(y)))];
    %else if length(y)>length(x)
    %        x=[x,zeros(1,(length(y)-length(x)))];
    %    end
    %end
        
    %scatter(x,y,15,"filled");
    %hold on;
    %plot([0,1],[0,1],'k-')
    
    predy=x;
    
    RMSE=sqrt(mean((y-predy).^2));
    SSX=sum((predy-mean(predy)).^2);
    SSY=sum((y-mean(y)).^2);
    SS_XY=sum((predy-mean(predy)).*(y-mean(y)));
    rsquare=SS_XY/sqrt(SSX*SSY);
    
    %text(0.8,0.2,num2str(rsquare));
    
    %title(fw{si})
    %xlabel('P(HR) animal');
    %ylabel('P(HR) model');

end