function [refinedBBoxes] = nms(bboxes, bandwidth,K)

refinedBBoxes=[];
stopThresh=bandwidth*0.001;
minScore=min(bboxes(:,end));
maxScore=max(bboxes(:,end));
bboxes(:,end)=(1+bboxes(:,end)-minScore)/(maxScore-minScore);
[CCenters,CMemberships] = MeanShift(bboxes,bandwidth,stopThresh);

%find boxes in each cluster with highest score
for i=1:size(CCenters,1)
    inCluster=bboxes(CMemberships==i,:);
    [~,idx]=max(inCluster(:,end));
    refinedBBoxes=[refinedBBoxes; inCluster(idx,:)];
end

if size(refinedBBoxes,1)>K
    [~,idx]=sort(refinedBBoxes(:,end),'descend');
    refinedBBoxes=refinedBBoxes(idx,:);
    refinedBBoxes=refinedBBoxes(1:K,1:end-1);
end



