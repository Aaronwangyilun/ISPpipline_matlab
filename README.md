ISP Pipline Test  (@Matlab) 
============
This repository test the ISP Pipline based matlab 2017b
## Image Type
read the .raw image<br />
for example:
```sh
col=3840;
row=2160;
filename='bdns_in.raw16';
fid=fopen(filename,'r');
A=fread(fid,[col,row],'uint16');
```
## DPC
DPC:Dead Pixel Correction;<br />th is a threshold
```sh
img_dpc=dpc(img,th);
```

## BLC
BLC:Black Level Compensation, <br /> 6 parameters:r_offset,b_offset,gr_offset,gb_offset,alpha,beta
```sh
img_blc=blc(img_dpc,0,0,0,0,0,0);
```

## AAF
AAF:Anti-aliasing Noise Filter;
```sh
img_aaf=aaf(img_dpc);
```

## AWB
AWB:Auto White Balance;<br />4 parameters:gain_r,gain_gr,gain_gb,gain_b,<br />use "gray world"
```sh
[gain_r,gain_gr,gain_gb,gain_b]=gray_world(img_aaf);
img_awb=awb(img_aaf,gain_r,gain_gr,gain_gb,gain_b);
```
## AWB
CNF Chroma Noise Filter; <br />use AWB parameters
```sh
img_cnf = cnf(img_awb,gain_r,gain_b);
```
## Demosaic
Demosaic; <br />use malvar arithmetic
```sh
[img_r,img_g,img_b]=malvar_demosaic(img_cnf);
img_rgb_demosaic=uint8(cat(3,img_r,img_g,img_b));
```
## CCM
CCM:Color Correction Matrix; <br />RGB to sRGB<br />
|r'|&#x2002;&#xA0;|255，0  ，0  ,offset|&#xA0;&#xA0;|r|<br />
|g'|=|0  ，255，0  ,offset|*|g|<br />
|b'|&#x2002;&#xA0;|0  ，0  ，255,offset|&#xA0;|b|<br />
&#x2003;&#x2003;&#x2003;&#x2003;&#x2003;&#x2003;&#xA0;&#x2003;&#x2003;&#x2003;&#x2003;&#xA0;&#xA0;|1|<br />
```sh
matrix=ccm_metrix(img_r,img_g,img_b);%matrix=3*4
[img_r_ccm,img_g_ccm,img_b_ccm] = ccm(img_r,img_g,img_b,matrix);
img_rgb_ccm=uint8(cat(3,img_r_ccm,img_g_ccm,img_b_ccm));
```
## CSC
CSC:Color Space Conversion; <br />
RGB to YCrCb<br />
量化为 tv range 后的公式( Y∈(16,235)  U/V ∈(16,240) )<br />
% YUV转tv range:<br />
Y'=219.0*Y+16;<br />
Cb=U*224.0+128;<br />
Cr=V*224.0+128;   <br />
%| 0.257, 0.504,0.098 | | 16|<br />
%|-0.148,-0.291,0.439 |+|128|<br />
%| 0.439,-0.368,-0.071| |128|<br />
```sh
img_YCrCb = CSC(img_rgb_gc);
```
## NFL
NFL:Noise Filter for Luma; <br />
use NLM<br />
parameter: patch_size & search_size<br />
```sh
img_Y_denoise= NLM(img_YCbCr(:,:,1),patch_size,search_size);
img_Cb_denoise=img_YCbCr(:,:,2);
img_Cr_denoise=img_YCbCr(:,:,3);
```
## BILF
BILF:Bilateral Noise Filtering; <br />
use NLM<br />
parameter: patch_size<br />
```sh
patch_size=7;
img_Y_denoise_bilf = bilf(img_Y_denoise,patch_size);
```
## EE
EE:Edge Enhancement; <br />
under doing...
```sh
img_ee=ee(img_Y_denoise511);
```


##Support
hope for improving the code together...
