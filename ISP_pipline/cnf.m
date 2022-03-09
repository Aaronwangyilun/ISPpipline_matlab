function img_cnf = cnf(img,gain_r,gain_b)

th=0;
img_i = double(padarray(img, [4 4], 'both'));
[row,col] = size(img_i);
img_cnf_o=zeros(row,col);
img_flag=zeros(row,col);
for j=1+4:1:row-4    %i,j从5,5开始
    for i=1+4:1:col-4
        if ((~mod(i,2) && ~mod(j,2))||(mod(i,2) && mod(j,2)))%B||R
            win = img_i(j-4:j+4,i-4:i+4);
            avgC1=sum(sum(win(1:2:9,1:2:9)))/25;
            avgG=(sum(sum(win(2:2:8,1:2:9)))+sum(sum(win(1:2:9,2:2:8))))/40;
            avgC2=sum(sum(win(2:2:8,2:2:8)))/16;
            if (img_i(j,i)>avgG+th)&&(img_i(j,i)>avgC2+th)
                if (avgC1<avgG+th)&&(avgC1<avgC2+th)
                    img_flag(j,i)=255;
                    img_cnf_o(j,i)=cnc(img_i(j,i),j,i,gain_r,gain_b,avgC1,avgG,avgC2);
                else
                    img_cnf_o(j,i)=img_i(j,i);
                end
            else
                img_cnf_o(j,i)=img_i(j,i);
            end
        else%G
            img_cnf_o(j,i)=img_i(j,i);
        end
    end
end

% for j=1:1:row    %i,j从5,5开始
%     for i=1:1:col
%         if img_cnf_o(j,i) > 255
%            img_cnf_o(j,i) = 255;
%         else
%            img_cnf_o(j,i) = img_cnf_o(j,i);
%         end
%     end
% end
imshow(uint8(img_flag));title('under cnf processing');
figure
img_cnf=imcrop(img_cnf_o,[5 5 col-9 row-9]);
