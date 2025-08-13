
function [hr_std_all]=get_hr_std_over_hr(lr,noisyfactorhr,hr_std0)
    addpath('D:\paper_code_20250317\model_hmm_bayesian')
    hr_m0=1;
    alpha=2-(1/lr);

    hr_a=0.5;
    hr_k=1-alpha;


    pressntest=[1,1,1,1:1:70];

    hr_std_all=zeros(73,200);


    for resample=1:200
        hr_m=hr_m0;
        hr_std=hr_std0;
        for trial=1:length(pressntest)


            hr_std_all(trial,resample)=hr_std;

            experienced_hrrequest=pressntest(trial);

            experienced_hrrequest=max([0,experienced_hrrequest+2*(rand(1)-0.5)*noisyfactorhr*experienced_hrrequest]);


            hr_b_new=hr_k*(((experienced_hrrequest-hr_m)^2)/(2*(hr_k+1)));
            hr_m_new=(hr_k*hr_m+experienced_hrrequest)/(hr_k+1);
            hr_std_new=( hr_b_new*(hr_k+1)/(hr_a*hr_k) )^0.5;

            hr_b=hr_b_new;
            hr_m=hr_m_new;
            hr_std=hr_std_new;

        end

    end
       
end