
%%
%close all
clear all

load('Data_final.mat');


%% run WT v.s. Grin2a 
figure;title('WT v.s. Grin2a')
data=WT;
IDs={'WT1','WT2','WT3','WT4','WT5','WT6','WT7','WT8','WT9','WT10','WT11','WT12'};
% IDs={'VG1'};
Y_WT_all=[];
M_WT_all=[];
M_BL_WT_all=[];
optimality_WT_all=[];
pswitch_WT_all=[];
ID_WT=[];
for j=1:length(IDs)
    %get current data input: IDs and data output: Current
Current=getCurrent(IDs{j},data);  

% get block length
BL=getBlockLength(Current);
M_BL_WT=mean(BL,'omitnan');
optimality=getOptimality(Current);
M_optimality_WT=mean(optimality,'omitnan');
% get policy
[Y_WT,M_WT]=GetMatrix(Current);


X=1:1:54;
Y_WT=Y_WT(:,1:54);
Y_WT=smoothdata(Y_WT,2,'gaussian',2);
% plot
S_WT=estimateSEM(Y_WT);
M_WT=median(Y_WT,'omitnan');
subplot(4,9,j)
error_area(X,M_WT,S_WT,[0.5,0.5,0.5],0.5,7)
xlim([0 54])
ylim([0 1])

for i=1:size(Y_WT,1)
    sampleStart_WT(i)=min(find(Y_WT(i,:)<1));
    a=find(Y_WT(i,:)==0);
    if isempty(a)
        sampleEnd_WT(i)=nan;
    else
    sampleEnd_WT(i)=min(find(Y_WT(i,:)==0));
    end
end
M_sampleStart_WT(j)=mean(sampleStart_WT);
M_sampleEnd_WT(j)=mean(sampleEnd_WT);

Y_WT_all=[Y_WT_all;Y_WT];

M_WT_all=[M_WT_all; M_WT];

M_BL_WT_all(j)=M_BL_WT;
M_optimality_WT_all(j)=M_optimality_WT;


end



%%
data=grin2a;
IDs={'grin2a1','grin2a2','grin2a3','grin2a4','grin2a5','grin2a6','grin2a7','grin2a8'};% 2041 incluce 204110 and 20416
%IDs={'20416'};
M_grin2a_all=[];
Y_grin2a_all=[];
% pswitch_grin2a_all=[];
M_BL_grin2a_all=[];
optimality_grin2a_all=[];

ID_grin2a=[];
for j=1:length(IDs)
Current=getCurrent(IDs{j},data);

% get block length
BL=getBlockLength(Current);
M_BL_grin2a=mean(BL,'omitnan');

optimality=getOptimality(Current);
M_optimality_grin2a=mean(optimality,'omitnan');
a=IDs{j}
subplot(4,9,j+18)
[Y_grin2a,M_grin2a]=GetMatrix(Current);
X=1:1:54;
Y_grin2a=Y_grin2a(:,1:54);

Y_grin2a=smoothdata(Y_grin2a,2,'gaussian',2);
S_grin2a=estimateSEM(Y_grin2a);
M_grin2a=median(Y_grin2a,'omitnan');
error_area(X,M_grin2a,S_grin2a,[1,0.3,0.3],0.5,7)
xlim([0 54])
ylim([0 1])

for i=1:size(Y_grin2a,1)
    sampleStart_grin2a(i)=min(find(Y_grin2a(i,:)<1));
    a=find(Y_grin2a(i,:)==0);
    if isempty(a)
        sampleEnd_grin2a(i)=nan;
    else
    sampleEnd_grin2a(i)=min(find(Y_grin2a(i,:)==0));
    end
end
M_sampleStart_grin2a(j)=mean(sampleStart_grin2a);
M_sampleEnd_grin2a(j)=mean(sampleEnd_grin2a,'omitnan');

Y_grin2a_all=[Y_grin2a_all;Y_grin2a];

M_grin2a_all=[M_grin2a_all; M_grin2a];

M_BL_grin2a_all(j)=M_BL_grin2a;
M_optimality_grin2a_all(j)=M_optimality_grin2a;
end


figure; 
M_M_WT_all=median(M_WT_all,'omitnan');
S_M_WT=estimateSEM(M_WT_all);
error_area(X,M_M_WT_all, S_M_WT, [0.5,0.5,0.5], 0.5,7)
xlim([0 54])
ylim([0 1])

hold on;

