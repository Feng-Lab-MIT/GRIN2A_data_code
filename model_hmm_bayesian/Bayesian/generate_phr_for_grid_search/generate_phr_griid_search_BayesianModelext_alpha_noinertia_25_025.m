%20231201 exapnd from version 2, add some more parameters
%20231206 expand alpha 
%4exp: add -0.5 -1.5 in alpha
%5exp: add -8 in alpha, change hr std0list 1,3,2,4 => 0.4,0.6,0.7,0.8
%v6: run hr std0 0.4-0.8
%v7: add noisfactor 1.5 2.5 3.5
%v7_3: run k6, l=5-6 

%alphalist=[-6,-5,-4,-3,-2,-1,0,0.2,0.4,0.6,0.7,0.8,0.9];
%alphalist=[-2,-1,0,0.2,0.4,0.6,0.8,-3,-4]; %(8,9)
%alphalist=[-2,-1,0,0.2,0.4,0.6,0.8,-3,-4,-5,-6,0.9,-0.5,-1.5,-0.2,-0.4,-0.6,-0.8,-1.2,-1.4,-1.6,-1.8]; %(10,11,12)
alphanewlist=[0.1:0.1:0.9]; %(13)
alphalist=2-(1./alphanewlist);

noisyfactorhrlist=[0.5:0.5:5]; %6
hr_std0list=[0.025:0.05:0.7]; %(8,9)

lr_stdlist=[0.5:0.5:5]; %(6)
hr_m0list=[1];




%%

for m=1
    for k=1:length(hr_std0list) %1:7 %8:9 %1:9 %hr std 0
       for l=1:length(lr_stdlist)
          for i = 1:length(alphalist)
             for j = 1:length(noisyfactorhrlist)
            
                    alpha=alphalist(i);
                    noisyfactorhr=noisyfactorhrlist(j);
                    
                    hr_std0=hr_std0list(k);
                    lr_std=lr_stdlist(l);
    
                    hr_m0=hr_m0list(m);
                    
                    [phr_hr_per_trial,phr_large_all]=generate_phr_BayesianModelextreme_alpha_noinertia(alpha,noisyfactorhr,hr_m0,hr_std0,lr_std);
            
                    PHR_Large_mean(i,j,k,l,m,:)=phr_hr_per_trial;
                    PHR_Large_all{i,j,k,l,m}=phr_large_all;
            
                    fprintf('PHR_grin_search alpha=%d noisyfactorhr=%d hr_m0=%d hr_std0=%d lr_std=%d\n',alpha,noisyfactorhr,hr_m0,hr_std0,lr_std);

              end
              save('PHR_grin_search_coarse_exp_alphamore250330_025.mat')

          end
       end
       

    end
    
end


