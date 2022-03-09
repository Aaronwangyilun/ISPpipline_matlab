function img_awb=awb(img,gain_r,gain_gr,gain_gb,gain_b)
% parameter

img_i = double(padarray(img, [2 2], 'both'));
[row,col] = size(img_i);
img_awb_o=zeros(row,col);

for j=1+2:1:row-2    %i,j´Ó3,3¿ªÊ¼
    for i=1+2:1:col-2
        if (~mod(i,2) && ~mod(j,2))%B
            img_awb_o(j,i)=img_i(j,i)*gain_b;
        end
        if (mod(i,2) && ~mod(j,2))%GB
            img_awb_o(j,i)=img_i(j,i)*gain_gb;
        end
        if (~mod(i,2) && mod(j,2))%GR
            img_awb_o(j,i)=img_i(j,i)*gain_gr;
        end
        if (mod(i,2) && mod(j,2))%R
            img_awb_o(j,i)=img_i(j,i)*gain_r;
        end
    end
end

img_awb=imcrop(img_awb_o,[3 3 col-5 row-5]);