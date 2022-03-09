function [gain_r,gain_gr,gain_gb,gain_b]=gray_world(img)

img_i = double(img);
[row,col] = size(img_i);

img_r = zeros(row,col);
img_gb = zeros(row,col);
img_gr = zeros(row,col);
img_b = zeros(row,col);

for j=1:1:row   %i,j从3,3开始
    for i=1:1:col
        if (~mod(i,2) && ~mod(j,2))%B
            img_b(j,i)=img_i(j,i);
        end
        if (mod(i,2) && ~mod(j,2))%GB
            img_gb(j,i)=img_i(j,i);
        end
        if (~mod(i,2) && mod(j,2))%GR
            img_gr(j,i)=img_i(j,i);
        end
        if (mod(i,2) && mod(j,2))%R
            img_r(j,i)=img_i(j,i);
        end
    end
end

mean_r= sum(sum(img_r))*4/(row*col);
mean_gr=sum(sum(img_gr))*4/(row*col);
mean_gb=sum(sum(img_gb))*4/(row*col);
mean_b= sum(sum(img_b))*4/(row*col);
mean_gray=sum(sum(img_i))/(row*col);
%%grayworld算法
% gain_r=mean_gray/mean_r;
% gain_gr=mean_gray/mean_gr;
% gain_gb=mean_gray/mean_gb;
% gain_b=mean_gray/mean_b;

gain_r=120/mean_r;
gain_gr=120/mean_gr;
gain_gb=120/mean_gb;
gain_b=120/mean_b;



