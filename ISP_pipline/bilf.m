% clc
% clear all
% close all
% 
% img = imread('lena_color.jpeg');
% img_i = rgb2gray(img);
% 
% img_gau = double(imnoise(img_i,'gaussian',0.1));
% 
% [m,n] = size(img_gau);
% img_o = zeros(m,n);
function img_o = bilf(img_gau,patch_size)
%% parameter
h1=20;
h2=20;
% patch_size = 5;
p_win_r = (patch_size-1)/2;
%% 
img_i = double(padarray(img_gau, [p_win_r p_win_r], 'both'));
[m,n] = size(img_i);
img_o = zeros(m,n);
w1=zeros(patch_size,patch_size);
w2=zeros(patch_size,patch_size);
w=zeros(patch_size,patch_size);
for i=1+p_win_r:1:m-p_win_r
    for j=1+p_win_r:1:n-p_win_r
        for k=-p_win_r:1:p_win_r
            for l=-p_win_r:1:p_win_r
                w1(k+p_win_r+1,l+p_win_r+1)=exp(abs(img_i(i+k,j+l)-img_i(i,j))/(-h1));
                w2(k+p_win_r+1,l+p_win_r+1)=exp((k^2+l^2)/(-h2));
                w=w1.*w2;
%                 img_o_r=img_gau(i+k,j+l).*w;
            end
        end
        img_o(i,j)= sum(sum((img_i(i-p_win_r:i+p_win_r,j-p_win_r:j+p_win_r)).*w))/sum(sum(w));
    end
end
img_o=imcrop(img_o,[p_win_r+1 p_win_r+1 n-patch_size m-patch_size]);
imshow(img_i,[]);title('噪点图');
figure
imshow(uint8(img_o));title('双边滤波');
%% psnr
% img_ori = zeros(m,n);
% for i=1+(patch_size-1)/2:1:m-(patch_size-1)/2
%     for j=1+(patch_size-1)/2:1:n-(patch_size-1)/2
%         img_ori(i,j) = img_i(i,j);
%     end
% end
% psnr_t = psnr(uint8(img_o), uint8(img_ori));
% ssim_t = ssim(uint8(img_o), uint8(img_ori));
% 
% 
% 
% W = fspecial('gaussian',[5,5],2); 
% G = imfilter(img_gau, W, 'replicate');
% figure;
% imshow(uint8(G)); title('高斯滤波');
% psnr_g = psnr(uint8(G), img_i);
% ssim_g = ssim(uint8(G), img_i);
% 
% %% 
% Image_normalized = im2double(uint8(img_gau));
% w = 5;      %窗口大小  
% sigma = [3 0.1];    %方差  
% Image_bf = bfilter2(Image_normalized,w,sigma);  
% Image_bfOut = uint8(Image_bf*255);  
% figure
% imshow(Image_bfOut);
% psnr_b = psnr(Image_bfOut, img_i);
% ssim_b = ssim(Image_bfOut, img_i);
