function similarity_table = linear_aggregation(octree_maps)
num_level = size(octree_maps, 1);
x = 1:num_level;
xsums = cumsum(x);
level_sum = xsums(end);

similarity_table = 0;
for i = 1 : num_level
    similarity_table = similarity_table + i/level_sum * octree_maps{i};
end

% Make it symmetry
similarity_table = min(similarity_table, similarity_table');