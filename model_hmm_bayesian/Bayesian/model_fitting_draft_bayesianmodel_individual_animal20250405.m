%20220406: starting from block start, use sum instead of mean, take out
%il_m
%20220623: add il_m back
%20220628: add inertia thres
%20220705 discrete threshold
%20221207 remove inertia term
%20221223: change HR(t=0) to 1
%20230110: try higher HR noisy factor
%20230327: try new range of hr noise

%load('\\fenglab03\yiyun\20240615 new model for revision\behaviordata20241027','grin2a_sub');
%load('\\fenglab03\yiyun\20240615 new model for revision\behaviordata20241027.mat','SSFO_ON_sub');
%load('\\fenglab03\yiyun\20241221 manuscript_code_upload\model_hmm_bayesian\behaviordata20241027.mat','SSFO_ON_sub');
%load('C:\Users\admin\MIT Dropbox\Tingting Zhou\CareerDevelopment\Grin2aManuscript\submit to science\data for figures\Data_final.mat')
load('D:\GRIN2A_data_code\data for figures\Data_final.mat')

%%
load('D:\paper_code_20250317\model_hmm_bayesian\Bayesian\generate_phr_for_grid_search\phr_large_mean_combine.mat')
%PHR_Large_mean_combined=PHR_Large_mean(:,:,1:4,:,:,:);

load('D:\paper_code_20250317\model_hmm_bayesian\Bayesian\generate_phr_for_grid_search\PHR_grin_search_coarse_exp_alphamore250330backup.mat', 'alphalist','noisyfactorhrlist','hr_std0list','lr_stdlist');
hr_std0list=0.025:0.025:0.7;

%%
SSFO_ON_sub=structure_data_into_animalID(SSFO_ON);
SSFO_OFF_sub=structure_data_into_animalID(SSFO_OFF);
MD_ON_sub=structure_data_into_animalID(MD_ON);
MD_OFF_sub=structure_data_into_animalID(MD_OFF);
WT_sub=structure_data_into_animalID(WT);
grin2a_sub=structure_data_into_animalID(grin2a);

SSFO_ON_all.SSFO_ON=SSFO_ON;
SSFO_OFF_all.SSFO_OFF=SSFO_OFF;
MD_ON_all.MF_ON=MD_ON;
MD_OFF_all.MD_OFF=MD_OFF;
WT_all.WT=WT;
grin2a_all.grin2a=grin2a;



[SSFO_ON_all_bestparameters,SSFO_ON_all_Likelihoodindanimal, SSFO_ON_all_NLL]=best_bayesian_parameters(SSFO_ON_all,phr_large_mean_combine,alphalist,noisyfactorhrlist,hr_std0list,lr_stdlist);
[SSFO_OFF_all_bestparameters,SSFO_OFF_all_Likelihoodindanimal, SSFO_OFF_all_NLL]=best_bayesian_parameters(SSFO_OFF_all,phr_large_mean_combine,alphalist,noisyfactorhrlist,hr_std0list,lr_stdlist);
[MD_ON_all_bestparameters,MD_ON_all_Likelihoodindanimal, MD_ON_all_NLL]=best_bayesian_parameters(MD_ON_all,phr_large_mean_combine,alphalist,noisyfactorhrlist,hr_std0list,lr_stdlist);
[MD_OFF_all_bestparameters,MD_OFF_all_Likelihoodindanimal,MD_OFF_all_NLL]=best_bayesian_parameters(MD_OFF_all,phr_large_mean_combine,alphalist,noisyfactorhrlist,hr_std0list,lr_stdlist);
[WT_all_bestparameters,WT_all_Likelihoodindanimal, WT_all_NLL]=best_bayesian_parameters(WT_all,phr_large_mean_combine,alphalist,noisyfactorhrlist,hr_std0list,lr_stdlist);
[grin2a_all_bestparameters,grin2a_all_Likelihoodindanimal, grin2a_all_NLL]=best_bayesian_parameters(grin2a_all,phr_large_mean_combine,alphalist,noisyfactorhrlist,hr_std0list,lr_stdlist);

[SSFO_ON_ind_bestparameters,SSFO_ON_ind_Likelihoodindanimal, SSFO_ON_ind_NLL]=best_bayesian_parameters(SSFO_ON_sub,phr_large_mean_combine,alphalist,noisyfactorhrlist,hr_std0list,lr_stdlist);
[SSFO_OFF_ind_bestparameters,SSFO_OFF_ind_Likelihoodindanimal, SSFO_OFF_ind_NLL]=best_bayesian_parameters(SSFO_OFF_sub,phr_large_mean_combine,alphalist,noisyfactorhrlist,hr_std0list,lr_stdlist);
[MD_ON_ind_bestparameters,MD_ON_ind_Likelihoodindanimal, MD_ON_ind_NLL]=best_bayesian_parameters(MD_ON_sub,phr_large_mean_combine,alphalist,noisyfactorhrlist,hr_std0list,lr_stdlist);
[MD_OFF_ind_bestparameters,MD_OFF_ind_Likelihoodindanimal, MD_OFF_ind_NLL]=best_bayesian_parameters(MD_OFF_sub,phr_large_mean_combine,alphalist,noisyfactorhrlist,hr_std0list,lr_stdlist);
[WT_ind_bestparameters,WT_ind_Likelihoodindanimal, WT_ind_NLL]=best_bayesian_parameters(WT_sub,phr_large_mean_combine,alphalist,noisyfactorhrlist,hr_std0list,lr_stdlist);
[grin2a_ind_bestparameters,grin2a_ind_Likelihoodindanimal, grin2a_ind_NLL]=best_bayesian_parameters(grin2a_sub,phr_large_mean_combine,alphalist,noisyfactorhrlist,hr_std0list,lr_stdlist);

