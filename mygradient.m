function [mag,ori] = mygradient(I)
%
% compute image gradient magnitude and orientation at each pixel
%
%
assert(ndims(I)== 2,'input image should be grayscale');

dx = imfilter(I,[-1,1],'replicate');
dy = imfilter(I,[-1,1]','replicate');

% magnitude of the gradient vector
mag = sqrt(dx.^2+dy.^2);
% orientation of hte gradient vector
ori = atan(dy./dx);
% fix all the NaN values we get from division by zero
ori(isnan(ori))= 0;

assert(all(size(mag)==size(I)),'gradient magnitudes should be same size as input image');
assert(all(size(ori)==size(I)),'gradient orientations should be same size as input image');
% 
% figure(11);
% imagesc(mag)
% title('Gradient Magnitude')
% colormap jet;
% colorbar;
% hold on;
% 
% figure(12)
% imagesc(ori)
% title('Orientation');
% colormap hsv;
% colorbar;

end