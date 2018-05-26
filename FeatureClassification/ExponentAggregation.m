function [LUT, num_level] = ExponentAggregation(octree_table)
num_level = size(octree_table, 1);
level_sum = 0;

for i = 1:num_level
    level_sum = level_sum + 2^i;
end

similarity_table = 2/level_sum * octree_table{1};
for i = 2:num_level
    weight = (2^i)/level_sum;
    cur_table = octree_table{i};
    similarity_table = similarity_table + weight * cur_table;
end

LUT = replaceNaNbyMax( similarity_table );

end


