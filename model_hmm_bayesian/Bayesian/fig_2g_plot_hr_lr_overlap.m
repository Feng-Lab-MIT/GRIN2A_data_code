load('D:\GRIN2A_data_code\model_hmm_bayesian\Bayesian\2025results\best_fitting_individual_animal_hr_025.mat')

%%
data=[WT_ind_bestparameters];

overlap_hr_lr_all_WT=[];
for i=1:size(data,1)
    
    [overlap_hr_lr_all,overlap_hr_lr_all_mean]=get_hr_lr_overlap_over_hr(data(i,1),data(i,2),data(i,3),data(i,4));
    overlap_hr_lr_all_WT(i,:)=overlap_hr_lr_all_mean;
    
end

%%
data=[grin2a_ind_bestparameters];

overlap_hr_lr_all_grin2a=[];
for i=1:size(data,1)
    
    [overlap_hr_lr_all,overlap_hr_lr_all_mean]=get_hr_lr_overlap_over_hr(data(i,1),data(i,2),data(i,3),data(i,4));
    overlap_hr_lr_all_grin2a(i,:)=overlap_hr_lr_all_mean;
    
end

%%
data=[MD_OFF_ind_bestparameters];

overlap_hr_lr_all_MD_OFF=[];
for i=1:size(data,1)
    
    [overlap_hr_lr_all,overlap_hr_lr_all_mean]=get_hr_lr_overlap_over_hr(data(i,1),data(i,2),data(i,3),data(i,4));
    overlap_hr_lr_all_MD_OFF(i,:)=overlap_hr_lr_all_mean;
    
end

%%
data=[MD_ON_ind_bestparameters];

overlap_hr_lr_all_MD_ON=[];
for i=1:size(data,1)
    
    [overlap_hr_lr_all,overlap_hr_lr_all_mean]=get_hr_lr_overlap_over_hr(data(i,1),data(i,2),data(i,3),data(i,4));
    overlap_hr_lr_all_MD_ON(i,:)=overlap_hr_lr_all_mean;
    
end

%%
data=[SSFO_OFF_ind_bestparameters];

overlap_hr_lr_all_SSFO_OFF=[];
for i=1:size(data,1)
    
    [overlap_hr_lr_all,overlap_hr_lr_all_mean]=get_hr_lr_overlap_over_hr(data(i,1),data(i,2),data(i,3),data(i,4));
    overlap_hr_lr_all_SSFO_OFF(i,:)=overlap_hr_lr_all_mean;
    
end

%%
data=[SSFO_ON_ind_bestparameters];

overlap_hr_lr_all_SSFO_ON=[];
for i=1:size(data,1)
    
    [overlap_hr_lr_all,overlap_hr_lr_all_mean]=get_hr_lr_overlap_over_hr(data(i,1),data(i,2),data(i,3),data(i,4));
    overlap_hr_lr_all_SSFO_ON(i,:)=overlap_hr_lr_all_mean;
    
end


%%
figure;
subplot(2,3,1);
h1=shadedErrorBar([1,1,1,1:1:70],mean(overlap_hr_lr_all_WT,1),std(overlap_hr_lr_all_WT,[],'omitnan')/sqrt(size(overlap_hr_lr_all_WT,2)),'lineprop','k');
hold on;
h2=shadedErrorBar([1,1,1,1:1:70],mean(overlap_hr_lr_all_grin2a,1),std(overlap_hr_lr_all_grin2a,[],'omitnan')/sqrt(size(overlap_hr_lr_all_grin2a,2)),'lineprop','r');

ylim([0 0.7])
xlabel('hr request')
ylabel('ambiguity')
legend([h1.mainLine,h2.mainLine],{'WT','Grin2a'});
legend('boxoff');
title('Ambiguity')

subplot(2,3,2);
h3=shadedErrorBar([1,1,1,1:1:70],mean(overlap_hr_lr_all_MD_OFF,1),std(overlap_hr_lr_all_MD_OFF,[],'omitnan')/sqrt(size(overlap_hr_lr_all_MD_OFF,2)),'lineprop','k');
hold on;
%h4=shadedErrorBar([1,1,1,1:1:70],mean(overlap_hr_lr_all_MD_ON,1),std(overlap_hr_lr_all_MD_ON,[],'omitnan')/sqrt(size(overlap_hr_lr_all_MD_ON,2)),'lineprop','r');
h4=shadedErrorBar([1,1,1,1:1:70],mean(overlap_hr_lr_all_MD_ON([1:2,6:end],:),1),std(overlap_hr_lr_all_MD_ON([1:2,6:end],:),[],'omitnan')/sqrt(size(overlap_hr_lr_all_MD_ON,2)-3),'lineprop','r');

ylim([0 0.7])
xlabel('hr request')
ylabel('ambiguity')
legend([h3.mainLine,h4.mainLine],{'MD_OFF','MD_ON'});
legend('boxoff');
title('Ambiguity')

subplot(2,3,3);
h5=shadedErrorBar([1,1,1,1:1:70],mean(overlap_hr_lr_all_SSFO_OFF,1),std(overlap_hr_lr_all_SSFO_OFF,[],'omitnan')/sqrt(size(overlap_hr_lr_all_SSFO_OFF,2)),'lineprop','k');
hold on;
h6=shadedErrorBar([1,1,1,1:1:70],mean(overlap_hr_lr_all_SSFO_ON,1),std(overlap_hr_lr_all_SSFO_ON,[],'omitnan')/sqrt(size(overlap_hr_lr_all_SSFO_ON,2)),'lineprop','r');

ylim([0 0.7])
xlabel('hr request')
ylabel('ambiguity')
legend([h5.mainLine,h6.mainLine],{'SSFO_OFF','SSFO_ON'});
legend('boxoff');
title('Ambiguity')