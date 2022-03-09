function [img_r_o,img_g_o,img_b_o] = ccm(img_r,img_g,img_b,matrix)

img_r = double(padarray(img_r, [2 2], 'both'));
img_g = double(padarray(img_g, [2 2], 'both'));
img_b = double(padarray(img_b, [2 2], 'both'));
[row,col] = size(img_r);

for j=1+2:1:row-2    %i,j´Ó3,3¿ªÊ¼
    for i=1+2:1:col-2
        img=[img_r(j,i);img_g(j,i);img_b(j,i);1];
        img_o=matrix*img;
        img_r_o(j,i)=img_o(1);
        img_g_o(j,i)=img_o(2);
        img_b_o(j,i)=img_o(3);
    end
end

img_r_o=(imcrop(img_r_o,[3 3 col-5 row-5]));
img_g_o=(imcrop(img_g_o,[3 3 col-5 row-5]));
img_b_o=(imcrop(img_b_o,[3 3 col-5 row-5]));
