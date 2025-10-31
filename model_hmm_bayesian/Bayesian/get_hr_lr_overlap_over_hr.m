%20250509 edit calculation of overlapped area

function [overlap_hr_lr_all,overlap_hr_lr_all_mean]=get_hr_lr_overlap_over_hr(lr,noisyfactorhr,hr_std0, lr_std)

    hr_m0=1;
    alpha=2-(1/lr);
    lr_m=6;

    hr_a=0.5;
    lr_a=0.5;
    hr_k=1-alpha;


    pressntest=[1,1,1,1:1:70];

    hr_std_all=zeros(73,200);
    phr_large_all=zeros(73,200);
    overlap_hr_lr_all=zeros(73,200);
    
    x=linspace(-1000,1000,20001);

    for resample=1:500
        hr_m=hr_m0;
        hr_std=hr_std0;
        for trial=1:length(pressntest)


            hr_std_all(trial,resample)=hr_std;
            
            pdhr=makedist('tLocationScale','mu',hr_m,'sigma',hr_std,'nu',2*hr_a);
            pdlr=makedist('tLocationScale','mu',lr_m,'sigma',lr_std,'nu',2*lr_a);
            
            
            histhr=pdf(pdhr,x);
            histlr=pdf(pdlr,x);
            
            
            
            overlap_hr_lr_all(trial,resample)=sum(min(histhr,histlr))*0.1;
            %overlap_hr_lr_all(trial,resample)=sum((histhr.*histlr));
           

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
    
    overlap_hr_lr_all_mean=mean(overlap_hr_lr_all,2);
       
end
