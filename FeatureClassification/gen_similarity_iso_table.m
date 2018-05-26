function gen_similarity_iso_table(volume)

isosurface_ocupy_numVox = zeros(1, 255);
overlap_table = zeros(255);

[x, y ,z] = size(volume); % number of cubes along each direction of image
x = x - 1;
y = y - 1;
z = z - 1;
test = zeros(255, 255, 255);
for i = 1:x   % foreach cube grid
    for j = 1:y
        for k = 1:z
            % get the scalar value at 8 vertices
            vertex = [volume(i, j, k); volume(i+1, j, k); volume(i+1, j+1, k);
                volume(i, j+1, k); volume(i, j, k+1); volume(i, j+1, k+1);
                volume(i+1, j, k+1); volume(i+1, j+1, k+1)];
            
            % get the min and max 
            min_value = min(vertex);
            max_value = max(vertex);
            
            if min_value < 255 && max_value > 255
                test(i,j,k) = 80;
            end
            
            % update voxel contribution for each isosurface
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

showVolume(test,'test');


