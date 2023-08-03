function [x,y,score] = detect(I,template,ndet)
%
% return top ndet detections found by applying template to the given image.
%   x,y should contain the coordinates of the detections in the image
%   score should contain the scores of the detections
%

% compute the feature map for the image
f = hog(I);
nori = size(f,3);

% cross-correlate template with feature map to get a total response
R = zeros(size(f,1),size(f,2));
for i = 1:nori
  R = R + conv2(f(:,:,i),imrotate(template(:,:,i),180), 'same');            %<-- had imfilter before 
end

% now return locations of the top ndet detections

% sort responses from high to low
[val,ind] = sort(R(:),'descend');

% work down the list of responses, removing overlapping detections as we go
i = 1;
detcount = 0;
%x = zeros(ndet,1);
%y = zeros(ndet,1);
score = zeros(ndet,1);
while ((detcount < ndet) & (i <= length(ind)))
  % convert ind(i) back to (i,j) values to get coordinates of the block
  %[yblock,xblock] = ...
  yblock = mod(ind(i),size(R,1));                                           %<--
  yblock(yblock==0) = size(R,1);
  xblock = ceil(ind(i)/size(R,1));
  
  %make sure we did the indexing correctly
  assert(val(i)==R(yblock,xblock)); 

  % now convert yblock,xblock to pixel coordinates 
  % ypixel = ...
  % xpixel = ...
  ypixel = 8*yblock - 4;                                                    %<--
  xpixel = 8*xblock - 4;                        
  % check if this detection overlaps any detections which we've already added to the list
  % you should do this by comparing the x,y coordinates of the new candidate detection to all 
  % the detections previously added to the list and 
  %check if the distance between the detections is less than 70% of the template width/height
  %overlap = ...
  overlap = false;                                                          %<-
    if i > 1
      %a list of scalars that describe how copies of y(or x)pixel are arranged in each dimension
      ypixel_c = repmat(ypixel,[1,length(y)]);              
      xpixel_c = repmat(xpixel,[1,length(x)]);
      dist = sqrt(((x - xpixel_c).^2) + ((y - ypixel_c).^2)); 
      dist = (dist < size(template,1)*7);
      if (sum(dist) >= 1)
         overlap = true; 
      end
    end
  
  % if not, then add this detection location and score to the list we return
  if (~overlap)
    detcount = detcount+1;

    %x(detcount) = ...
    %y(detcount) = ...
    %score(detcount) = ...
    x(detcount) = xpixel;
    y(detcount) = ypixel;
    score(detcount) = val(i);
  end
  i = i + 1;
end

% the while loop may terminate before we find the desired number
% of detections... in that case you should shrink the vectors
% x,y,score down to the correct size

%...

%assert(length(x)==detcount);
%assert(length(y)==detcount);
%assert(length(score)==detcount);

