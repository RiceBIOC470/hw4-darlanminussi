function img_bgsub = smooth_and_subtract(img, gaussian_val, disk_val)

img_sm = imfilter(img, fspecial('gaussian',4,2));
img_bg = imopen(img_sm, strel('disk',100));
img_bgsub = imsubtract(img_sm, img_bg);

end