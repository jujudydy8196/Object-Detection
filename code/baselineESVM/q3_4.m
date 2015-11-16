
addpath(genpath('../utils'));
addpath(genpath('../lib/esvm'));
addpath(genpath('external'));

load('../../data/bus_data.mat');
load('../../data/bus_esvm.mat');
%%
alpha = 100;
filterBank=createFilterBank();
Filter_response=[];
imBox=cell(length(models),1);
for i=1:length(models)
    im=imread(['../../data/voc2007/',modelImageNames{i}]);
    if size(im,3)==1
        im = repmat(im,[1 1 3]);
    end      
    box=modelBoxes{i};
    imBox{i}=im(box(2):box(4),box(1):box(3),:);
    imBox{i}=imresize(imBox{i},[100 100]);
    filterResponses=extractFilterResponses(imBox{i},filterBank);
    p = randperm(100*100,alpha);
    Filter_response=[Filter_response; filterResponses(p,:)];
end

% for k=1:50
    k=35;
    [label,~,~,dist] = kmeans(Filter_response, k,'EmptyAction','drop');
    avg=cell(k,1);
    for i=1:k
        c=unique(ceil(find(label==i)/alpha));
        avg{i}=zeros(100,100,3); 
        for j=1:length(c)
            avg{i} =  avg{i} + double(imBox{c(j)});
        end
        avg{i}=uint8(avg{i}/length(c));
    end
    figure;
    imdisp(avg);
    %%
    [~,idx]=min(dist,[],1);
    
    compactModels=models(ceil(idx/alpha));
    
%     detectParams.detect_levels_per_octave=i+2;
%     boundingBoxes{i} = batchDetectImageESVM(gtImages, models, detectParams);
%     
%     [rec,prec,ap] = evalAP(gtBoxes,boundingBoxes{i});
%     aps(i)=ap;
% end
% 
% figure;
% plot(3:10,aps);

