
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
%%
detectParams = esvm_get_default_params(); %get default detection parameters
detectParams.detect_levels_per_octave=3;
K=20:10:150;
aps=zeros(1,length(K));
boundingBoxes=cell(1,length(K));
kk=1;
for k=K
    fprintf('%d clusters...\n',k);
%     k=30;
    [label,~,~,dist] = kmeans(Filter_response, k,'EmptyAction','drop');
    Avg=cell(k,1);
    C=cell(k,1);
    for i=1:k
        c=ceil(find(label==i)/alpha);
        avg=zeros(100,100,3); 
        for j=1:length(c)
            avg =  avg + double(imBox{c(j)});
        end
        C{i}=c;
        Avg{i}=uint8(avg/length(c));
    end
    figure;
    imdisp(Avg);
    
    [~,idx]=min(dist,[],1);
    
    compactModels=models(unique(ceil(idx/alpha)));
    
    boundingBoxes{kk} = batchDetectImageESVM(gtImages, compactModels, detectParams);
  
    [rec,prec,ap] = evalAP(gtBoxes,boundingBoxes{kk});
    aps(kk)=ap;
    kk=kk+1;
end

figure;
plot(K,aps);