function [bestparameters, Likelihoodindanimal, NLL_ind]=best_bayesian_parameters(sub_mat,PHR_Large_mean_combined,alphalist,noisyfactorhrlist,hr_std0list,lr_stdlist)

    %load("\\fenglab03\yiyun\20231027 lever pressing paper figure\Bayesian\20231101 bayesian model\phr_grid_search_combined_sub_v7_20231214.mat","PHR_Large_mean_combined");
    %load("\\fenglab03\yiyun\20241221 manuscript_code_upload\model_hmm_bayesian\Bayesian\phr_grid_search_combined_sub_v7_20231214.mat","PHR_Large_mean_combined");
    
    
    

    %load('/home/yiyunho/cont1_Yiyun.mat');

    %20220304 change back to starting not directly from blockstart

    %20220225 to do:
    %use only actions and pressn from block start!

    %20220225 to do:
    %use only actions and pressn from block start!

    %%
    F=fieldnames(sub_mat);
    bestparameters=zeros(length(F),4);
    Likelihoodindanimal=zeros(length(F),1);
    NLL_ind=zeros(length(F),1);

    for fin=1:length(F)

        mat_block=sub_mat.(F{fin});

        for blocki=1:length(mat_block)
            if sum(strcmp(fieldnames(mat_block{blocki}),'blockOnset'))>0
                if mat_block{blocki}.blockOnset>0
                    actions{blocki}=mat_block{blocki}.HRreward(mat_block{blocki}.blockOnset:end)>0;
                    pressn{blocki}=mat_block{blocki}.HRpress(mat_block{blocki}.blockOnset:end);
                elseif mat_block{blocki}.blockOnset==0
                    blockonset=find(mat_block{blocki}.HRreward(1:find(mat_block{blocki}.HRpress==2)-4)>0,1,'last');
                    actions{blocki}=mat_block{blocki}.HRreward(blockonset:end)>0;
                    pressn{blocki}=mat_block{blocki}.HRpress(blockonset:end);

                end
            else
                blockonset=find(mat_block{blocki}.HRreward(1:find(mat_block{blocki}.HRpress==2)-4)>0,1,'last');
                actions{blocki}=mat_block{blocki}.HRreward(blockonset:end)>0;
                pressn{blocki}=mat_block{blocki}.HRpress(blockonset:end);
            end
        end


        % Specify inputs to maxLikeFit:
        input=struct;
        input.pressn=pressn; %this is wrong, how to do with this???  << rewrite fitDelta to reset hr velo and value after each run
        input.actions=actions; 

        %%

        NLL=zeros(9,10,4,10);

         for k=1:28 %hr std 0
           for l=1:10
              for i=1:9
                 for j=1:10 %noisyfactor
                     NLL(i,j,k,l)=fitBayesianModelextreme_alpha_noinertia_fromPHR_231130(actions,pressn,reshape(PHR_Large_mean_combined(i,j,k,l,1,:),[],1));
                 end
              end
           end
         end


         ind=find(-NLL==max(-NLL(:)));
         [a,b,c,d]=ind2sub(size(NLL),ind);
         bestparameterind=[a,b,c,d];

         %%
        NLLmax=NLL(a,b,c,d);
        
        %figure()

        %for k=1:28
        %   for l=1:10

        %             subplot(28,10,l+(k-1)*10);
                 
        %             %imagesc(NLL(:,:,k,l),[0.87*10^4 1.02*10^4]); %WT
        %             %imagesc(NLL(:,:,k,l),[4500 4900]); %grin2a
        %             imagesc(NLL(:,:,k,l)); %grin2a
        %             %text(j,i,num2str(NLL(:,:,k,l,m)),'Color','k');

        %   end
        %end

        %%
        %load("\\fenglab03\yiyun\20231027 lever pressing paper figure\Bayesian\20231101 bayesian model\phr_grid_search_combined_sub_v7_20231214.mat","PHR_Large_mean_combined",'alphalist','noisyfactorlist','hr_std0list','lr_stdlist');

        %PHR_Large_mean_combined=PHR_Large_mean_combined([3,5:8,10,11,14:15],[1,3:9],[2:9],[2:6],:,:);

        %alphalist_new=alphalist([3,5:8,10,11,14:15]);
        %noisyfactorlist_new=noisyfactorlist([1,3:9]);
        %hr_std0list_new=hr_std0list([2:9]);
        %lr_stdlist_new=lr_stdlist([2:6]);

        alpha=1./(2-alphalist([bestparameterind(:,1)]));
        noisf=noisyfactorhrlist([bestparameterind(:,2)]);
        hrstd=hr_std0list([bestparameterind(:,3)]);
        lrstd=lr_stdlist([bestparameterind(:,4)]);


        %%
        numerialoftrials=0;
        for acti=1:length(actions)
            numerialoftrials=numerialoftrials+length(actions{acti});
        end

        
        Likelihoodindanimal(fin,:)=exp(-NLLmax/numerialoftrials);
        
        bestparameters(fin,:)=[alpha,noisf,hrstd,lrstd];
        NLL_ind(fin,:)=NLLmax;
    end

end