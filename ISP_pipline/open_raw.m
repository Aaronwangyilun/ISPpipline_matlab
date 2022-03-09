%图像的基本信息：
%512行，640列，像素深度16bit.
clc
clear all
close all

col=3840;
row=2160;
filename='bdns_in.raw16';
fid=fopen(filename,'r');
A=fread(fid,[col,row],'uint16');
A=A';
fclose(fid);

A2=A/16;
imshow(A2,[]);