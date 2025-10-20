%revisit 20231206

%USE THIS code to plot mean and std decoding accuracy from Results
addpath('Y:\\Jonathan\plots');
mda=load('Binned_MDInitiation4more_sess2_600ms_bins_200ms_meanaccuracy_cv20.mat');
% #of run per condi x time frames x # of labels 
load('Binned_MDInitiation4more_sess2_600ms_bins_200ms_meanaccuracy_cv20.mat','fn2');
%%
figure();


for fni=1:length(fn2)


    meany=mean(mda.mean_accuracy_100(:,:,fni),1);
    stdy=std(mda.mean_accuracy_100(:,:,fni),1);

    

ts = tinv([0.025  0.975],40-1); 

% 
% if ni==1
%     if fni<=9
%         k=1+(fni-1)*2;
%     elseif (fni>9)&(fni<=17)
%         k=(fni-9)*2;
% %     elseif (fni>14)&(fni<=21)
% %         k=3+(fni-15)*2;
% %     else
% %         k=4+(fni-22)*2;
%     end
% else
%     if fni<=9
%         k=1+(fni-1)*2;
%     elseif (fni>9)&(fni<=17)
%         k=(fni-9)*2;
% %     elseif (fni>14)&(fni<=21)
% %         k=3+(fni-15)*2;
% %     else
% %         k=4+(fni-22)*2;
%     end
% end
%     

subplot(2,9,fni)
    if strcmp(mda.fieldname,'Initiation')==1
        hold on;
        
        H1=shadedErrorBar(-5+0.3:0.2:2-0.3,100.*meany,100.*[ts(2).*stdy'./sqrt(120)],'lineprops','r');


        
        if fni==16
            plot([-5 2],[33 33],'k');
            plot([0 0],[0 95],'k');
            ylim([25 65]);
            xlim([-5 2])
        else
            plot([-5 2],[50 50],'k');
            plot([0 0],[0 95],'k');
            ylim([40 90]);
            xlim([-5 2])
        end
        

        xlabel('Time aligned to initiation (s)');
        %ylabel('Classification accuracy (%)');
        title(fn2{fni},'interpreter','none');
    else
        hold on;
     
        H1=shadedErrorBar(pla.timerewbeg+0.3:0.2:pla.timerewend-0.3,100.*meany,100.*[ts(2).*stdy'./sqrt(120)],'lineprops','r');


        
        if fni==16
            plot([pla.timerewbeg pla.timerewend],[33 33],'k');
            plot([0 0],[0 95],'k');
            ylim([25 65]);
            xlim([-5 2])
        else
            plot([pla.timerewbeg pla.timerewend],[50 50],'k');
            plot([0 0],[0 95],'k');
            ylim([40 90]);
            xlim([-5 2])
        end
        
        
        xlabel('Time aligned to reward (s)');
        %ylabel('Classification accuracy (%)');
        title(fn2{fni},'interpreter','none');
        
    end
    

set(gcf,'Renderer','Painter');
% saveas(gcf,filename(1:end-33),'eps2');
% close

end

legend([H1.mainLine],{'MD'});