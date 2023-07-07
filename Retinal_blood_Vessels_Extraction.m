%% Retinal-Vessels-Extraction
%  S. Amir Tabatabaei H.
%  Reza Kazemzadeh
clear; close all; clc;

%% Load Image & Resize Image
I = imread('f3.jpg');
I = imresize(I,[1000 1000]);
figure,
imshow(I), title('Original Image');

%% Extract & Complement Green Channel
if size(I,3)>1
    greenc = I(:,:,2);                         % Extract Green Channel
else
    greenc = I;
end
ginv = imcomplement(greenc);                 % Complement the Green Channel
figure,
imshow(ginv), title('Complement Image');

%% PreProcessing
% Homomorphic Filtering
[M, N] = size(ginv);
GammaH = 1;
GammaL = 0.2;
D0 = 300;
C = 0.2;
D = zeros(M,N);
for i = 1:M
    for j = 1:N
        D(i,j) = sqrt(((i-M/2)^2+(j-N/2)^2));
    end
end
H = ( GammaH - GammaL ) * ( 1 - exp(-C*D.^2/D0) ) + GammaL ;
figure,
imshow(abs(H)), title('Frequency Response of Filter')
% Apply Filter
ImFFT = fft2(ginv);
ImFFT = fftshift(ImFFT);
ImFFT = ImFFT.*H;
ginv  = real(ifft2(ifftshift(ImFFT)));
ginv  = uint8(ginv);
figure, imshow(ginv);
title('Filtered Image');

%% Adaptive Histogram Equalization
adahist = adapthisteq(ginv);                    % Adaptive Histogram Equalization
figure,
imshow(adahist), title('Adaptive Hist Equalize');

%% Morphological Open Using Disk & Remove Optic Disk
se     = strel('ball',4,4);                     % Structuring Element
gopen  = imopen(adahist,se);                    % Morphological Open
godisk = adahist - gopen;                       % Remove Optic Disk
figure,
imshow(godisk), title('Remove Optic');

%% 2-D Median Filter
medfilt    = medfilt2(godisk);                  % 2D Median Filter
figure,
imshow(medfilt), title('Median Filtered');

%% Remove Background Using ImOpen
background = imopen(medfilt,strel('disk',15));  % imopen function
I2         = medfilt - background;              % Remove Background
figure,
imshow(I2), title('Remove Background');

%% Adjust Image
I3 = imadjust(I2);                              % Image Adjustment
figure,
imshow(I3), title('Adjust Image');

%% Thresholding & Binarization
level = graythresh(I3);                         % Gray Threshold
bw = im2bw(I3,level);                           % Binarization
figure,
imshow(bw), title('Binarization with Gray-Thr');

%% Morphological Open
bw = bwareaopen(bw, 20);                        % Morphological Open to Remove Small Objects
figure,
imshow(bw), title('Binary Mask');

%% Extarct Boundary in Binary Image
b = bwboundaries(bw);

%% Show Images & Boundaries
figure,
imshow(I), title('Boundary of Vessels');
hold on;
for k = 1:numel(b)
    plot(b{k}(:,2), b{k}(:,1), 'g');
end

%% Show Vessels
ImVessel = double(I).*repmat(bw,1,1,size(I,3));
figure,
imshow(uint8(ImVessel)), title('Extracted Vessels');

%% Load Gold Mask & Resize Mask
g_mask = imread('f3_gold.png')*255;
g_mask = imresize(g_mask,[1000 1000]);
figure,
imshow(g_mask), title('Gold Mask');

%% Calculating the pixel-level precision, recall, and F-score metrics
TP = sum(sum(bw & g_mask));
FP = sum(sum(bw & ~g_mask));
FN = sum(sum(~bw & g_mask));
presicion = TP / (TP + FP);
recall = TP / (TP + FN);
fscore = 2 * presicion * recall / (presicion + recall);

% Display the results
disp(['Pixel-level precision: ' num2str(presicion)]);
disp(['Pixel-level recall: ' num2str(recall)]);
disp(['Pixel-level fscore: ' num2str(fscore)]);
