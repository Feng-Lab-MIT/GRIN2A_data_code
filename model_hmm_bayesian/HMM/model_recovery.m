
%posterior prediction check - simulated data of HMM
% simulated data vs real data (p(hr) vs hr) 

%
load('hmm_model_fit_20250813','Tguesswt','Eguesswt','seqwt','Tguessgr','Eguessgr','seqgr');

%use # of blocks of grin2a as total block num
totalblocknum=length(seqgr);

%seqwt and seqgr: experimental real data
%%
%get sequence
for i=1:numel(seqwt)
    
    %find 4 consecutive 2s and 6 consecutive 1s => cut
    [conlength,onsetc,offsetc]=get_consecuative_length1(seqwt{i},2);
   if ~isempty(find(conlength>=4,1,'first'))
       trialstart=onsetc(find(conlength>=4,1,'first'));
       [conlength,onsetc,offsetc]=get_consecuative_length1(seqwt{i}(trialstart:end),1);
       if ~isempty(find(conlength>=6,1,'first'))
           trialend=onsetc(find(conlength>=6,1,'first'))+trialstart-1+5;
       else
           trialend=length(seqwt{i});
       end
   else
       trialstart=1;
       trialend=1;
   end
        
    
    if (trialend-trialstart)<100
        seqwt{i}=seqwt{i}(trialstart:trialend);
        %stateswt{i}=states(trialstart:trialend);
    else
        seqwt{i}=seqwt{i}(trialstart:trialstart+100-1);
        %stateswt{i}=states(trialstart:trialstart+100-1);
    end
  
end    

%%
for i=1:numel(seqgr)
    
    %find 4 consecutive 2s and 6 consecutive 1s => cut
    [conlength,onsetc,offsetc]=get_consecuative_length1(seqgr{i},2);
   if ~isempty(find(conlength>=4,1,'first'))
       trialstart=onsetc(find(conlength>=4,1,'first'));
       [conlength,onsetc,offsetc]=get_consecuative_length1(seqgr{i}(trialstart:end),1);
       if ~isempty(find(conlength>=6,1,'first'))
           trialend=onsetc(find(conlength>=6,1,'first'))+trialstart-1+5;
       else
           trialend=length(seqgr{i});
       end
   else
       trialstart=1;
       trialend=1;
   end
        
    
    if (trialend-trialstart)<100
        seqgr{i}=seqgr{i}(trialstart:trialend);
        %stateswt{i}=states(trialstart:trialend);
    else
        seqgr{i}=seqgr{i}(trialstart:trialstart+100-1);
        %stateswt{i}=states(trialstart:trialstart+100-1);
    end
  
end    
%%


[SeqWT, ratio_simWT]=get_seq_n_ratio(Tguesswt, Eguesswt, totalblocknum);
[SeqGRIN2A, ratio_simGRIN2A]=get_seq_n_ratio(Tguessgr, Eguessgr, totalblocknum);

%%

figure()
% 1. distribution of trial length 
subplot(1,2,1)
boxplot([cellfun(@length,SeqWT),cellfun(@length,seqwt)],[ones(1,numel(SeqWT)),2*ones(1,numel(seqwt))])
%boxplot(cellfun(@length,seqwt))
ylim([0,100])
ylabel('trial length')
xticklabels({'simulation wt','original wt'})
xtickangle(30)



% 1. distribution of trial length 
subplot(1,2,2)
boxplot([cellfun(@length,SeqGRIN2A),cellfun(@length,seqgr)],[ones(1,numel(SeqGRIN2A)),2*ones(1,numel(seqgr))])
ylim([0,100])
ylabel('trial length')
xticklabels({'simulation grin2a','original grin2a'})
xtickangle(30)

%%


triallengthWT_real=cellfun(@length,seqwt);
triallengthWT_sim=cellfun(@length,SeqWT);
triallengthGRIN2A_real=cellfun(@length,seqgr);
triallengthGRIN2A_sim=cellfun(@length,SeqGRIN2A);

x1=triallengthWT_real;
x2=triallengthWT_sim;
z1=triallengthGRIN2A_real;
z2=triallengthGRIN2A_sim;

figure()
bar([mean(x1),mean(x2);mean(z1),mean(z2)]);hold on;
errorbar([0.85,1.15,1.85,2.15],[mean(cellfun(@length,seqwt)),mean(cellfun(@length,SeqWT)),mean(cellfun(@length,seqgr)),mean(cellfun(@length,SeqGRIN2A))],[std(cellfun(@length,seqwt))/sqrt(numel(seqwt)),std(cellfun(@length,SeqWT))/sqrt(numel(SeqWT)),std(cellfun(@length,seqgr))/sqrt(numel(seqgr)),std(cellfun(@length,SeqGRIN2A))/sqrt(numel(SeqGRIN2A))],'k.');
ylim([0,100]);
ylabel('trial length');
legend({'original','simulated'});
xticklabels({'WT','GRIN2A'});
%xtickangle(30);


