function [mean_int, areas, num_elem] = nuclei_props(img, img_mask)

% mean intensity
mean_int_s = regionprops(img_mask, img, 'MeanIntensity');
mean_int = [mean_int_s.MeanIntensity];


%mean area
cell_area = regionprops(img_mask, 'Area');
ids = find([cell_area.Area] > 100);

areas = [];
for i = 1:numel(ids)
    areas(i) = mean(cell_area(ids(i)).Area);
end

% numel nuclei
num_elem = numel(ids);


end