function img_aaf=aaf(img)

img_i = double(padarray(img, [2 2], 'both'));
[row,col] = size(img_i);
img_aaf_o=zeros(row,col);

% kernel
aaf_kernel=[1,0,1,0,1;0,0,0,0,0;1,0,8,0,1;0,0,0,0,0;1,0,1,0,1];
%相当于一个平滑滤波
for j=1+2:1:row-2    %i,j从3,3开始
    for i=1+2:1:col-2
        win=img_i(j-2:j+2,i-2:i+2);
        img_aaf_o(j,i)=(sum(sum(win.*aaf_kernel)))/16;
    end
end

img_aaf=imcrop(img_aaf_o,[3 3 col-5 row-5]);