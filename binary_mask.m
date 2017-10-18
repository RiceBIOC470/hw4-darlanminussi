function img_mask = binary_mask(img)

img_quant = quantile(quantile(img, 0.9),0.9);
img_mask = img > img_quant;

end