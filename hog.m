function ohist = hog(I)
%
% compute orientation histograms over 8x8 blocks of pixels
% orientations are binned into 9 possible bins
%
% I : grayscale image of dimension HxW
% ohist : orinetation histograms for each block. ohist is of dimension (H/8)x(W/8)x9
%

[H,W] = size(I); %size of the input
h2 = ceil(H/8); %the size of the output
w2 = ceil(W/8);
nori = 9;       %number of orientation bins

[mag,ori] = mygradient(I);
%threshold for edges
thresh = 0.1*max(mag(:));                                                   %<--


% separate out pixels into orientation channels


% as a sanity check, we will make sure that every pixel gets
% assigned to at most one orientation bin in the for loop below
pixelbincount = zeros(size(I));

ohist = zeros(h2,w2,nori);
for i = 1:nori
  % you should divide up the range of edge orientations [-pi/2 , pi/2]
  % into 9 equal sized bins.
  angleRangeMin = -pi/2 + (i-1)*pi/9;                                       %<--
  angleRangeMax = angleRangeMin + pi/9;                                     %<--
  % create a binary image containing 1's for the pixels that are edges at this orientation 
  B = zeros(H,W);                                                           %<--
  B((mag > thresh) & (ori >= angleRangeMin) & (ori <= angleRangeMax)) = 1;  %<--

  % this is just for checking correctness
  pixelbincount = pixelbincount + B;

  % record which pix
  % sum up the values over 8x8 pixel blocks.
  
  %useful function for grabbing blocks
  chblock = im2col(B,[8 8],'distinct');  
   %sum over each block and store result in ohist      
  ohist(:,:,i) = reshape(sum(chblock,1), [h2,w2]);                          %<--
end

% At this point, if each pixel has been included in at most 
% one orientation bin, then all the entries in pixelbincount
% should be <= 1. If this assertion fails then you should 
% visualize pixelbincount, ori etc. to help debug.
assert(all(pixelbincount(:)<=1),'every pixel should appear in only a single bin');

% normalize the histogram so that sum over orientation bins is 1 for each block
%   NOTE: Don't divide by 0! If there are no edges in a block (ie. this counts sums to 0 for the block) then just leave all the values 0. 
%ohist = reshape(normr(reshape(ohist,[h2*w2 nori])), [h2 w2 nori]);          %<--
normalizer = sum(ohist,3);
normalizer = normalizer + (normalizer==0);
for i=1:nori
   ohist(:,:,i) = ohist(:,:,i)./normalizer;        
end

end

