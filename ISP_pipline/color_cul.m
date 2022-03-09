function mean=color_cul(img_r,img_g,img_b,patch)

mean_r=mean2(img_r(patch(2):patch(2)+70,patch(1):patch(1)+70));
mean_g=mean2(img_g(patch(2):patch(2)+70,patch(1):patch(1)+70));
mean_b=mean2(img_b(patch(2):patch(2)+70,patch(1):patch(1)+70));
mean=[mean_r,mean_g,mean_b];