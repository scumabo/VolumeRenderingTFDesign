function do_area_weighting()
%do area weighting of hd max

filename = '/blank0/data/clustering/hnut_lookup_table_hd_max_srate1_sym.csv'; 

lookup_table = csvread(filename);

filename2 = '/blank0/data/clustering/hnut_area_weights.csv';
area_weights = csvread(filename2);

N = size(lookup_table,1);

weights = zeros(N, 1);

for row=1:N
     idx = (row-1) / 0.25 + 1;
     weight = area_weights(2, idx);
     weights(row, 1) = weight;
     
    for col = row:1:N
        idx2 = (col-1) / 0.25 + 1;
        weight2 = area_weights(2, idx2);
        value = lookup_table(row,col);
        value = value * weight * weight2;
        lookup_table(row,col) = value;
        lookup_table(col,row) = value;
        
    end
end

max_val = max(max(lookup_table));
%lookup_table = lookup_table / max_val;


filename3 = '/blank0/data/clustering/hnut_lookup_table_hd_max_srate1_area_weighted.csv'; 
filename4 = '/blank0/data/clustering/hnut_area_weights2.csv';

csvwrite(filename3,lookup_table);
csvwrite(filename4,weights);

