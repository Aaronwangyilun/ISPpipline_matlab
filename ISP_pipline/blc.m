function img_blc=blc(img_dpc,r_offset,b_offset,gr_offset,gb_offset,alpha,beta)
%%parameter------------
% r=r+r_offset
% gr=gr+gr_offset+¦Ár
% gb=gb+gb_offset+¦Âb
% b=b+b_offset
% r_offset=0;
% b_offset=0;
% gr_offset=0;
% gb_offset=0;
% alpha=0;
% beta=0;

img_i = double(padarray(img_dpc, [2 2], 'both'));
[row,col] = size(img_i);
img_blc_o=zeros(row,col);

for j=1+2:1:row-2    %i,j´Ó3,3¿ªÊ¼
    for i=1+2:1:col-2
        if (~mod(i,2) && ~mod(j,2))%B
            img_blc_o(j,i)=img_i(j,i)+b_offset;
        end
        if (mod(i,2) && ~mod(j,2))%GB
            img_blc_o(j,i)=img_i(j,i)+gb_offset+beta*img_i(j,i-1);
        end
        if (~mod(i,2) && mod(j,2))%GR
            img_blc_o(j,i)=img_i(j,i)+gr_offset+alpha*img_i(j,i-1);
        end
        if (mod(i,2) && mod(j,2))%R
            img_blc_o(j,i)=img_i(j,i)+r_offset;
        end
    end
end

img_blc=imcrop(img_blc_o,[3 3 col-5 row-5]);