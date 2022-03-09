clc
clear all
close all
%% RAW Image Read
%bdns_in.raw16:data_deapth=12bit,image_size=2160*3840
col=3840;
row=2160;
filename='bdns_in.raw16';
fid=fopen(filename,'r');
A=fread(fid,[col,row],'uint16');
A=A';
fclose(fid);
img=A/16;

% img = imread('gray1.jpg');

%% DPC Dead Pixel Correction
% use gradient arithmetic
th=30;
img_dpc=dpc(img,th);
% imshow(img_dpc,[]);title('DPC');
% figure
%% BLC Black Level Compensation
% 6 parameters:r_offset,b_offset,gr_offset,gb_offset,alpha,beta
% img_blc=blc(img_dpc,0,0,0,0,0,0);
% imshow(img_blc,[]);title('BLC');
% figure
%% AAF Anti-aliasing Noise Filter
% img_aaf=aaf(img_blc);
img_aaf=aaf(img_dpc);
% imshow(img_aaf,[]);title('AAF');
% figure
%% AWB Auto White Balance
% 4 parameters:gain_r,gain_gr,gain_gb,gain_b
% gray_world
[gain_r,gain_gr,gain_gb,gain_b]=gray_world(img_aaf);
img_awb=awb(img_aaf,gain_r,gain_gr,gain_gb,gain_b);

%% CNF Chroma Noise Filter
% use AWB parameter
img_cnf = cnf(img_awb,gain_r,gain_b);

%% Demosaic
% use malvar arithmetic
[img_r,img_g,img_b]=malvar_demosaic(img_cnf);
img_rgb_demosaic=uint8(cat(3,img_r,img_g,img_b));
imshow(img_rgb_demosaic);title('demosaic')
figure
%% CCM Color Correction Matrix
%RGB to sRGB
%|r'| |255，0  ，0  ,off| |r|
%|g'|=|0  ，255，0  ,off|*|g|
%|b'| |0  ，0  ，255,off| |b|
%                         |1|
matrix=ccm_metrix(img_r,img_g,img_b);%matrix=3*4

[img_r_ccm,img_g_ccm,img_b_ccm] = ccm(img_r,img_g,img_b,matrix);
img_rgb_ccm=uint8(cat(3,img_r_ccm,img_g_ccm,img_b_ccm));
imshow(img_rgb_ccm);title('ccm')
figure

%% GC Gamma Correction
%RGB to sRGB
% maxval=2^8;
% gamma=0.8;
% [img_r_gc,img_g_gc,img_b_gc]=gc(img_r_ccm,img_g_ccm,img_b_ccm,maxval,gamma);
% img_rgb_gc=uint8(cat(3,img_r_gc,img_g_gc,img_b_gc));
% imshow(img_rgb_gc);title('gc');
% figure

%% CSC Color Space Conversion
%RGB to YCrCb
% 量化为 tv range 后的公式( Y∈(16,235)  U/V ∈(16,240) ) 
% YUV转tv range:Y'=219.0*Y+16;Cb=U*224.0+128;Cr=V*224.0+128;   
%| 0.257, 0.504,0.098 | | 16|
%|-0.148,-0.291,0.439 |+|128|
%| 0.439,-0.368,-0.071| |128| 
% img_YCrCb = CSC(img_rgb_gc);
% figure
% imshow(img_YCrCb(:,:,1),[]);

img_YCbCr=double(rgb2ycbcr(img_rgb_ccm));
%% Noise Filter for Luma
% use NLM
patch_size=7;
search_size=11;
img_Y_denoise= NLM(img_YCbCr(:,:,1),patch_size,search_size);
img_Cb_denoise=img_YCbCr(:,:,2);
img_Cr_denoise=img_YCbCr(:,:,3);
% img_Cb_denoise=NLM(img_YCbCr(:,:,2),patch_size,search_size);
% img_Cr_denoise=NLM(img_YCbCr(:,:,3),patch_size,search_size);
% imshow(img_Y_denoise511,[]);
figure
erry=uint8(80*(abs(img_YCbCr(:,:,1)-img_Y_denoise)));
imshow(erry);title('y_err')
figure
errcb=uint8(80*(abs(img_YCbCr(:,:,2)-img_Cb_denoise)));
imshow(errcb);title('Cb_err')
figure
errcr=uint8(80*(abs(img_YCbCr(:,:,3)-img_Cr_denoise)));
imshow(errcr);title('Cr_err')
figure
imshow(img_Cb_denoise,[])
figure
imshow(img_YCbCr(:,:,2),[])
%% BILF Bilateral Noise Filtering
patch_size=7;
img_Y_denoise_bilf = bilf(img_Y_denoise,patch_size);
figure
imshow(uint8(img_Y_denoise_bilf));title('img_Y_denoise_bilf')
figure
imshow(uint8(img_Y_denoise));title('img_Y_denoise')
%% EE Edge Enhancement
% img_ee=ee(img_Y_denoise511);
% img_ee=ee(img_YCbCr(:,:,1));

% img_YCbCr_ee=uint8(cat(3,img_ee,img_YCbCr(:,:,2),img_YCbCr(:,:,3)));
% img_rgb_o=ycbcr2rgb(img_YCbCr_ee);
% figure
% imshow(img_rgb_o);title('ee')

%%
% img_y= ee_wavelet(img_YCbCr(:,:,1));
img_y= ee_wavelet(img_Y_denoise_bilf);
img_cb= ee_wavelet(img_Cb_denoise);
img_cr= ee_wavelet(img_Cr_denoise);
img_YCbCr_ee=uint8(cat(3,img_y,img_cb,img_cr));
img_rgb_o=ycbcr2rgb(img_YCbCr_ee);
figure
imshow(img_rgb_o);title('ee')
figure
imshow(img_rgb_ccm);title('ori')
figure



