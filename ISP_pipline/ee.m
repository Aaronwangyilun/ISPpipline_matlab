function img_out=ee(img_Y_denoise511)

% kernel_ver=[-1,0,-1,0,-1;...
%         -1,0,8,0,-1;...
%         -1,0,-1,0,-1;];
kernel_ver=[-1,0, 1,0,-1;...
            -2,0, 6,0,-2;...
            -1,0, 1,0,-1;];
kernel_hor=kernel_ver';

thres1=8;
thres2=16;
gain1=4;
gain2=16;

%% 水平方向
img_i_ver = double(padarray(img_Y_denoise511, [1 2], 'both'));
[row,col]=size(img_i_ver);
img_o_ver=zeros(row,col);
img_ee_ver=zeros(row,col);

for i=1+1:1:row-1
    for j=1+2:1:col-2
        win=img_i_ver(i-1:i+1,j-2:j+2);
        img_o_ver(i,j)=sum(sum(win.*kernel_ver))/8;
        img_ee_ver(i,j) = ee_lut(img_o_ver(i,j),thres1,thres2,gain1,gain2);
    end
end
img_ee_ver=imcrop(img_ee_ver,[3 2 col-5 row-3]);
imshow(uint8(img_ee_ver));
figure
%% 垂直方向
img_i_hor = double(padarray(img_Y_denoise511, [2 1], 'both'));
[row,col]=size(img_i_hor);
img_o_hor=zeros(row,col);
img_ee_hor=zeros(row,col);

for m=1+2:1:row-2
    for n=1+1:1:col-1
        win=img_i_hor(m-2:m+2,n-1:n+1);
        img_o_hor(m,n)=sum(sum(win.*kernel_hor))/8;
        img_ee_hor(m,n) = ee_lut(img_o_hor(m,n),thres1,thres2,gain1,gain2);
    end
end
img_ee_hor=imcrop(img_ee_hor,[2 3 col-3 row-5]);

imshow(uint8(img_ee_hor));
figure
%%
img_out=img_Y_denoise511+(img_ee_hor+img_ee_ver)/2;
[row,col]=size(img_out);
for i=1:1:row
    for j=1:1:col
        if img_out(i,j)>255
            img_out(i,j)=255;
        end
    end
end

% imshow(uint8(img_out))
% figure
% imshow(uint8(img_Y_denoise511))