%%

for blocki=1:length(SeqWT)
    [PSTATES{blocki}] = hmmdecode(SeqWT{blocki}, Tguesswt, Eguesswt);
    [~,Ioff]=max(PSTATES{blocki}); %get the predicted state

    s1pc{blocki}=get_consecuative_length(Ioff,1);
    s2pc{blocki}=get_consecuative_length(Ioff,2);
    s3pc{blocki}=get_consecuative_length(Ioff,3);

    s1p{blocki}=sum(Ioff==1);
    s2p{blocki}=sum(Ioff==2);
    s3p{blocki}=sum(Ioff==3);
end

for blocki=1:length(seqwt)
    [PSTATESori{blocki}] = hmmdecode(seqwt{blocki}, Tguesswt, Eguesswt);
    [~,Ioffori]=max(PSTATESori{blocki});%get the predicted state

    s1pcori{blocki}=get_consecuative_length(Ioffori,1);
    s2pcori{blocki}=get_consecuative_length(Ioffori,2);
    s3pcori{blocki}=get_consecuative_length(Ioffori,3);

    s1pori{blocki}=sum(Ioffori==1);
    s2pori{blocki}=sum(Ioffori==2);
    s3pori{blocki}=sum(Ioffori==3);
end
    
figure()   
subplot(2,2,1)
s1pgrflat=[s1p{:}];
s2pgrflat=[s2p{:}];
s3pgrflat=[s3p{:}];
s1pgroriflat=[s1pori{:}];
s2pgroriflat=[s2pori{:}];
s3pgroriflat=[s3pori{:}];
bar([mean(s1pgrflat),mean(s1pgroriflat);mean(s2pgrflat),mean(s2pgroriflat);mean(s3pgrflat),mean(s3pgroriflat)]);hold on;
errorbar([0.85,1.15,1.85,2.15,2.85,3.15],[mean(s1pgrflat),mean(s1pgroriflat),mean(s2pgrflat),mean(s2pgroriflat),mean(s3pgrflat),mean(s3pgroriflat)],[std(s1pgrflat)/sqrt(length(s1pgrflat)),std(s1pgroriflat)/sqrt(length(s1pgroriflat)),std(s2pgrflat)/sqrt(length(s2pgrflat)),std(s2pgroriflat)/sqrt(length(s2pgroriflat)),std(s3pgrflat)/sqrt(length(s3pgrflat)),std(s3pgroriflat)/sqrt(length(s3pgroriflat))],'k.');
%ylim([0 1]);
xticklabels({'HR commit','explore','LR commit'});
xtickangle(30)
legend('simulated','original')
title('length (# of trials) of states')
ylim([0 60])

subplot(2,2,2)
s1pgrcflat=[s1pc{:}];
s2pgrcflat=[s2pc{:}];
s3pgrcflat=[s3pc{:}];
s1pgrcoriflat=[s1pcori{:}];
s2pgrcoriflat=[s2pcori{:}];
s3pgrcoriflat=[s3pcori{:}];
bar([mean(s1pgrcflat),mean(s1pgrcoriflat);mean(s2pgrcflat),mean(s2pgrcoriflat);mean(s3pgrcflat),mean(s3pgrcoriflat)]);hold on;
errorbar([0.85,1.15,1.85,2.15,2.85,3.15],[mean(s1pgrcflat),mean(s1pgrcoriflat),mean(s2pgrcflat),mean(s2pgrcoriflat),mean(s3pgrcflat),mean(s3pgrcoriflat)],[std(s1pgrcflat)/sqrt(length(s1pgrcflat)),std(s1pgrcoriflat)/sqrt(length(s1pgrcoriflat)),std(s2pgrcflat)/sqrt(length(s2pgrcflat)),std(s2pgrcoriflat)/sqrt(length(s2pgrcoriflat)),std(s3pgrcflat)/sqrt(length(s3pgrcflat)),std(s3pgrcoriflat)/sqrt(length(s3pgrcoriflat))],'k.');
%ylim([0 1]);
xticklabels({'HR commit','explore','LR commit'});
xtickangle(30)
legend('simulated','original')
title('length (# of consecuative trials) of consecuative states')
ylim([0 60])

subplot(2,2,3)

%boxplot(cellfun(@length,SeqWT))
bar([mean(cellfun(@length,SeqWT)),mean(cellfun(@length,seqwt))],'FaceColor',[0.8 0.8 0.8]);hold on;
errorbar([1,2],[mean(cellfun(@length,SeqWT)),mean(cellfun(@length,seqwt))],[std((cellfun(@length,SeqWT))/sqrt(length(SeqWT))),std((cellfun(@length,seqwt))/sqrt(length(seqwt)))],'k.');
ylim([0,100])

%boxplot(cellfun(@length,seqwt))

ylim([0,100])
title('# of trials per block')




