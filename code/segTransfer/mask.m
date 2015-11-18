function m=mask(imIdx)

addpath(genpath('../utils'));
addpath(genpath('../lib/esvm'));
% addpath(genpath('../external'));

load('../../data/bus_data.mat');
load('../../data/bus_esvm.mat');

im=imread(modelImageNames{imIdx});
box=modelBoxes{imIdx};
imBox=im(box(2):box(4),box(1):box(3),:);
% imBox=imresize(imBox,[200 200]);

[height, width, planes] = size(imBox);
rgb = reshape(imBox, height, width * planes);

% figure; imshow(rgb);                   % visualize RGB planes

r = imBox(:, :, 1);             % red channel
g = imBox(:, :, 2);             % green channel
b = imBox(:, :, 3);             % blue channel

m=r<150;
figure; imshow(m);


end