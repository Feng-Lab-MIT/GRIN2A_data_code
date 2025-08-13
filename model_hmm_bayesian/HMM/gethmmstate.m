function [seq,Tguess,Eguess,PSTATES,s1p,s2p,s3p,s1pc,s2pc,s3pc,NLLout]=gethmmstate(SSFO,commitrate)

    for blocki=1:length(SSFO)
        seq{blocki}=[2*(SSFO{1,blocki}.LRchoice==0)+1*(SSFO{1,blocki}.LRchoice==1)]';
    end
    
    %do grid search
    
    input=struct;
    input.seq=seq'; %this is wrong, how to do with this???  << rewrite fitDelta to reset hr velo and value after each run
    %input.startPoint   =[0.7,0.2,0.2,0.6,0.1,0.1]; %startpoint1 <
    %input.startPoint   =[1/3,1/3,1/3,1/3,1/3,1/3]; %startpoint2
    %input.startPoint   =[0,1/3,2/3,0,1/3,2/3];%startpoint3 <
    %input.startPoint   =[0,2/3,1/3,0,2/3,1/3];%startpoint4
    input.startPoint   =[1,0,0,1,0,0];%startpoint5
    input.LB           =[0,0,0,0,0,0]; 
    input.UB           =[1,1,1,1,1,1]; 
    [output]=maxLikeFit_hmmtest_fixemission_eachblock3(input,commitrate)
    NLLout=output.logLikelihood;
    
    Tguess=[output.params(1),output.params(2),1-output.params(1)-output.params(2);output.params(3),output.params(4),1-output.params(3)-output.params(4);output.params(5),output.params(6),1-output.params(5)-output.params(6)];
    Eguess=[1-commitrate,commitrate;0.5,0.5;commitrate,1-commitrate];
    for blocki=1:length(seq)
	    [PSTATES{blocki}] = hmmdecode(seq{blocki}, Tguess, Eguess);
        [~,Ioff]=max(PSTATES{blocki});

        s1pc{blocki}=get_consecuative_length(Ioff,1);
        s2pc{blocki}=get_consecuative_length(Ioff,2);
        s3pc{blocki}=get_consecuative_length(Ioff,3);

        s1p{blocki}=sum(Ioff==1);
        s2p{blocki}=sum(Ioff==2);
        s3p{blocki}=sum(Ioff==3);
    end

end