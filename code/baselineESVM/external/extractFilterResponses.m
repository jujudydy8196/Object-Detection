function [filterResponses] = extractFilterResponses(I, filterBank)
% CV Fall 2015 - Provided Code
% Extract the filter responses given the image and filter bank
% Pleae make sure the output format is unchanged. 
% Inputs: 
%   I:                  a 3-channel RGB image with width W and height H 
%   filterBank:         a cell array of N filters
% Outputs:
%   filterResponses:    a W*H x N*3 matrix of filter responses
 

%Convert input Image to Lab
doubleI = im2double(I);
[L,a,b] = RGB2Lab(doubleI(:,:,1), doubleI(:,:,2), doubleI(:,:,3));
% R = doubleI(:,:,1)
% G = doubleI(:,:,2)
% B = doubleI(:,:,3);

pixelCount = size(doubleI,1)*size(doubleI,2);

%filterResponses:    a W*H x N*3 matrix of filter responses
filterResponses = zeros(pixelCount, length(filterBank)*3);



%for each filter and channel, apply the filter, and vectorize

% === fill in your implementation here  ===

for filterIdx = 1:20
     Lf = imfilter(L,filterBank{filterIdx},'conv','same');
     af = imfilter(a,filterBank{filterIdx},'conv','same');
     bf = imfilter(b,filterBank{filterIdx},'conv','same');
     filterResponses(:,3*(filterIdx-1)+1) = Lf(:); 
     filterResponses(:,3*(filterIdx-1)+2) = af(:); 
     filterResponses(:,3*(filterIdx-1)+3) = bf(:);  
    
%     Rf = imfilter(R,filterBank{filterIdx},'conv','same');
%     Gf = imfilter(G,filterBank{filterIdx},'conv','same');
%     Bf = imfilter(B,filterBank{filterIdx},'conv','same');
%     filterResponses(:,3*(filterIdx-1)+1) = Rf(:); 
%     filterResponses(:,3*(filterIdx-1)+2) = Gf(:); 
%     filterResponses(:,3*(filterIdx-1)+3) = Bf(:);  
%      imagesc(filterResponses);
end
