function [a_mean, a_max, I, I_area, a_area1] = load_mi_files( data_name )
%loads related files

global MAX_ISO;
global MIN_AREA_THRESH;
global NUM_ISOS;


[a_mean, a_max, a_area1] = load_mi_files_no_area_thresh( data_name );

n_isos = size(a_area1,2);

% make area-diff table
a_area = zeros(n_isos, n_isos);

for col = 1:n_isos
    for row = 1:n_isos
        a1 = a_area1(col);
        a2 = a_area1(row);
        a_diff = abs(a1-a2);
        a_area(row, col) = a_diff;
    end
end

%figure, imshow(a_area, []);colormap(cb_PuOr);
%a_area = a_area(I_a,I_a);
%figure, imshow(a_area, []);colormap(cb_PuOr);
%figure, imshow(a_mean, []);colormap(cb_PuOr);
%a_mean = a_mean(I_a,I_a);
%figure, imshow(a_mean, []);colormap(cb_PuOr);

%indices that are skipped to do mapping to isovalues
% if ( MIN_AREA_THRESH < 1 )
%     MIN_AREA_THRESH = 1;
% end

I = find(a_area1>=MIN_AREA_THRESH);
NUM_ISOS = size(I,2);

a_mean = a_mean(I,I);
a_max = a_max(I,I);

a_area = a_area(I,I);
a_area1 = a_area1(I);

% do area sorting
[a_area2,I_area] = sort(a_area1,2, 'descend');
%figure, plot(a_area1);
%figure, plot(a_area2);

MAX_ISO = size(a_mean,1);

