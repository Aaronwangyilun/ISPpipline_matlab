function img_out=NLM(img_i,patch_size,search_size)

img_i = double(img_i);

% img_i = img_YCrCb(:,:,1);

% patch_size = 9;
% search_size = 15;
h1=50;%patch均方差，h1越大，越趋向于平滑
% h2=8;%几何位置，h2越大，越趋向于平滑
h3=50;%s参数，h3越大，越趋向于平滑 
h4=50;%像素值差异，h4越大，越趋向于平滑

img_i = double(padarray(img_i, [(search_size-1)/2 (search_size-1)/2], 'both'));
[m,n] = size(img_i);
img_out = zeros(m,n);

w_win=(search_size-patch_size)/2;
p_win_r = (patch_size-1)/2;
s_win_r = (search_size-1)/2;

w1=zeros(2*w_win+1,2*w_win+1);
% w2=zeros(2*w_win+1,2*w_win+1);
w3=zeros(2*w_win+1,2*w_win+1);
w4=zeros(2*w_win+1,2*w_win+1);

%% S generate
s=zeros(m,n);
% for i=1+p_win_r:1:m-p_win_r
%     for j=1+p_win_r:1:n-p_win_r
%         g=mean(mean(img_i(i-1:i+1,j-1:j+1)));
%         s(i,j)=(sqrt(sum(sum(img_i(i-1:i+1,j-1:j+1)-g).^2)))/(p_win_r^2);
%     end
% end
for i=1+p_win_r:1:m-p_win_r
    for j=1+p_win_r:1:n-p_win_r
        g=mean(mean(img_i(i-1:i+1,j-1:j+1)));
        s(i,j)=(sqrt(sum(sum(img_i(i-1:i+1,j-1:j+1)-g).^2)))/(p_win_r^2);
    end
end
%% 
for i=1+s_win_r:1:m-s_win_r
    for j=1+s_win_r:1:n-s_win_r
        for k=-w_win:1:w_win
            for l=-w_win:1:w_win
                w1(k+w_win+1,l+w_win+1)=exp(sum(sum( (img_i(i+k-p_win_r:i+k+p_win_r,j+l-p_win_r:j+l+p_win_r)) - (img_i(i-p_win_r:i+p_win_r,j-p_win_r:j+p_win_r)) ).^2)/(-h1^2));
%                 w2(k+w_win+1,l+w_win+1)=exp((k^2+l^2)/(-h2^2));
                w3(k+w_win+1,l+w_win+1)=exp((s(i+k,j+l)-s(i,j))/(-h3^2));
                w4(k+w_win+1,l+w_win+1)=exp(abs(img_i(i+k,j+l)-img_i(i,j))/(-h4^2));
            end
        end
        w=w1.*w3.*w4;
        img_out(i,j)=sum(sum(img_i(i-w_win:i+w_win,j-w_win:j+w_win).*w))/sum(sum(w));
    end
end

img_out=imcrop(img_out,[(search_size-1)/2+1 (search_size-1)/2+1 n-search_size m-search_size]);
%% psnr
% img_ori = zeros(m,n);
% for i=1+(search_size-1)/2:1:m-(search_size-1)/2
%     for j=1+(search_size-1)/2:1:n-(search_size-1)/2
%         img_ori(i,j) = img_i(i,j);
%     end
% end
% psnr_t1 = psnr(uint8(img_out1), uint8(img_ori));
% ssim_t1 = ssim(uint8(img_out1), uint8(img_ori));
% 
% psnr_t2 = psnr(uint8(img_out2), uint8(img_ori));
% ssim_t2 = ssim(uint8(img_out2), uint8(img_ori));
% 
% psnr_t3 = psnr(uint8(img_out3), uint8(img_ori));
% ssim_t3 = ssim(uint8(img_out3), uint8(img_ori));
