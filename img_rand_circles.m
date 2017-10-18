function img_output = img_rand_circles(radius)

number_of_circles = 20;
img = false(1024);
rand_idxs_x = randi(size(img,1), number_of_circles, 1);
rand_idxs_y = randi(size(img,1), number_of_circles, 1);

% setting the idxs in the img
for i = 1:number_of_circles
    img(rand_idxs_x(i), rand_idxs_y(i)) = true;
end

img_output = imdilate(img, strel('sphere', radius));

end