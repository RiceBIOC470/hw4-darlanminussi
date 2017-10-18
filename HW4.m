%HW4 Darlan Conterno Minussi
%% 
% Problem 1. 

% 1. Write a function to generate an 8-bit image of size 1024x1024 with a random value 
% of the intensity in each pixel. Call your image rand8bit.tif. 

create_random_img(1024, 1024);

% 2. Write a function that takes an integer value as input and outputs a
% 1024x1024 binary image mask containing 20 circles of that size in random
% locations

img_circ = img_rand_circles(20);
imshow(img_circ);

% 3. Write a function that takes the image from (1) and the binary mask
% from (2) and returns a vector of mean intensities of each circle (hint: use regionprops).

intensity_m = intensity_circles('rand8bit.tif', img_circ);
intensity_m_v = [intensity_m.MeanIntensity];
disp(intensity_m_v);

%
% 4. Plot the mean and standard deviation of the values in your output
% vector as a function of circle size. Explain your results. 

img_cell = {};

for i = 1:40
    img_cell{i} = img_rand_circles(i);
end

intensities = {};
intensities_values = {};

for i = 1:40
    intensities{i} = intensity_circles('rand8bit.tif', img_cell{i});
    intensities_values{i} = extractfield(intensities{i},'MeanIntensity');
end

means = cellfun(@mean, intensities_values);
sds = cellfun(@std, intensities_values);

scatter(1:40, sds);
xlabel('Radius')
ylabel('Standard Deviations')

% the standard deviations show an inverse relationship with the radius of
% the circle because the bigger the diameter of the circle better is the
% measurement of the intensity of the pixels

scatter(1:40, means);
xlabel('Radius')
ylabel('Mean')

% the mean intensity shows that the means are stable around 190 after the radius gets
% to 15

%%

%Problem 2. Here is some data showing an NFKB reporter in ovarian cancer
%cells. 
%https://www.dropbox.com/sh/2dnyzq8800npke8/AABoG3TI6v7yTcL_bOnKTzyja?dl=0
%There are two files, each of which have multiple timepoints, z
%slices and channels. One channel marks the cell nuclei and the other
%contains the reporter which moves into the nucleus when the pathway is
%active. 
%

%Part 1. Use Fiji to import both data files, take maximum intensity
%projections in the z direction, concatentate the files, display both
%channels together with appropriate look up tables, and save the result as
%a movie in .avi format. Put comments in this file explaining the commands
%you used and save your .avi file in your repository (low quality ok for
%space). 

% Fiji - file - open - nfkb_movie1.tif
% open a second file of the same image
% Image -stack - z Projects - max to both images
% Image - color - Merge Channels
% Image - lookup tables - Green/Red
% file - save as - avi

%Part 2. Perform the same operations as in part 1 but use MATLAB code. You don't
%need to save the result in your repository, just the code that produces
%it. 

chan = 1;

reader1 = bfGetReader('nfkb_movie1.tif');
zplane1 = reader1.getSizeZ;

reader2 = bfGetReader('nfkb_movie2.tif');
zplane2 = reader2.getSizeZ;

% image nfkb_movie1

v1 = VideoWriter('img_1_matlabavi.avi');
open(v1);
for ii = 1:reader1.getSizeT
    iplane_img1 = reader1.getIndex(zplane1-1, 1-1, ii-1)+1;
    temp_img1 = bfGetPlane(reader1,iplane_img1);
    temp_img1 = max(temp_img1, [], 3); 
    iplane_img2 = reader1.getIndex(zplane1-1, 2-1, ii-1)+1;
    temp_img2 = bfGetPlane(reader1,iplane_img2);
    temp_img2 = max(temp_img2, [], 3);
stack = cat(3, imadjust(temp_img1), imadjust(temp_img2), zeros(size(temp_img1)));
    stack_bright = im2double(stack);
imwrite(stack_bright , 'q2_2_img1.tif' , 'WriteMode' , 'append');
writeVideo(v1,stack_bright);
end
close(v1);


% image nfkb_movie2

