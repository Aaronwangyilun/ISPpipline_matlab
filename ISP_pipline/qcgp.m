function correctedImg = qcgp(img_rgb_demosaic)
% 
I = double(img_rgb_demosaic);
[height, width, ch] = size(img_rgb_demosaic);
r = I(:,:,1);
g = I(:,:,2);
b = I(:,:,3);
% ?
% get the mean and max of three channels
rMean = double(mean(mean(r)));
gMean = double(mean(mean(g)));
bMean = double(mean(mean(b)));
% ?
rMax = double(max(max(r)));
gMax = double(max(max(g)));
bMax = double(max(max(b)));
% ?
kMean = mean([rMean, gMean, bMean]);
kMax = mean([rMax, gMax, bMax]);
% ?
correctedImg = zeros(height, width, ch);

% calculate the coefficient
a = [rMean.*rMean, rMax.* rMax;rMean, rMax];
p = [kMean, kMax]/a;
correctedImg(:,:,1) = p(1) * (r.*r) + p(2) * r;
a = [gMean.*gMean, gMax.* gMax;gMean, gMax];
p = [kMean, kMax]/a;
correctedImg(:,:,2) = p(1) * (g.*g) + p(2) * g;
a = [bMean.*bMean, bMax.* bMax;bMean, bMax];
p = [kMean, kMax]/a;
correctedImg(:,:,3) = p(1) * (b.*b) + p(2) * b;
% make sure there is no overflow
correctedImg(correctedImg>255) = 255;
correctedImg = uint8(correctedImg);
imshow(correctedImg);
end