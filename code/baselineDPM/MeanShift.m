function [CCenters,CMemberships] = MeanShift(data,bandwidth,stopThresh)

n = length(data);
w = data(:,end);
X = data(:,1:end-1);
updateX=X;
for i=1:n
    update=stopThresh+0.01;
    xi=X(i,:);
    while (update>stopThresh)
        dist=sqrt(sum((X-repmat(xi,[n 1])).^2,2));
        inWindow=dist<bandwidth;
        Xmean=sum(bsxfun(@times,inWindow.*w,X),1) ./ sum(inWindow.*w);
        update=sqrt(pdist2(Xmean,xi));
        xi=Xmean;
    end
    updateX(i,:)=xi;
end

CMemberships=zeros(n,1);
CMemberships(1)=1;

CCenters(1,:)=updateX(1,:);

for i=2:n
    dist=pdist2(updateX(i,:),CCenters);
    [minVal, Centeridx]=min(dist);
    if minVal < stopThresh
        CMemberships(i)=Centeridx;
    else
        CCenters=[CCenters;updateX(i,:)];
        CMemberships(i)=size(CCenters,1);
    end
end

end

