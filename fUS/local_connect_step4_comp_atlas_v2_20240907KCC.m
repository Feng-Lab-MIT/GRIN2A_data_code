%use this after running the step1

load('kcc_data.mat');

%{
%the code below is for retrieving data from original data%

Skcc=dir(fullfile('\\fenglab03\yiyun\20240820 fUS\','*kcc.mat'));

%%
load('animalIDlist_final.mat');

hetorwt_kcc=cell(size(animalIDlistcom,1),3);

for si=1:numel(Skcc)
    
    filename=Skcc(si).name(2:end);
    if contains(filename,'_n')
        filename=filename(1:strfind(filename,'_n')-1);
    elseif ~isempty(strfind(filename,'r'))
        filename=filename(1:strfind(filename,'r')-1);
    end
    
    if ~isempty(strfind(filename,'k'))
        filename=filename(1:strfind(filename,'k')-1);
    end
    %print('filename')
    
    
    for ai=1:size(animalIDlistcom,1)
        animalID=animalIDlistcom{ai,1};
        if ~isempty(strfind(animalID,'l'))
            animalID=animalID(1:strfind(animalID,'l')-1);
        end
        if ~isempty(strfind(animalID,'r'))   
            animalID=animalID(1:strfind(animalID,'r')-1);            
        end
        animalID=strrep(animalID,'''','');
        
        %print('animalID')
        %animalID

        if strcmp(filename,animalID)==1
            hetorwt_kcc{si,1}=animalIDlistcom{ai,1};
            hetorwt_kcc{si,2}=animalIDlistcom{ai,2};
            hetorwt_kcc{si,3}=ai;

        end
        
        if strcmp(erase(filename,'_'),animalID)==1
            hetorwt_kcc{si,1}=animalIDlistcom{ai,1};
            hetorwt_kcc{si,2}=animalIDlistcom{ai,2};
            hetorwt_kcc{si,3}=ai;

        end
        
        if strcmp(erase(animalID,'_'),filename)==1
            hetorwt_kcc{si,1}=animalIDlistcom{ai,1};
            hetorwt_kcc{si,2}=animalIDlistcom{ai,2};
            hetorwt_kcc{si,3}=ai;

        end       
    end
    
end

%%
hetid_kcc=[];
wtid_kcc=[];

for si=1:size(hetorwt_kcc,1)
    
    if ~isempty(find(hetid==hetorwt_kcc{si,3}))
        hetid_kcc=[hetid_kcc;si];
    elseif ~isempty(find(wtid==hetorwt_kcc{si,3}))
        wtid_kcc=[wtid_kcc;si];
    end
            
end

%%

vqhet=[];
vqwt=[];
hetcount=0;
wtcount=0;

for si=1:numel(Skcc)
    
    load(strcat('\\fenglab03\yiyun\20240820 fUS\',Skcc(si).name),'KCC_local');
    
    if (sum(hetid_kcc==si)>0)

        if isempty(vqhet)
            vqhet=KCC_local;
        else
            vqhet=cat(4,vqhet,KCC_local);
        end
        hetcount=hetcount+1;

    elseif (sum(wtid_kcc==si)>0)
        if isempty(vqwt)
            vqwt=KCC_local;
        else
            vqwt=cat(4,vqwt,KCC_local);
        end
        wtcount=wtcount+1;

    end
   
end
%}

%%
%get only the brain region
load('region_atlas_resample.mat','vqTH','vqIsoCortex','vqMB'); %cortex %olfactory lobe


for k=1:size(vqwt,4)

    for i=1:size(vqwt,2)
        for j=1:size(vqwt,1)
            if ~isempty(find(vqIsoCortex(j,i,:)==1,1,'last'))
                vqwt(j,i,find(vqIsoCortex(j,i,:)==1,1,'last')+3:end,k)=0; %higher than ocrtex ==0
            else
                vqwt(j,i,find(vqMB(j,i,:)==1,1,'last')+3:end,k)=0; %higher than MB ==0
            end
            vqwt(j,i,1:10,k)=0;  %z lower than 10 ==0
        end
    end

    vqwt(:,[1:3,32:41],:,k)=0;

    vqwt(68:81,:,:,k)=0;

end

for k=1:size(vqhet,4)

    for i=1:size(vqhet,2)
        for j=1:size(vqhet,1)
            if ~isempty(find(vqIsoCortex(j,i,:)==1,1,'last'))
                vqhet(j,i,find(vqIsoCortex(j,i,:)==1,1,'last')+3:end,k)=0; %higher than ocrtex ==0
            else
                vqhet(j,i,find(vqMB(j,i,:)==1,1,'last')+3:end,k)=0; %higher than MB ==0
            end
            vqhet(j,i,1:10,k)=0;  %z lower than 10 ==0
        end
    end

    vqhet(:,[1:3,32:41],:,k)=0;

    vqhet(68:81,:,:,k)=0;

end

%%
vqwtav=mean(vqwt,4,'omitnan');
vqhetav=mean(vqhet,4,'omitnan');


%%
for i=1:3:41%21:30

    subplot(4,14,(i-1)/3+1)
    imagesc(permute(reshape(vqwtav(:,i,:),size(vqwtav,1),[]),[2,1]),[0.5 0.8]);
    xlim([0 67])
    ylim([10 74])
    set(gca, 'YDir','normal');
    if i==11
    title('WT')
    end
    
    subplot(4,14,(i-1)/3+1+14)
    imagesc(permute(reshape(vqhetav(:,i,:),size(vqhetav,1),[]),[2,1]),[0.5 0.8]);
    xlim([0 67])
    ylim([10 74])
    set(gca, 'YDir','normal');
    if i==11
    title('HET')
    end

    subplot(4,14,(i-1)/3+1+28)
    imagesc(permute(reshape((vqhetav(:,i,:)-vqwtav(:,i,:)),size(vqhetav,1),[]),[2,1]),[0 0.15]);
    xlim([0 67])
    ylim([10 74])
    set(gca, 'YDir','normal');
    if i==11
    title('HET-WT')
    end

    subplot(4,14,(i-1)/3+1+42)
    imagesc(permute(reshape(-(vqhetav(:,i,:)-vqwtav(:,i,:)),size(vqhetav,1),[]),[2,1]),[0 0.15]);
    xlim([0 67])
    ylim([10 74])
    set(gca, 'YDir','normal');
    if i==11
    title('WT-HET')
    end


end

%%

load('region_atlas_resample.mat','vqACC','vqPL','vqIL','vqMD','vqSTRd','vqSTRv','vqHPF','vqHY');

% 1. prefrontal cortex PFC: ACC+PL+IL
% 2. dorsal striatum dSTR
% 3. ventral striatum vSTR
% 4. hippocampus HFP
% 5. mediodorsal thalamus MD
% 6. Hypothalamus HY


vqACCr=vqACC;
vqACCr(:,21:41,:)=0;

vqILr=vqIL;
vqILr(:,21:41,:)=0;

vqPLr=vqPL;
vqPLr(:,21:41,:)=0;

vqSTRvl=vqSTRv;
vqSTRvr=vqSTRv;

vqSTRvl(:,1:20,:)=0;
vqSTRvr(:,21:41,:)=0;

vqSTRdl=vqSTRd;
vqSTRdr=vqSTRd;

vqSTRdl(:,1:20,:)=0;
vqSTRdr(:,21:41,:)=0;

vqHPFl=vqHPF;
vqHPFr=vqHPF;

vqHPFl(:,1:20,:)=0;
vqHPFr(:,21:41,:)=0;

vqHYl=vqHY;
vqHYr=vqHY;

vqHYl(:,1:20,:)=0;
vqHYr(:,21:41,:)=0;

vqMDl=vqMD;
vqMDr=vqMD;

vqMDl(:,1:20,:)=0;
vqMDr(:,21:41,:)=0;


%% AVERAGE SELECTED REGIONS

%define anteriorACC (where PL appears)
% vqACCa=vqACC;
% vqACCa(1:40,:,:)=0;


vqwtSTRdlav=zeros(length(wtid),1);
vqwtSTRdrav=zeros(length(wtid),1);
vqwtSTRvlav=zeros(length(wtid),1);
vqwtSTRvrav=zeros(length(wtid),1);

vqwtHPFlav=zeros(length(wtid),1);
vqwtHPFrav=zeros(length(wtid),1);

vqwtHYlav=zeros(length(wtid),1);
vqwtHYrav=zeros(length(wtid),1);

vqwtMDrav=zeros(length(wtid),1);

vqwtPFCrav=zeros(length(wtid),1);


vqhetSTRdlav=zeros(length(hetid),1);
vqhetSTRdrav=zeros(length(hetid),1);
vqhetSTRvlav=zeros(length(hetid),1);
vqhetSTRvrav=zeros(length(hetid),1);

vqhetHPFlav=zeros(length(hetid),1);
vqhetHPFrav=zeros(length(hetid),1);

vqhetHYlav=zeros(length(hetid),1);
vqhetHYrav=zeros(length(hetid),1);

vqhetMDrav=zeros(length(hetid),1);

vqhetPFCrav=zeros(length(hetid),1);


for wti=1:length(wtid_kcc)
   
    vqwtSTRvlav(wti)=sum(sum(sum(vqwt(:,:,:,wti).*vqSTRvl)))/sum(sum(sum(vqSTRvl)));
    vqwtSTRvrav(wti)=sum(sum(sum(vqwt(:,:,:,wti).*vqSTRvr)))/sum(sum(sum(vqSTRvr)));
    vqwtSTRdlav(wti)=sum(sum(sum(vqwt(:,:,:,wti).*vqSTRdl)))/sum(sum(sum(vqSTRdl)));
    vqwtSTRdrav(wti)=sum(sum(sum(vqwt(:,:,:,wti).*vqSTRdr)))/sum(sum(sum(vqSTRdr)));
    
    vqwtHPFlav(wti)=sum(sum(sum(vqwt(:,:,:,wti).*vqHPFl)))/sum(sum(sum(vqHPFl)));
    vqwtHPFrav(wti)=sum(sum(sum(vqwt(:,:,:,wti).*vqHPFr)))/sum(sum(sum(vqHPFr)));
    vqwtHYlav(wti)=sum(sum(sum(vqwt(:,:,:,wti).*vqHYl)))/sum(sum(sum(vqHYl)));
    vqwtHYrav(wti)=sum(sum(sum(vqwt(:,:,:,wti).*vqHYr)))/sum(sum(sum(vqHYr)));
    
    vqwtMDrav(wti)=sum(sum(sum(vqwt(:,:,:,wti).*vqMDr)))/sum(sum(sum(vqMDr)));

    vqwtPFCrav(wti)=(sum(sum(sum(vqwt(:,:,:,wti).*vqPLr)))+sum(sum(sum(vqwt(:,:,:,wti).*vqILr)))+sum(sum(sum(vqwt(:,:,:,wti).*vqACCr))))/(sum(sum(sum(vqPLr)))+sum(sum(sum(vqILr)))+sum(sum(sum(vqACCr))));
    
end

for wti=1:length(hetid_kcc)
    vqhetSTRvlav(wti)=sum(sum(sum(vqhet(:,:,:,wti).*vqSTRvl)))/sum(sum(sum(vqSTRvl)));
    vqhetSTRvrav(wti)=sum(sum(sum(vqhet(:,:,:,wti).*vqSTRvr)))/sum(sum(sum(vqSTRvr)));
    vqhetSTRdlav(wti)=sum(sum(sum(vqhet(:,:,:,wti).*vqSTRdl)))/sum(sum(sum(vqSTRdl)));
    vqhetSTRdrav(wti)=sum(sum(sum(vqhet(:,:,:,wti).*vqSTRdr)))/sum(sum(sum(vqSTRdr)));
    
    vqhetHPFlav(wti)=sum(sum(sum(vqhet(:,:,:,wti).*vqHPFl)))/sum(sum(sum(vqHPFl)));
    vqhetHPFrav(wti)=sum(sum(sum(vqhet(:,:,:,wti).*vqHPFr)))/sum(sum(sum(vqHPFr)));
    vqhetHYlav(wti)=sum(sum(sum(vqhet(:,:,:,wti).*vqHYl)))/sum(sum(sum(vqHYl)));
    vqhetHYrav(wti)=sum(sum(sum(vqhet(:,:,:,wti).*vqHYr)))/sum(sum(sum(vqHYr)));
    
    vqhetMDrav(wti)=sum(sum(sum(vqhet(:,:,:,wti).*vqMDr)))/sum(sum(sum(vqMDr)));

    vqhetPFCrav(wti)=(sum(sum(sum(vqhet(:,:,:,wti).*vqPLr)))+sum(sum(sum(vqhet(:,:,:,wti).*vqILr)))+sum(sum(sum(vqhet(:,:,:,wti).*vqACCr))))/(sum(sum(sum(vqPLr)))+sum(sum(sum(vqILr)))+sum(sum(sum(vqACCr))));
    
end

%%
vqwtav_all=[vqwtPFCrav,vqwtSTRvrav,vqwtSTRdrav,vqwtHPFrav,vqwtMDrav,vqwtHYrav];
vqhetav_all=[vqhetPFCrav,vqhetSTRvrav,vqhetSTRdrav,vqhetHPFrav,vqhetMDrav,vqhetHYrav];


vqav_all=zeros(numel(Skcc),size(vqwtav_all,2));
vqav_all([wtid_kcc],:)=vqwtav_all;
vqav_all([hetid_kcc],:)=vqhetav_all;


%%
titlelabel=({'PFCr','STRvr','STRdr','HPFr','MDr','HYr'});

for i=1:length(titlelabel)
    subplot(1,length(titlelabel),i)
    %boxplot([vqwtav_all(:,i),vqhetav_all(:,i)]);hold on;
    scatter(ones(size(vqwtav_all,1),1),vqwtav_all(:,i),'green');hold on;
    scatter(2*ones(size(vqhetav_all,1),1),vqhetav_all(:,i),'red');
    
    
    errorbar([1 2],[mean(vqwtav_all(:,i)) mean(vqhetav_all(:,i))],[std(vqwtav_all(:,i))/sqrt(wtcount) std(vqhetav_all(:,i))/sqrt(hetcount)])
    
    

    title(titlelabel{i});
    ylabel('local connectivity');
    legend({'wt','het'},'Location','southoutside');
    grid on;
    xticks([1:2]);
    yticks([-0.5:0.1:1]);
    ylim([-1 1])
    xlim([0.8 2.2])

    %[~,pval]=ttest2(vqwtav_all(:,i),vqhetav_all(:,i));
    %text(1.3,0.4,strcat('p=',num2str(pval)));

end
