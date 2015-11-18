

addpath(genpath('../utils'));
addpath(genpath('../lib/esvm'));
addpath(genpath('external'));

load('../../data/bus_data.mat');
load('../../data/bus_esvm.mat');

alpha = 100;
Feature_response=[];
imBox=cell(length(models),1);

for i=1:length(models)
    im=imread(['../../data/voc2007/',modelImageNames{i}]);
    if size(im,3)==1
        im = repmat(im,[1 1 3]);
    end      
    box=modelBoxes{i};
    imBox{i}=im(box(2):box(4),box(1):box(3),:);
    imBox{i}=imresize(imBox{i},[100 100]);
    Ilab = rgb2lab(imBox{i});

    binSize = 8 ;
    magnif = 3 ;
    Is1 = vl_imsmooth(single(Ilab(:,:,1)), sqrt((binSize/magnif)^2 - .25)) ;
    Is2 = vl_imsmooth(single(Ilab(:,:,2)), sqrt((binSize/magnif)^2 - .25)) ;
    Is3 = vl_imsmooth(single(Ilab(:,:,3)), sqrt((binSize/magnif)^2 - .25)) ;
    
    [~,d1] = vl_dsift(single(Is1),'size',1,'fast');
    [~,d2] = vl_dsift(single(Is2),'size',1,'fast');
    [~,d3] = vl_dsift(single(Is2),'size',1,'fast');
    featureResponse = [d1;d2;d3]';
    p = randperm(size(featureResponse,1),alpha);
    Feature_response=[Feature_response; featureResponse(p,:)];
end
Feature_response=double(Feature_response);
detectParams = esvm_get_default_params(); %get default detection parameters
detectParams.detect_levels_per_octave=3;
K=20:10:150;
aps=zeros(1,length(K));
boundingBoxes=cell(1,length(K));
kk=1;
for k=K
    fprintf('%d clusters...\n',k);
%     k=30;
    [label,~,~,dist] = kmeans(Feature_response, k,'EmptyAction','drop');
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
    aps(kk)=ap
    kk=kk+1;
end

figure;
plot(K,aps);