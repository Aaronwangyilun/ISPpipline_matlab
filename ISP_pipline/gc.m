function [img_r_o,img_g_o,img_b_o]=gc(img_r,img_g,img_b,maxval,gamma)
img_r_gc=uint8(img_r);
img_g_gc=uint8(img_g);
img_b_gc=uint8(img_b);

[row,col] = size(img_r_gc);
img_r_o=zeros(row,col);
img_g_o=zeros(row,col);
img_b_o=zeros(row,col);
% maxval=2^8;
% gamma=0.8;

lut=zeros(maxval,2);
for i=0:1:maxval-1
    lut(i+1,1)=i;
    lut(i+1,2)=((i/maxval)^gamma)* maxval;
end

for j=1:1:row    %i,j´Ó3,3¿ªÊ¼
    for i=1:1:col
        img_r_o(j,i)=lut(img_r_gc(j,i)+1,2);
        img_g_o(j,i)=lut(img_g_gc(j,i)+1,2);
        img_b_o(j,i)=lut(img_b_gc(j,i)+1,2);
    end
end
% img_rgb_gc=uint8(cat(3,img_r_o,img_g_o,img_b_o));
% imshow(img_rgb_gc);title('gc');