v = VideoWriter('img_2_matlabavi.avi');
open(v);
for ii = 1:reader2.getSizeT
    iplane_img1 = reader2.getIndex(zplane1-1, 1-1, ii-1)+1;
    temp_img1 = bfGetPlane(reader2,iplane_img1);
    temp_img1 = max(temp_img1, [], 3); 
    iplane_img2 = reader2.getIndex(zplane1-1, 2-1, ii-1)+1;
    temp_img2 = bfGetPlane(reader2,iplane_img2);
    temp_img2 = max(temp_img2, [], 3);
stack = cat(3, imadjust(temp_img1), imadjust(temp_img2), zeros(size(temp_img1)));
stack_bright2 = im2double(stack);
imwrite(stack_bright2 , 'q2_2_img2.tif' , 'WriteMode' , 'append') ;
 writeVideo(v,stack_bright2);
end
close(v);


%%

% Problem 3. 
% Continue with the data from part 2
% 
% 1. Use your MATLAB code from Problem 2, Part 2  to generate a maximum
% intensity projection image of the first channel of the first time point
% of movie 1. 

reader1 = bfGetReader('nfkb_movie1.tif');
reader1.getSizeT;
time = 1;
zplane = 1;
chan = 1;

iplane_img1_t1 = reader1.getIndex(zplane-1, chan-1, time-1)+1;

img_q3 = bfGetPlane(reader1,iplane_img1_t1);
img_q3_m = max(img_q3, [], 3); 
imshow(img_q3_m,[]);

% 2. Write a function which performs smoothing and background subtraction
% on an image and apply it to the image from (1). Any necessary parameters
% (e.g. smoothing radius) should be inputs to the function. Choose them
% appropriately when calling the function.

% smooth_and_subtract(img, gaussian_val, disk_val)

img_q3_bg = smooth_and_subtract(img_q3_m, 4.2, 50);
imshow(img_q3_bg, []);


% 3. Write  a function which automatically determines a threshold  and
% thresholds an image to make a binary mask. Apply this to your output
% image from 2. 

% img_mask = binary_mask(img)

img_mask = binary_mask(img_q3_bg);
imshow(img_mask);

% 4. Write a function that "cleans up" this binary mask - i.e. no small
% dots, or holes in nuclei. It should line up as closely as possible with
% what you perceive to be the nuclei in your image.

% nuclei_def(img, disk_size)

img_def = nuclei_def(img_mask, 7);
imshow(img_def);

% 5. Write a function that uses your image from (2) and your mask from 
% (4) to get a. the number of cells in the image. b. the mean area of the
% cells, and c. the mean intensity of the cells in channel 1. 

% [mean_int, areas, num_elem] = nuclei_props(img, img_mask)

[mean_int, areas, num_elem] = nuclei_props(img_q3_bg, img_def);
disp(['The number of nuclei in the image is: ' num2str(num_elem)]);
disp(['Their mean area is: ' num2str(areas)]);
disp(['Their mean intensity is: ' num2str(mean_int) ]);

% 6. Apply your function from (2) to make a smoothed, background subtracted
% image from channel 2 that corresponds to the image we have been using
% from channel 1 (that is the max intensity projection from the same time point). Apply your
% function from 5 to get the mean intensity of the cells in this channel.

reader2 = bfGetReader('nfkb_movie1.tif');
reader2.getSizeT;
timer2 = 1;
zplaner2 = 1;
chanr2 = 2;

iplane_img2_t1 = reader2.getIndex(zplaner2-1, chanr2-1, timer2-1)+1;

img_q3_6 = bfGetPlane(reader2,iplane_img2_t1);
img_q3_m_6 = max(img_q3_6, [], 3); 
imshow(img_q3_m_6,[])

img_q3_bg_6 = smooth_and_subtract(img_q3_m_6, 20, 100);
imshow(img_q3_bg_6, []);

img_mask_6 = binary_mask(img_q3_bg_6);
imshow(img_mask_6);

[mean_int2, areas2, num_elem2] = nuclei_props(img_q3_6, img_mask_6);

disp(['Their mean intensity is: ' num2str(mean_int2) ]);

%%
% Problem 4. 

% 1. Write a loop that calls your functions from Problem 3 to produce binary masks
% for every time point in the two movies. Save a movie of the binary masks.


