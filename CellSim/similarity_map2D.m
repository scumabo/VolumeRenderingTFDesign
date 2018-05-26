function similarity_table = similarity_map2D(volume, volume_gradient, enable_hierarchy, thresh_intensity, thresh_gradient)
% A 2D (intensity-gradient magnitude) version of the heirarchical cell-oriented 
% feature similarity maps[1].
%
%    similarity_table = similarity_map2D(volume, volume_gradient, enable_hierarchy, thresh_intensity, thresh_gradient)
%
%    volume: raw intensity field.
%    volume_gradient: raw gradient magnitude field.
%    enable_heirarchy: If true, then compute hierarchical similarity maps.
%                      If false, then compute the similarity map use the 
%                      underlying grid structure (i.e., single level).
%    (optional) thresh_intensity, thresh_gradient: upper threshholds for
%    itensity and gradient magnitude.
%    similarity_table: return the aggregated similarity maps.
%
%    References
%    -------
%    [1] Ma, B.; Entezari, A.; Volumetric Feature-Based Classification and Visibility Analysis for Transfer Function Design, 
%        IEEE Transactions on Visualization and Computer Graphics (TVCG), to appear.

if ~exist('thresh_intensity', 'var')
    thresh_intensity = 0;
end
if ~exist('thresh_gradient', 'var')
    thresh_gradient = 0;
end

similarity_table = 0;
cell_size = [1, 1, 1];
level_sum = 1;

if enable_hierarchy
    cell_size = size(volume) - 1;
    [octree_level, level_sum] = get_octree_level(cell_size);
end

[num_iso, num_gradient, num_cell, I1, I2, I3, ...
    intensity_min, intensity_max, gradient_min, gradient_max] = vol_gradient_statistics(volume, volume_gradient, thresh_intensity, thresh_gradient);

% This while loop iteratively compute the similarity map for each cell_size.
lvl = 1;
while cell_size(1) >= 1 && cell_size(2) >= 1 && cell_size(3) >= 1
    disp(sprintf('============= Processing octree level %d =============', lvl))
    cell_size = max(ceil(cell_size), 1);
    
    % Initial configurations: cell_size = 1.
    n_hyper_cell = num_cell;                  % Number of hyper cells
    intensity_hyper_min = intensity_min(:);   % Min intensity hyper cell volume
    intensity_hyper_max = intensity_max(:);   % Max intensity hyper cell volume
    gradient_hyper_min  = gradient_min(:);    % Min gradient magnitude hyper cell volume
    gradient_hyper_max  = gradient_max(:);    % Max gradient magnitude hyper cell volume
    
    % Update configurations based on the current cell_size.
    if cell_size(1) > 1 || cell_size(2) > 1 || cell_size(3) > 1
        hyper_cell_indices = {1:cell_size(1):I1-1, 1:cell_size(2):I2-1, 1:cell_size(3):I3-1 };
        [X,Y,Z] = meshgrid(hyper_cell_indices{1, :});
        ind_start = [X(:) Y(:) Z(:)];
        ind_end = [min(I1, X(:)+cell_size(1)) min(I2, Y(:)+cell_size(2)) min(I3, Z(:)+cell_size(3))]-1;
        
        n_hyper_cell = size(ind_start, 1);
        intensity_hyper_min = zeros(n_hyper_cell, 1);
        intensity_hyper_max = zeros(n_hyper_cell, 1);
        gradient_hyper_min  = zeros(n_hyper_cell, 1);
        gradient_hyper_max  = zeros(n_hyper_cell, 1);
        
        % Loop though all the hyper cells and construct Min/Max hyper
        % cell volume
        for i = 1:n_hyper_cell
            min_intensity_hyper_cell = intensity_min(ind_start(i, 1):ind_end(i,1), ind_start(i, 2):ind_end(i,2), ind_start(i, 3):ind_end(i,3));
            max_intensity_hyper_cell = intensity_max(ind_start(i, 1):ind_end(i,1), ind_start(i, 2):ind_end(i,2), ind_start(i, 3):ind_end(i,3));
            min_gradient_hyper_cell  = gradient_min(ind_start(i, 1):ind_end(i,1), ind_start(i, 2):ind_end(i,2), ind_start(i, 3):ind_end(i,3));
            max_gradient_hyper_cell  = gradient_max(ind_start(i, 1):ind_end(i,1), ind_start(i, 2):ind_end(i,2), ind_start(i, 3):ind_end(i,3));
            
            intensity_hyper_min(i) = min(min_intensity_hyper_cell(:));
            intensity_hyper_max(i) = max(max_intensity_hyper_cell(:));
            gradient_hyper_min(i)  = min(min_gradient_hyper_cell(:));
            gradient_hyper_max(i)  = max(max_gradient_hyper_cell(:));
        end
    end
    
    % Each column of F is a CellSet for an isovalue-gradient magnitude pair.
    % F is a large and sparse matrix at high octree levels.
    disp('Computing sparse F')
    index_row = [];
    index_column = [];
    tic
    for i = 1 : num_iso
        for j = 1 : num_gradient
            overlap_index = find(intensity_hyper_min < i & intensity_hyper_max > i & gradient_hyper_min < j & gradient_hyper_max > j);
            index_row = [index_row overlap_index'];
            index_column = [index_column ((i-1)*num_gradient+j)*ones(1, size(overlap_index,1))];
        end
    end
    toc
    values = ones(1, size(index_column, 2));
    F = sparse(index_row, index_column, values, n_hyper_cell, num_iso * num_gradient);
    clear index_row;
    clear index_column;
    clear values;
 
    disp('Computing overlap table')
    tic
    overlap_table = full(F' * F);
    toc
    num_cells_fibersurface = full(sum(F, 1));
    
    tic
    disp('Normalizing and aggregating the similarity table')
    overlap_table = bsxfun(@rdivide,overlap_table, num_cells_fibersurface);
    similarity_table = similarity_table + lvl/level_sum * overlap_table;
    toc
    
    clear overlap_table;
    clear F;
    clear num_cells_fibersurface;
    
    % Reduce cell size by factor of 2
    cell_size = cell_size / 2;
    lvl = lvl + 1;
end

similarity_table = min(similarity_table, similarity_table');
end

% helper
function [num_iso, num_gradient, num_cell, I1, I2, I3, intensity_min, intensity_max, gradient_min, gradient_max] = vol_gradient_statistics(volume, volume_gradient, thresh_intensity, thresh_gradient)
% Re-quantize the data if needed to reduce computation time (see Section 6 Discussion)
%volume = quantize(volume, 7);
%volume_gradient = quantize(volume_gradient, 7);

num_iso = floor(max(volume(:))) - 1;
num_gradient = floor(max(volume_gradient(:))) - 1;

%Threshhold (if specified)
if thresh_intensity ~= 0
    num_iso = thresh_intensity;
end
if thresh_gradient ~= 0
    num_gradient = thresh_gradient;
end

[I1, I2, I3] = size(volume);
num_cell = (I1-1)*(I2-1)*(I3-1);
[intensity_min, intensity_max] = getCellsMinMax(volume);
[gradient_min, gradient_max]   = getCellsMinMax(volume_gradient);
end

function [octree_level, level_sum] = get_octree_level(cell_size)
octree_level = ceil(log2(max(cell_size(:)+1))) + 1;
x = 1:octree_level;
xsums = cumsum(x);
level_sum = xsums(end);
end
