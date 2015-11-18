

addpath(genpath('../utils'));
addpath(genpath('../lib/esvm'));
% addpath(genpath('../external'));

load('../../data/bus_data.mat');
load('../../data/bus_esvm.mat');


imIdx=11;
% m=mask(imIdx);
model=models{imIdx};
models_seg=cell(1,1);
models_seg{1}=model;


im=imread(modelImageNames{imIdx});
box=modelBoxes{imIdx};
imBox=im(box(2):box(4),box(1):box(3),:);
bw=roipoly(imBox)
%%
m=double(bw);

imBox=im2double(imBox);

% imim=repmat(m,[1,1,3]).*imBox;
% imim=imresize(imim,s(1:2));
% figure; imshow(imim);

% hog= showHOG(models{imIdx}.model.w);
% figure; imshow(hog/max(max(hog)));

detectParams = esvm_get_default_params(); %get default detection parameters
detectParams.detect_levels_per_octave=3;

% [boundingBoxes] = batchDetectImageESVM(posImages, models_seg, detectParams)
[MboundingBoxes] = batchDetectImageESVM(modelImageNames, models_seg, detectParams)



idxs=find(cellfun(@isempty,MboundingBoxes)==0);
%%
for idx=idxs
    % box=posBoxes{idx};
    box=modelBoxes{idx};
    % transferIm=imread(posImages{idx});
    transferIm=imread(modelImageNames{idx});
    
    transferSeg=im2double(transferIm(box(2):box(4),box(1):box(3),:));
    s=size(transferSeg);
    m=imresize(m,s(1:2));
    m=repmat(m,[1 1 3]);
    m=~m;
    m=double(m);
    % figure; imshow(m);
    fuse=m.*transferSeg;
    % figure; imshow(fuse);
    
    m=double(bw);
    imim=repmat(m,[1,1,3]).*imBox;
    imim=imresize(imim,s(1:2));
    % figure; imshow(imim);
    
    transferSegAfter=fuse+imim;
    % figure; imshow(transferSegAfter);
    
    transferIm(box(2):box(4),box(1):box(3),:)=transferSegAfter*255;
    figure; imshow(transferIm);
    figure;showboxes(imread(modelImageNames{idx}), modelBoxes{idx});

end