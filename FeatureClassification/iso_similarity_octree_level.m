function iso_similarity_octree_level(volume, step_x, step_y, step_z, iso_max, level)

% Octree based similarity struct
% each struct row is a level which contain corresponding simialrity table
global OCTREE_SIMILARITY_STRUCT;

isosurface_ocupy_numVox = zeros(1, iso_max-1);
overlap_table = zeros(iso_max-1);

[x, y ,z] = size(volume); % number of cubes along each direction of image

for i = 1:step_x+1:x   % foreach Hyper Cells
    for j = 1:step_y+1:y
        for k = 1:step_z+1:z
            % get the scalar values of the hyper cells
            vertices = volume(i:(i+step_x), j:(j+step_y), k:k+step_z);
            
            % get the min and max 
            min_value = min(vertices(:));
            max_value = max(vertices(:));
            
            
            % update Hyper cell contribution for each isosurface
            w = round(min_value);  % this is for handle float scalar field value
            if max_value ~= 0      % contribute sth
                if min_value == 0
                    w = 1;
                else
                    w = w - 1;             
                    while w <= min_value    % this means min< isovalue are considered
                        w = w + 1;         
                    end
                end
                overlap_start = w;
                overlap_range = -1;
                while w < max_value         % this means isovalue < max are considered
                    isosurface_ocupy_numVox(1, w) = isosurface_ocupy_numVox(1, w)+1;
                    overlap_range = overlap_range + 1;
                    w = w + 1;
                end
                overlap = overlap_start:(overlap_start+overlap_range);
                overlap_table(overlap, overlap) = overlap_table(overlap, overlap) + 1;
            end
            
        end
    end
end

similarity_table1 = bsxfun(@rdivide,overlap_table, isosurface_ocupy_numVox);
similarity_table2 = bsxfun(@rdivide,overlap_table', isosurface_ocupy_numVox);
similarity_table = min(similarity_table1, similarity_table2');

OCTREE_SIMILARITY_STRUCT(level).simTable = similarity_table;

if step_x ~= 1 && step_y ~= 1 && step_z ~= 1
    iso_similarity_octree_level(volume, x/(2^level)-1, y/(2^level)-1, z/(2^level)-1, iso_max, level+1);
end

