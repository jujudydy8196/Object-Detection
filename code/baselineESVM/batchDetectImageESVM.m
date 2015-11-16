function [boundingBoxes] = batchDetectImageESVM(imageNames, models, params)

numCores=2;
% Close the pools, if any
try
    fprintf('Closing any pools...\n');
%     matlabpool close; 
    delete(gcp('nocreate'))
catch ME
    disp(ME.message);
end

parpool('local', numCores);

N=length(imageNames);
boundingBoxes=cell(1,N);
imgDir='../../data/voc2007/';


parfor i=1:N
    image = imread([imgDir, imageNames{i}]);
    boundingBoxes{i} = esvm_detect(image,models,params);
end

fprintf('Closing the pool\n');
delete(gcp('nocreate'));

end

