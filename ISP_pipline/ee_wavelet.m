function img_o_ee=ee_wavelet(img_Y_denoise511)

% kernel_ver=[-1,0,-1,0,-1;...
%         -1,0,8,0,-1;...
%         -1,0,-1,0,-1;];
kernel_ver=  [0.5, 1,-0.5,1.5, 3, 0, -3,-1.5,0.5, -1,-0.5];
kernel_hor=kernel_ver';
kernel_DR=diag(kernel_ver);
kernel_DL=flip(kernel_DR);
% kernel_hor=kernel_ver';
%% 水平方向
img_i_ver = double(padarray(img_Y_denoise511, [0 5], 'both'));
[row,col]=size(img_i_ver);
img_ee_ver=zeros(row,col);

for i=1:1:row
    for j=1+5:1:col-5
        win=img_i_ver(i:i,j-5:j+5);
        img_ee_ver(i,j)=sum(sum(win.*kernel_ver));
    end
end
img_ee_ver=imcrop(img_ee_ver,[6 0 col-11 row]);
% imshow(uint8(img_ee_ver));
% imshow(abs(img_ee_ver),[]);
% figure

%% 垂直方向
img_i_hor = double(padarray(img_Y_denoise511, [5 0], 'both'));
[row,col]=size(img_i_hor);
img_ee_hor=zeros(row,col);

for m=1+5:1:row-5
    for n=1:1:col
        win=img_i_hor(m-5:m+5,n:n);
        img_ee_hor(m,n)=sum(sum(win.*kernel_hor));
    end
end
img_ee_hor=imcrop(img_ee_hor,[0 6 col row-11]);
% imshow(abs(img_ee_hor),[]);
% figure

%% 左对角方向
img_i_dl = double(padarray(img_Y_denoise511, [5 5], 'both'));
[row,col]=size(img_i_dl);
img_ee_dl=zeros(row,col);

for m=1+5:1:row-5
    for n=1+5:1:col-5
        win=img_i_dl(m-5:m+5,n-5:n+5);
        img_ee_dl(m,n)=sum(sum(win.*kernel_DL));
    end
end
img_ee_dl=imcrop(img_ee_dl,[6 6 col-11 row-11]);
% imshow(abs(img_ee_dl),[]);
% figure

%% 右对角方向
img_i_dr = double(padarray(img_Y_denoise511, [5 5], 'both'));
[row,col]=size(img_i_dr);
img_ee_dr=zeros(row,col);

for m=1+5:1:row-5
    for n=1+5:1:col-5
        win=img_i_dr(m-5:m+5,n-5:n+5);
        img_ee_dr(m,n)=sum(sum(win.*kernel_DR));
    end
end
img_ee_dr=imcrop(img_ee_dr,[6 6 col-11 row-11]);
% imshow(abs(img_ee_dl),[]);
% figure

%%
img_out=(abs(img_ee_ver)+abs(img_ee_hor)+abs(img_ee_dl)+abs(img_ee_dr))/24;
figure
imshow(uint8(img_out*5));
figure
% [row,col]=size(img_out);
% img_edge=zeros(row,col);
% img_out_edge=uint8(img_out);
% for i=1:1:row
%     for j=1:1:col
%         if (img_out_edge(i,j)>10)
%             img_edge(i,j) = 200;
%         else
%             img_edge(i,j) = 0;
%         end
%     end
% end
% figure
% imshow(uint8(img_edge));

% max(max(img_out))
%% EE
% 0-125映射到0-1的比例上
img_i_ee = double(padarray(img_out, [3 3], 'both'));
img_i_ori = double(padarray(img_Y_denoise511, [3 3], 'both'));
[row,col]=size(img_i_ee);
img_o_ee=zeros(row,col);
max_edge=max(max(img_out))
for m=1+3:1:row-3
    for n=1+3:1:col-3
        win=img_i_ori(m-3:m+3,n-3:n+3);
        max_val=max(max(win));
        min_val=min(min(win));
        range=(max_val-min_val);
        img_o_ee(m,n)=(img_i_ee(m,n)/max_edge)*range+img_i_ori(m,n);
    end
end
img_o_ee=imcrop(img_o_ee,[4 4 col-7 row-7]);
% figure
% imshow(uint8(img_o_ee));title('ee')
% figure
% imshow(uint8(img_Y_denoise511));title('ori')
% figure
% imshow(uint8(10*(img_o_ee-img_Y_denoise511)));title('err')


%%
% img_out=img_Y_denoise511+(img_ee_hor+img_ee_ver)/2;
% [row,col]=size(img_out);
% for i=1:1:row
%     for j=1:1:col
%         if img_out(i,j)>255
%             img_out(i,j)=255;
%         end
%     end
% end

% imshow(uint8(img_out))
% figure
% imshow(uint8(img_Y_denoise511))
