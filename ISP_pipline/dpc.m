function img_dpc=dpc(img,th)
img_i = double(padarray(double(img), [2 2], 'both'));
[row,col] = size(img_i);

%采用梯度来判断用哪个方向的像素来替代，对边缘的保护
% th = 30;
img_o = zeros(row,col);
for j=1+2:1:row-2    %i,j从3,3开始
    for i=1+2:1:col-2
        if( abs(img_i(j-2,i-2)-img_i(j,i))>th && abs(img_i(j,i-2)-img_i(j,i))>th && abs(img_i(j+2,i-2)-img_i(j,i))>th... 
         && abs(img_i(j-2,i)-img_i(j,i))>th && abs(img_i(j+2,i)-img_i(j,i))>th...
         && abs(img_i(j-2,i+2)-img_i(j,i))>th && abs(img_i(j,i+2)-img_i(j,i))>th && abs(img_i(j+2,i+2)-img_i(j,i))>th )
        dv= abs(2*img_i(j,i)-img_i(j,i+2)-img_i(j,i-2));
        dh= abs(2*img_i(j,i)-img_i(j+2,i)-img_i(j-2,i));
        ddl=abs(2*img_i(j,i)-img_i(j+2,i+2)-img_i(j-2,i-2));
        ddr=abs(2*img_i(j,i)-img_i(j+2,i-2)-img_i(j-2,i+2));
        if ( min(min(dv,dh),min(ddl,ddr))==dv )
            img_o(j,i) = (img_i(j,i+2)+img_i(j,i-2)+1)/2;
        end
        if ( min(min(dv,dh),min(ddl,ddr))==dh )
            img_o(j,i) = (img_i(j+2,i)+img_i(j-2,i)+1)/2;
        end
        if ( min(min(dv,dh),min(ddl,ddr))==ddl )
            img_o(j,i) = (img_i(j+2,i+2)+img_i(j-2,i-2)+1)/2;
        end
        if ( min(min(dv,dh),min(ddl,ddr))==ddr )
            img_o(j,i) = (img_i(j+2,i-2)+img_i(j-2,i+2)+1)/2;
        end
        else
            img_o(j,i) = img_i(j,i);
        end
    end
end
img_o_cut = imcrop(img_o,[3 3 (col-5) (row-5)]);
img_dpc = img_o_cut;