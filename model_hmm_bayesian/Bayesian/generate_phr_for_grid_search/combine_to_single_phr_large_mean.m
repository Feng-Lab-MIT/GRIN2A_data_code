
half2=load('phr_hr_4_05_7.mat');
hr_025=load('phr_hr_025.mat');

phr_large_mean_half2=mean(half2.phr,6);
phr_large_mean_025=mean(hr_025.phr,6);

phr_large_mean_half2=reshape(phr_large_mean_half2,9,10,7,10,1,73);
phr_large_mean_025=reshape(phr_large_mean_025,9,10,14,10,1,73);

half1=load('PHR_grin_search_coarse_exp_alphamore250330.mat');
phr_large_mean_half1=half1.PHR_Large_mean;

%%

phr_large_mean_half1=phr_large_mean_half1(:,:,1:7,:,:,:);


phr_large_mean_combine_05=cat(3,phr_large_mean_half1,phr_large_mean_half2);

%%
phr_large_mean_combine=zeros(9,10,28,10,1,73);

phr_large_mean_combine(:,:,[2:2:28],:,:,:)=phr_large_mean_combine_05;

phr_large_mean_combine(:,:,[1:2:28],:,:,:)=phr_large_mean_025;

save('phr_large_mean_combine.mat','phr_large_mean_combine')
