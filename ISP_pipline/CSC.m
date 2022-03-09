function img_YCrCb=CSC(img_rgb)

CSC_matrix=[0.257,0.504,0.098,16;...
            -0.148,-0.291,0.439,128;...
            0.439,-0.368,-0.071,128;];
[row,col,n]=size(img_rgb);
img_YCrCb=zeros(row,col,n);
img_rgb=double(img_rgb);
for j=1:1:row    %i,j´Ó3,3¿ªÊ¼
    for i=1:1:col
        img=[img_rgb(j,i,1);img_rgb(j,i,2);img_rgb(j,i,3);1];
        img_o=CSC_matrix*img;
        img_YCrCb(j,i,1)=img_o(1);
        img_YCrCb(j,i,2)=img_o(2);
        img_YCrCb(j,i,3)=img_o(3);
    end
end