%%
%randomly sample the seqwt, take length of seqgr (# of grin2a blocks) from
%(# of wt block as wt block is more than grin2a blocks)
seqwtsub=seqwt(randperm(length(seqwt),totalblocknum));


ratio_wt=-1*ones(numel(seqwtsub),150);
for i=1:numel(seqwtsub)
    ratio_wt(i,1:length(seqwtsub{i}))=seqwtsub{i}-1;    
    
end

ratio_grin2a=-1*ones(numel(seqgr),150);
for i=1:numel(seqgr)
    ratio_grin2a(i,1:length(seqgr{i}))=seqgr{i}-1;    
    
end

figure()
subplot(1,4,1)
%mat=sortrows(ratio_wt);
mat=ratio_wt;
imagesc(mat(:,:))
xlim([1 100])
ylim([1 totalblocknum])
title('seq original wt')

subplot(1,4,2)
%imagesc(sortrows(ratio_simWT))
imagesc((ratio_simWT))
xlim([1 100])
ylim([1 totalblocknum])
title('seq simulation wt')


subplot(1,4,3)
%imagesc(sortrows(ratio_grin2a))
imagesc((ratio_grin2a))
xlim([1 100])
ylim([1 totalblocknum])
title('seq original grin2a')

subplot(1,4,4)
%imagesc(sortrows(ratio_simGRIN2A))
imagesc((ratio_simGRIN2A))
xlim([1 100])
ylim([1 totalblocknum])
title('seq simulation grin2a')

%%

%SORT BY LENGTH

%seqwtsub=seqwt(randperm(length(seqwt),totalblocknum));

x1=cellfun(@length,seqwtsub);
x2=cellfun(@length,SeqWT);
z1=cellfun(@length,seqgr);
z2=cellfun(@length,SeqGRIN2A);

[~,XI1]=sort(x1);
[~,XI2]=sort(x2);
[~,ZI1]=sort(z1);
[~,ZI2]=sort(z2);

figure()
subplot(1,4,1)
mat=ratio_wt(XI1,:);
imagesc(mat(:,:))
xlim([1 100])
ylim([1 totalblocknum])
title('seq original wt')

subplot(1,4,2)
imagesc(ratio_simWT(XI2,:));
xlim([1 100])
ylim([1 totalblocknum])
title('seq simulation wt')


subplot(1,4,3)
imagesc(ratio_grin2a(ZI1,:))
xlim([1 100])
ylim([1 totalblocknum])
title('seq original grin2a')

subplot(1,4,4)
imagesc(ratio_simGRIN2A(ZI2,:))
xlim([1 100])
ylim([1 totalblocknum])
title('seq simulation grin2a')



%%
function [SeqWT, ratio_sim]=get_seq_n_ratio(Tguesswt, Eguesswt, totalblocknum)

    %get sequence
    for i=1:totalblocknum
        [seq,states] = hmmgenerate(200,Tguesswt,Eguesswt); %generate HMM seq from TRANS and EMIS

        %find 4 consecutive 2s and 6 consecutive 1s => cut
        [conlength,onsetc,offsetc]=get_consecuative_length1(seq,2);
       if ~isempty(find(conlength>=4,1,'first'))
           trialstart=onsetc(find(conlength>=4,1,'first'));
           [conlength,onsetc,offsetc]=get_consecuative_length1(seq(trialstart:end),1);
           if ~isempty(find(conlength>=6,1,'first'))
               trialend=onsetc(find(conlength>=6,1,'first'))+trialstart-1+5;
           else
               trialend=200;
           end
       else
           trialstart=1;
           trialend=1;
       end


        if (trialend-trialstart)<100
            SeqWT{i}=seq(trialstart:trialend);
            %StatesWT{i}=states(trialstart:trialend);
        else
            SeqWT{i}=seq(trialstart:trialstart+100-1);
            %StatesWT{i}=states(trialstart:trialstart+100-1);
        end



    end    

    ratio_sim=-1*ones(numel(SeqWT),200);
    for i=1:numel(SeqWT)
        ratio_sim(i,1:length(SeqWT{i}))=SeqWT{i}-1;    

    end


end

%%
function [conlength,onsetc,offsetc]=get_consecuative_length1(Ioff,targetstate)

        onsetc=find(diff(Ioff==targetstate)==1)+1;
        offsetc=find(diff(Ioff==targetstate)==-1)+1;
        if Ioff(1)==targetstate
            onsetc=[1,onsetc];
        end
        if Ioff(end)==targetstate
            offsetc=[offsetc,length(Ioff)+1];
        end
        
        conlength=offsetc-onsetc;


end


%%
function blength=get_consecuative_length(Ioff,targetstate)

        onsetc=find(diff(Ioff==targetstate)==1)+1;
        offsetc=find(diff(Ioff==targetstate)==-1)+1;
        if Ioff(1)==targetstate
            onsetc=[1,onsetc];
        end
        if Ioff(end)==targetstate
            offsetc=[offsetc,length(Ioff)+1];
        end
        blength=mean(offsetc-onsetc);

        if isnan(blength)
            blength=0;
        end


end
