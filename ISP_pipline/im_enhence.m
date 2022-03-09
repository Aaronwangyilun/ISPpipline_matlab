function im_enh=im_enhence(img,coe)

[row,col] = size(img);
im_enh=zeros(row,col);

for j=1:1:row    %i,j´Ó3,3¿ªÊ¼
    for i=1:1:col
        if ( img(j,i)*coe <255 )
            im_enh(j,i)=img(j,i)*coe;
        else
            im_enh(j,i) = 255;
        end
    end
end
