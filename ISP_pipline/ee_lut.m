function pixel_out = ee_lut(pixel_in,thres1,thres2,gain1,gain2)

if abs(pixel_in)>thres2
    pixel_out = pixel_in*gain2;
    if pixel_out>255
       pixel_out=255;
    end
end
if abs(pixel_in)<thres2 && abs(pixel_in)>thres1
    pixel_out = pixel_in*gain1;
    if pixel_out>255
       pixel_out=255;
    end
end
if abs(pixel_in)<thres1
    pixel_out = 0;
end