clc;
close all;
% load a training example image
%Itrain = im2double(rgb2gray(imread('../data/faces1.jpg')));
Itrain = im2double(rgb2gray(imread('../data/test1.jpg')));

%have the user click on some training examples.  
% If there is more than 1 example in the training image (e.g. faces), you could set nclicks higher here and average together
nclick = 4;
figure(1); clf;
imshow(Itrain);
%get nclicks from the user
%[x,y] = ginput(nclick); 
rect_this = round(getrect);
rect(:,1) = rect_this(:);
%calc box size
    binSize = 8;
    boxArea = mean(rect(3,:).*rect(4,:));
    binArea = floor(boxArea/(binSize*binSize));
    w = sqrt((mean(rect(3,:)./rect(4,:)))*binArea);
    h = w/(mean(rect(3,:)./rect(4,:)));
    w = round(w)*binSize;
    h = round(h)*binSize;
%visualize image patch that the user clicked on
% the patch shown will be the size of our template
% since the template will be 16x16 blocks and each
% block is 8 pixels, visualize a 128pixel square 
% around the click location.
figure(2); clf;
patch = imresize(Itrain(rect(2,1):rect(2,1)+rect(4,1),rect(1,1):rect(1,1)+rect(3,1)),[h w]);
figure(2); subplot(1,2,1); imshow(patch); title('Positive Template');

% compute the hog features
f = hog(patch);
% compute the average template for the user clicks
postemplate = zeros(h/8,w/8,9);
postemplate = postemplate + f; 


% TODO: also have the user click on some negative training
% examples.  (or alternately you can grab random locations
% from an image that doesn't contain any instances of the
% object you are trying to detect).
        hh = round(rand*(size(Itrain,1)-h));
        hh(hh==0) = 1; 
        hh((hh+h-1)>=size(Itrain,1)) = hh-1;
        ww = round(rand*(size(Itrain,2)-w));
        ww(ww==0) = 1;
        ww((ww+w-1)>=size(Itrain,2)) = ww-1;
        negpatch = Itrain(hh:hh+h-1,ww:ww+w-1);
figure(3); subplot(1,2,2); imshow(mean(negpatch,3)); title('Negative Template');

% now compute the average template for the negative examples
negtemplate = zeros(h/8,w/8,9);
    negtemplate = negtemplate + hog(negpatch);
% our final classifier is the difference between the positive
% and negative averages
template = postemplate - negtemplate;

%
% load a test image
%
%Itest= im2double(rgb2gray(imread('../data/faces2.jpg')));
Itest = im2double(rgb2gray(imread('../data/test3.jpg')));

% find top 8 detections in Itest
ndet = 5;
[x,y,score] = detect(Itest,template,ndet);
%ndet = length(x);

%display top ndet detections
figure(3); clf; imshow(Itest);
for i = 1:ndet
  % draw a rectangle.  use color to encode confidence of detection
  %  top scoring are green, fading to red
  hold on; 
  h = rectangle('Position',[x(i)-64 y(i)-64 128 128],'EdgeColor',[(i/ndet) ((ndet-i)/ndet)  0],'LineWidth',3,'Curvature',[0.3 0.3]); 
  hold off;
end
