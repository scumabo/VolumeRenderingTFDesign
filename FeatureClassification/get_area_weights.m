function area_table_weighted = get_area_weights( area_table )
% get area weights

%sum_area = sum(area_table);
%area_table_weighted = area_table / sum_area;

max_area = max(area_table);
area_table_weighted = area_table / max_area;