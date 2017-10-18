function img_out = nuclei_def(img, disk_size)

img_out = imopen(img, strel('disk', disk_size));

end