M_M_grin2a_all=median(M_grin2a_all,'omitnan');
S_M_grin2a=estimateSEM(M_grin2a_all);
error_area(X,M_M_grin2a_all, S_M_grin2a, [1,0.3,0.3], 0.5,7)




 % functions
 
 
 
%plot MD_WT and PL_WT


function plotY(data,type)
[Y,M]=GetMatrix(data);

Y=smoothdata(Y,2,'gaussian',2);
    X=1:1:54;
    Y=Y(:,1:54);

S=estimateSEM(Y);
M=median(Y,'omitnan');

if contains(type,'ON')
 error_area(X,M,S,[0.7,0.7,0.1],0.5,7)
else
if contains(type,'grin2a')
    error_area(X,M,S,[0.7,0.1,0.1],0.5,7)
else
    error_area(X,M,S,[0.3,0.3,0.3],0.5,7)
end
end
end


function plotMean(data,type)
[Y,M]=GetMatrix(data);

Y=smoothdata(Y,2,'gaussian',2);
    X=1:1:54;
    Y=Y(:,1:54);

S=estimateSEM(Y);
M=mean(Y,'omitnan');

if contains(type,'ON')
 error_area(X,M,S,[0.7,0.7,0.1],0.5,7)
else
if contains(type,'grin2a')
    error_area(X,M,S,[0.7,0.1,0.1],0.5,7)
else
    error_area(X,M,S,[0.3,0.3,0.3],0.5,7)
end
end
end





function [Y_pHR_matrix,Y_model_matrix] = GetMatrix(block)



Y_pHR_matrix=[];
Y_model_matrix=[];
for i=1:length(block)
    if ~isempty(block)
    currentHRrequest=block{i}.HRrequest;
    currentHRchoice=block{i}.HRchoice;
    
[X_HRrequest,Y_pHR] = estimatePolicy(currentHRrequest,currentHRchoice);
[k,model,Y_model] = fitSigmoid(Y_pHR,X_HRrequest);

n=length(Y_pHR);

if testBlock(block{i})==1
    Y_pHR(n:54)=0;
else
    Y_pHR(n:54)=nan;
end

if length(Y_pHR)>54
    Y_pHR(55:end)=[];
end

if isnan(Y_pHR(1))
    Y_pHR(1)=1;
end

    else
        Y_pHR=NaN(1,54);
        Y_model=NAN(1,54);
    end
 Y_pHR_matrix(i,:)=Y_pHR;
 Y_model_matrix(i,:)=Y_model;
 
 
end
end

 function [k,model,Y_model] = fitSigmoid(Y,X)

    warning off
    type = 'Normal';
    model = @(k,x)  k(3).*(1-cdf(type,x,k(1),k(2)))+(1-k(3));
    try
        if nargin==1
            if size(Y,2)>size(Y,1)
                Y = Y';
            else
            end
            k = lsqcurvefit(model,[length(Y)/2 3 1],1:length(Y),Y',[15 1 1],[50 5 1],optimset('Display','off'));
            Y_model = model(k,[1:100]');
        else
            if size(Y,2)>size(Y,1)
                Y = Y';
            else
            end
            if size(X,2)>size(X,1)
                X = X';
            else
            end
            k = lsqcurvefit(model,[18 3 1],X',Y',[10 1 1],[30 5 1],optimset('Display','off'));
            %3 parameters of initial [midpoint slope LRcommitment] while [10 0.5 0.5] and [30 5 1] are lower and upper boundaries, respectively.
            Y_model = model(k,[1:100]');
        end
    catch
        k = nan(1,3);
        Y_model = nan(1,100);
    end
 end
 

 function Current=getCurrent(ID,data)
 AnimalID=ID;
    eval(['WT' AnimalID '={}']);
    
    for i=1:length(data)
        if ~isempty(data{i})
    if contains(data{i}.ID,AnimalID)
      eval(['WT' AnimalID '{end+1}' '=data{i}']); % it worked!!!!
    end
        end
    end   
    eval(['Current=WT' AnimalID]);  
 end


%get block length for blocks



function BL=getBlockLength(block)

BL=[];
for i=1:length(block)
    if ~isempty(block)
        BL(i)=length(block{i}.LRchoice);
    end
end
end

function optimality=getOptimality(block)


RewardPerPress=[];
for i=1:length(block)
        RewardPerPress(i)=(sum(block{i}.HRreward)+sum(block{i}.LRreward))/(sum(block{i}.HRpress)+sum(block{i}.LRpress));
        optimality(i)=RewardPerPress(i)/(69/200);
end

    
end
