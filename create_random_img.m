function img_output = create_random_img(image_x, image_y)

rand_img = double.empty;

img_output = uint8(randi(500, image_x, image_y));

imwrite(img_output, 'rand8bit.tif');

end
