
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