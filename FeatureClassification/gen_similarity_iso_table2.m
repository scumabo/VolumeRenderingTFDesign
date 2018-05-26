function gen_similarity_iso_table2( volume, data_name, store_path_name )
%bla

clearvars -global OCTREE_SIMILARITY_STRUCT;

global OCTREE_SIMILARITY_STRUCT;

iso_max = max(volume(:));
[x, y ,z] = size(volume);

iso_similarity_octree_level(volume, x-1, y-1, z-1, iso_max, 1);

num_level = size((OCTREE_SIMILARITY_STRUCT), 2);

% sum up all level similarity tables
% linear weight method
level_sum = 0;
for i = 1:num_level
    level_sum = level_sum + i;
end
similarity_table1 = (1/num_level) * OCTREE_SIMILARITY_STRUCT(1).simTable;
for i = 2:num_level
    tmp1 = i/level_sum;
    tmp2 = OCTREE_SIMILARITY_STRUCT(i).simTable;
    
    similarity_table1 = similarity_table1 + tmp1 * tmp2;
    file_name1 = sprintf('%s/%s_approx_isosim_linear.mat', store_path_name, data_name);
end
similarity_table1 = similarity_table1/max(max(similarity_table1(:)));
save(file_name1, 'similarity_table1');
csvwrite(sprintf('%s/%s_proposed.csv', store_path_name, data_name), 1-similarity_table1);

% % exponential method
% level_sum = 0;
% for i = 1:num_level
%     level_sum = level_sum + 2^(i-1);
% end
% similarity_table1 = (1/num_level) * OCTREE_SIMILARITY_STRUCT(1).simTable;
% for i = 2:num_level
%     similarity_table1 = similarity_table1 + (2^(i-1))/level_sum * OCTREE_SIMILARITY_STRUCT(i).simTable;
%     file_name2 = sprintf('%s/%s_approx_isosim_exp.mat', store_path_name, data_name);
% end
% 
% similarity_table1 = similarity_table1/max(max(similarity_table1(:)));
% save(file_name2, 'similarity_table1');
% 
% % power method
% level_sum = 0;
% for i = 1:num_level
%     level_sum = level_sum + i^2;
% end
% similarity_table1 = (1/num_level) * OCTREE_SIMILARITY_STRUCT(1).simTable;
% for i = 2:num_level
%     similarity_table1 = similarity_table1 + ((i-1)^2)/level_sum * OCTREE_SIMILARITY_STRUCT(i).simTable;
%     file_name3 = sprintf('%s/%s_approx_isosim_power.mat', store_path_name, data_name);
% end
% similarity_table1 = similarity_table1/max(max(similarity_table1(:)));
% save(file_name3, 'similarity_table1');