% movie 1
reader1 = bfGetReader('nfkb_movie1.tif');
reader1.getSizeT;
time = 1;
zplane = 1;
chan = 1;


v3 = VideoWriter('img_1_matlabavi_q4.avi');
open(v3);
for k = 1:reader1.getSizeT
    iplane_img1 = reader1.getIndex(1-1, chan-1, k-1)+1;
    temp_img1 = bfGetPlane(reader1,iplane_img1);
    img_bg = smooth_and_subtract(temp_img1, 4.2, 100);
    img_mask = binary_mask(img_bg);
    
    img_def = nuclei_def(img_mask, 7);
    img_def_d = im2double(img_def);
imwrite(img_def_d , 'q4_1_img1.tif' , 'WriteMode' , 'append') ;
 writeVideo(v3,img_def_d);
end
close(v3);

% movie 2
reader2 = bfGetReader('nfkb_movie2.tif');
reader2.getSizeT;
time = 1;
zplane = 1;
chan = 1;


v4 = VideoWriter('img_2_matlabavi_q4.avi');
open(v4);
for k = 1:reader2.getSizeT
    iplane_img2 = reader2.getIndex(1-1, chan-1, k-1)+1;
    temp_img2 = bfGetPlane(reader2,iplane_img2);
    img_bg = smooth_and_subtract(temp_img2, 4.2, 100);
    img_mask = binary_mask(img_bg);
    img_def2 = nuclei_def(img_mask, 7);
    img_def_d2 = im2double(img_def2);
    imwrite(img_def_d2 , 'q4_1_img2.tif' , 'WriteMode' , 'append') ;
 writeVideo(v4,img_def_d2);
end
close(v4);


% 2. Use a loop to call your function from problem 3, part 5 on each one of
% these masks and the corresponding images and 
% get the number of cells and the mean intensities in both
% channels as a function of time. Make plots of these with time on the
% x-axis and either number of cells or intensity on the y-axis. 
mean_int_q4_2_i1 = {};
areasq4_2_i1 = {};
num_elem_q4_2_i1 = {};

for zz = 1:reader1.getSizeT
iplane_img1 = reader1.getIndex(1-1, chan-1, zz-1)+1;
    temp_img1 = bfGetPlane(reader1,iplane_img1);
    img_bg = smooth_and_subtract(temp_img1, 4.2, 100);
    img_mask = binary_mask(img_bg);
    img_def = nuclei_def(img_mask, 7);
    img_def_d = im2double(img_def);
    [mean_int_q4_2_i1{zz} areasq4_2_i1{zz} num_elem_q4_2_i1{zz}] = nuclei_props(img, img_def);
end

num_i1 = [];
num_i1 = cell2mat(num_elem_q4_2_i1);

meani_i1 = cellfun(@mean, mean_int_q4_2_i1);

scatter(1:reader1.getSizeT, num_i1);
xlabel('Time');
ylabel('Number of cells');

scatter(1:reader1.getSizeT, meani_i1);
xlabel('Time');
ylabel('Mean Intensities of all cells');

% movie 2
mean_int_q4_2_i2 = {};
areasq4_2_i2 = {};
num_elem_q4_2_i2 = {};

for qq = 1:reader2.getSizeT
iplane_img1 = reader2.getIndex(1-1, chan-1, qq-1)+1;
    temp_img1 = bfGetPlane(reader2,iplane_img1);
    img_bg = smooth_and_subtract(temp_img1, 4.2, 100);
    img_mask = binary_mask(img_bg);
    img_def = nuclei_def(img_mask, 7);
    img_def_d = im2double(img_def);
    [mean_int_q4_2_i2{qq} areasq4_2_i2{qq} num_elem_q4_2_i2{qq}] = nuclei_props(img, img_def);
end

num_i2 = [];
num_i2 = cell2mat(num_elem_q4_2_i2);

meani_i2 = cellfun(@mean, mean_int_q4_2_i2);

scatter(1:reader2.getSizeT, num_i2);
xlabel('Time');
ylabel('Number of cells');

scatter(1:reader2.getSizeT, meani_i2);
xlabel('Time');
ylabel('Mean Intensities of all cells');



