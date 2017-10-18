function int_o = intensity_circles(img, mask);

img_i = imread(img);
int_o = regionprops(mask, img_i, 'MeanIntensity');

end