function [img_r_o,img_g_o,img_b_o]= malvar_demosaic(img)

% %% bayer to rgb parameter
% bayer_pattern = "rggb";
% bayer_mode = "malvar";
        % rggb
        %    1  2  3  4  5
        % 1 |R |GR|R |GR|R |
        % 2 |GB|B |GB|B |GB|
        % 3 |R |GR|R |GR|R |
        % 4 |GB|B |GB|B |GB|
        % 5 |R |GR|R |GR|R |
        % 填充完0后的5*5的windows
        %    1  2  3  4  5
        % 1 |0 |0 |0 |0 |0 |
        % 2 |0 |0 |0 |0 |0 |
        % 3 |0 |0 |R |GR|R |
        % 4 |0 |0 |GB|B |GB|
        % 5 |0 |0 |R |GR|R |
img_i = double(padarray(img, [2 2], 'both'));
[row,col] = size(img_i);
img_r = zeros(row,col);
img_g = zeros(row,col);
img_b = zeros(row,col);
%% kernel
g_at_b=[0,0,-1,0,0;0,0,2,0,0;-1,2,4,2,-1;0,0,2,0,0;0,0,-1,0,0];
r_at_b=[0,0,-1.5,0,0;0,2,0,2,0;-1.5,0,6,0,-1.5;0,2,0,2,0;0,0,-1.5,0,0];

g_at_r=g_at_b;
b_at_r=r_at_b;

r_at_gr=[0,0,0.5,0,0;0,-1,0,-1,0;-1,4,5,4,-1;0,-1,0,-1,0;0,0,0.5,0,0];
b_at_gr=r_at_gr';

r_at_gb=b_at_gr;
b_at_gb=r_at_gr;
% demosaic filter
for j=1+2:1:row-2    %i,j从3,3开始
    for i=1+2:1:col-2
        if (~mod(i,2) && ~mod(j,2))%B
            win=img_i(j-2:j+2,i-2:i+2);
            img_b(j,i)=img_i(j,i);
            img_g(j,i)=(sum(sum(win.*g_at_b)))/8;
            img_r(j,i)=(sum(sum(win.*r_at_b)))/8;
        end
        if (mod(i,2) && ~mod(j,2))%GB
            win=img_i(j-2:j+2,i-2:i+2);
            img_b(j,i)=(sum(sum(win.*b_at_gb)))/8;
            img_g(j,i)=img_i(j,i);
            img_r(j,i)=(sum(sum(win.*r_at_gb)))/8;
        end
        if (~mod(i,2) && mod(j,2))%GR
            win=img_i(j-2:j+2,i-2:i+2);
            img_b(j,i)=(sum(sum(win.*b_at_gr)))/8;
            img_g(j,i)=img_i(j,i);
            img_r(j,i)=(sum(sum(win.*r_at_gr)))/8;
        end
        if (mod(i,2) && mod(j,2))%R
            win=img_i(j-2:j+2,i-2:i+2);
            img_b(j,i)=(sum(sum(win.*b_at_r)))/8;
            img_g(j,i)=(sum(sum(win.*g_at_r)))/8;
            img_r(j,i)=img_i(j,i);
        end
    end
end

% %% 黑硅
% for j=1+2:1:row-2    %i,j从3,3开始
%     for i=1+2:1:col-2
%         if (mod(i,2) &&~mod(j,2))%B
%             win=img_i(j-2:j+2,i-2:i+2);
%             img_b(j,i)=img_i(j,i);
%             img_g(j,i)=(sum(sum(win.*g_at_b)))/8;
%             img_r(j,i)=(sum(sum(win.*r_at_b)))/8;
%         end
%         if (~mod(i,2) && ~mod(j,2))%GB
%             win=img_i(j-2:j+2,i-2:i+2);
%             img_b(j,i)=(sum(sum(win.*b_at_gb)))/8;
%             img_g(j,i)=img_i(j,i);
%             img_r(j,i)=(sum(sum(win.*r_at_gb)))/8;
%         end
%         if (mod(i,2) && mod(j,2))%GR
%             win=img_i(j-2:j+2,i-2:i+2);
%             img_b(j,i)=(sum(sum(win.*b_at_gr)))/8;
%             img_g(j,i)=img_i(j,i);
%             img_r(j,i)=(sum(sum(win.*r_at_gr)))/8;
%         end
%         if (~mod(i,2) && mod(j,2))%R
%             win=img_i(j-2:j+2,i-2:i+2);
%             img_b(j,i)=(sum(sum(win.*b_at_r)))/8;
%             img_g(j,i)=(sum(sum(win.*g_at_r)))/8;
%             img_r(j,i)=img_i(j,i);
%         end
%     end
% end

%%
img_r_o=imcrop(img_r,[3 3 col-5 row-5]);
img_g_o=imcrop(img_g,[3 3 col-5 row-5]);
img_b_o=imcrop(img_b,[3 3 col-5 row-5]);

% img_rgb=uint8(cat(3,img_r_o,img_g_o,img_b_o));
% imshow(uint8(img_rgb));