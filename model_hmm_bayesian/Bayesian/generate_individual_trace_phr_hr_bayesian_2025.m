
load('D:\GRIN2A_data_code\data for figures\Data_final.mat')
addpath('D:\paper_code_20250317\model_hmm_bayesian')
%%
load('D:\paper_code_20250317\model_hmm_bayesian\Bayesian\2025results\best_fitting_individual_animal_hr_025.mat');
%load('D:\paper_code_20250317\model_hmm_bayesian\Bayesian\generate_phr_for_grid_search\phr_large_mean_combine.mat')
load('D:\paper_code_20250317\model_hmm_bayesian\Bayesian\generate_phr_for_grid_search\PHR_grin_search_coarse_exp_alphamore250330.mat', 'alphalist','noisyfactorhrlist','hr_std0list','lr_stdlist');
hr_std0list=0.025:0.025:0.7;



%%

%%%%%%%%%% chenage here

original_data1=WT_sub;
original_data2=grin2a_sub;

bestparameter1=WT_ind_bestparameters;
bestparameter2=grin2a_ind_bestparameters;

%%

for ani=1:size(bestparameter1,1)
 
    nblock=200;

    alpha=bestparameter1(ani,1);
    noisf=bestparameter1(ani,2);
    hrstd=bestparameter1(ani,3);
    lrstd=bestparameter1(ani,4);
    hr_m0=1;
    [actions,pressn,state]=generate_simulate(alpha,noisf,hr_m0,hrstd,lrstd,nblock);
    Actions{ani}=actions;
    Pressns{ani}=pressn;
    States{ani}=state;
    
end

for ani=1:size(bestparameter2,1)
 
    nblock=200;
    alpha=bestparameter2(ani,1);
    noisf=bestparameter2(ani,2);
    hrstd=bestparameter2(ani,3);
    lrstd=bestparameter2(ani,4);
    hr_m0=1;
    [actions,pressn,state]=generate_simulate(alpha,noisf,hr_m0,hrstd,lrstd,nblock);
    ActionsHET{ani}=actions;
    PressnsHET{ani}=pressn;
    StatesHET{ani}=state;
   
    
end

%%
for ani=1:size(bestparameter1,1)
    PHRratio{ani}=get_phr_ratio_generated(Actions{ani},Pressns{ani});
end

for ani=1:size(bestparameter2,1)
    PHRratioHET{ani}=get_phr_ratio_generated(ActionsHET{ani},PressnsHET{ani});
end


%save('phr_hr_generated_from_bayesian_ind.mat')

%%
fw=fieldnames(original_data1)
for fi=1:length(fw)
    mat_block=original_data1.(fw{fi});
    [PHRratioRE{fi}]=get_phr_ratio_original(mat_block)
end

fg=fieldnames(original_data2)
for fi=1:length(fg)
    mat_block=original_data2.(fg{fi});
    [PHRratioREHET{fi}]=get_phr_ratio_original(mat_block)
end
%%
%get r^2
%load('phr_hr_generated_from_bayesian_ind_plus_real.mat')
figure()
Rsquare_WT=zeros(numel(PHRratio),1);
for si=1:numel(PHRratio)
    subplot(4,6,si)
    x=mean(PHRratioRE{si});
    y=mean(PHRratio{si});
    
    x=remove_zeros_at_end(x);
    y=remove_zeros_at_end(y);
    
    if length(x)>length(y)
        y=[y,zeros(1,(length(x)-length(y)))];
    else if length(y)>length(x)
            x=[x,zeros(1,(length(y)-length(x)))];
        end
    end
        
    scatter(x,y,15,"filled");
    hold on;
    plot([0,1],[0,1],'k-')
    
    predy=x;
    
    rsquare=get_resquare(y, predy);
    
    text(0.8,0.2,num2str(rsquare));
    
    Rsquare_WT(si)=rsquare;
    title(fw{si})
    xlabel('P(HR) animal');
    ylabel('P(HR) model');

end

%%
%get r^2
%load('phr_hr_generated_from_bayesian_ind_plus_real.mat')
figure()
Rsquare_HET=zeros(numel(PHRratioHET),1);
for si=1:numel(PHRratioHET)
    subplot(4,6,si)
    x=mean(PHRratioREHET{si});
    y=mean(PHRratioHET{si});
    
    x=remove_zeros_at_end(x);
    y=remove_zeros_at_end(y);
    
    if length(x)>length(y)
        y=[y,zeros(1,(length(x)-length(y)))];
    else if length(y)>length(x)
            x=[x,zeros(1,(length(y)-length(x)))];
        end
    end
        
    scatter(x,y,15,"filled");
    hold on;
    plot([0,1],[0,1],'k-')
    
    predy=x;
    
    rsquare=get_resquare(y, predy);
    
    text(0.8,0.2,num2str(rsquare));
    
    Rsquare_HET(si)=rsquare;
    title(fg{si})
    xlabel('P(HR) animal');
    ylabel('P(HR) model');

