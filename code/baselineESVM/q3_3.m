
addpath(genpath('../utils'));
addpath(genpath('../lib/esvm'));
load('../../data/bus_data.mat');
load('../../data/bus_esvm.mat');

apss=zeros(1,8);
boundingBoxes=cell(1,8);

detectParams = esvm_get_default_params(); %get default detection parameters
for i=1:8
    detectParams.detect_levels_per_octave=i+2;
    boundingBoxes{i} = batchDetectImageESVM(gtImages, models, detectParams);
    
    [rec,prec,ap] = evalAP(gtBoxes,boundingBoxes{i});
    apss(i)=ap;
end

figure;
plot(3:10,apss);