end
%%
figure()
for si=1:numel(PHRratio)
    subplot(4,6,si)
    h1=shadedErrorBar(1:1:size(PHRratioRE{si},2),median(smoothdata(PHRratioRE{si},'gaussian',2),'omitnan'),std(PHRratioRE{si},[],'omitnan')/sqrt(size(PHRratioRE{si},1)),'lineprop','k');
    hold on;
    h2=shadedErrorBar(1:1:size(PHRratio{si},2),median(smoothdata(PHRratio{si},'gaussian',2),'omitnan'),std(PHRratio{si},[],'omitnan')/sqrt(size(PHRratio{si},1)),'lineprop','m');

    xlim([0 40]);
    ylim([0 1]);
    %alpha(0.7)
    xlabel('HR request')
    ylabel('Prob. (HR choice)')
    title(fw{si})

    legend([h1.mainLine,h2.mainLine],{'real wt','model wt'});
    legend('boxoff');
end

%%
figure()
for si=1:numel(PHRratioHET)
    subplot(4,6,si)
    h1=shadedErrorBar(1:1:size(PHRratioREHET{si},2),median(smoothdata(PHRratioREHET{si},'gaussian',2),'omitnan'),std(PHRratioREHET{si},[],'omitnan')/sqrt(size(PHRratioREHET{si},1)),'lineprop','k');
    hold on;
    h2=shadedErrorBar(1:1:size(PHRratioHET{si},2),median(smoothdata(PHRratioHET{si},'gaussian',2),'omitnan'),std(PHRratioHET{si},[],'omitnan')/sqrt(size(PHRratioHET{si},1)),'lineprop','m');

    xlim([0 40]);
    ylim([0 1]);
    %alpha(0.7)
    xlabel('HR request')
    ylabel('Prob. (HR choice)')
    title(fg{si})

    legend([h1.mainLine,h2.mainLine],{'real het','model het'});
    legend('boxoff');
end

%%



%%

function [newx]=remove_zeros_at_end(x)
    
    newx=x;
    while ~isempty(newx)
        
        if newx(length(newx))==0
            newx=newx(1:length(newx)-1)
        else
            break
        end
        
    end

end

%%
function [rsquare]=get_resquare(y, predy)

    %RMSE=sqrt(mean((y-predy).^2));
    %SSX=sum((predy-mean(predy)).^2);
    %SSY=sum((y-mean(y)).^2);
    %SS_XY=sum((predy-mean(predy)).*(y-mean(y)));
    %rsquare=SS_XY/sqrt(SSX*SSY);

    ssres=sum((y-predy).^2);
    sstot=sum((y-mean(y)).^2);
    rsquare=1-(ssres/sstot);

end

%%
function  [PHRratioRE]=get_phr_ratio_original(mat_block)
%%remove non cont1
for blocki=1:length(mat_block)
  if isempty(find(mat_block{blocki}.PressGoals==2,1,'first'))
      mat_blockk{blocki}=[];
  end
end

mat_block=mat_block(~cellfun('isempty',mat_block));

%%


for blocki=1:length(mat_block)
  
    if isfield(mat_block{blocki},'blockOnset')
        if mat_block{blocki}.blockOnset>0
            actionsRE{blocki}=mat_block{blocki}.HRreward(mat_block{blocki}.blockOnset:end)>0;
            pressnRE{blocki}=mat_block{blocki}.HRpress(mat_block{blocki}.blockOnset:end);
        elseif mat_block{blocki}.blockOnset==0
            blockonset=find(mat_block{blocki}.HRreward(1:find(mat_block{blocki}.HRpress==2)-4)>0,1,'last');
            actionsRE{blocki}=mat_block{blocki}.HRreward(blockonset:end)>0;
            pressnRE{blocki}=mat_block{blocki}.HRpress(blockonset:end);

        end
    else
        
            blockonset=find(mat_block{blocki}.HRreward(1:find(mat_block{blocki}.HRpress==2)-4)>0,1,'last');
            actionsRE{blocki}=mat_block{blocki}.HRreward(blockonset:end)>0;
            pressnRE{blocki}=mat_block{blocki}.HRpress(blockonset:end);
    end
        
end

actionsRE=actionsRE(~cellfun('isempty',actionsRE));
pressnRE=pressnRE(~cellfun('isempty',pressnRE));


PHRratioRE=nan(length(actionsRE),100);

for blocki=1:length(actionsRE)
    if ~isempty(actionsRE{blocki})
        [~,~,Block_slopetypehr_lr_ratio] = get_hr_press_prob_behavior(actionsRE{blocki},pressnRE{blocki});
        PHRratioRE(blocki,1:length(Block_slopetypehr_lr_ratio))=Block_slopetypehr_lr_ratio;
        clearvars Block_slopetypehr_lr_ratio
    end
end

PHRratioRE=PHRratioRE(:,sum(isnan(PHRratioRE))<size(PHRratioRE,1));

PHRratioRE=PHRratioRE(isnan(PHRratioRE(:,1))==0,:);

PHRratioRE=PHRratioRE(PHRratioRE(:,1)==1,:);

for i=1:size(PHRratioRE,1)
   PHRratioRE(i,isnan(PHRratioRE(i,:)))=0; 

end

end


function [PHRratio]=get_phr_ratio_generated(actions,pressn)

    for blocki=1:length(actions)

            blockonset=find(actions{blocki}(1:find(pressn{blocki}==2)-4)>0,1,'last');
            actions{blocki}=actions{blocki}(blockonset:end);
            pressn{blocki}=pressn{blocki}(blockonset:end);

    end


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

end