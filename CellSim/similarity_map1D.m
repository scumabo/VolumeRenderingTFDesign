function octree_maps = similarity_map1D(volume, enable_hierarchy)
% Compute the heirarchical cell-oriented isosurface similarity maps [1], a fast
% alternative to the Hausdorff distance and the ISM [2] for comparing similarities
% of isosurfaces. 
%
%    octree_maps = sim_map1D(volume, enable_hierarchy)
%
%    volume: raw volumetric data.
%    enable_hierarchy: If true, then compute hierarchical similarity maps.
%                      If false, then compute the similarity map use the 
%                      underlying grid structure (i.e., single level).
%    octree_maps: return the similarity maps at various octree levels.
%
%    References
%    -------
%    [1] Ma, B.; Entezari, A.; Volumetric Feature-Based Classification and Visibility Analysis for Transfer Function Design, 
%        IEEE Transactions on Visualization and Computer Graphics (TVCG), to appear.
%    [2] Stefan Bruckner and Torsten Muller. 2010. Isosurface similarity maps. 
%        EuroVis'10, DOI=http://dx.doi.org/10.1111/j.1467-8659.2009.01689.x

octree_maps = {};

if enable_hierarchy
    cell_size = size(volume) - 1;
else
    cell_size = [1, 1, 1];
end

[num_iso, num_cell, I1, I2, I3, intensity_min, intensity_max] = vol_statistics(volume);

% This while loop iteratively compute the similarity map for each cell_size.
while cell_size(1) >= 1 && cell_size(2) >= 1 && cell_size(3) >= 1
    cell_size = max(ceil(cell_size), 1);
    
    % Initial configurations: cell_size = 1.
    n_hyper_cell = num_cell;               % Number of hyper cells
    hyper_min = intensity_min;             % Min hyper cell volume
    hyper_max = intensity_max;             % Max hyper cell volume
    
    % Update configurations based on the current cell_size.
    if cell_size(1) > 1 || cell_size(2) > 1 || cell_size(3) > 1
        hyper_cell_indices = {1:cell_size(1):I1-1, 1:cell_size(2):I2-1, 1:cell_size(3):I3-1 };
        [X,Y,Z] = meshgrid(hyper_cell_indices{1, :});
        ind_start = [X(:) Y(:) Z(:)];
        ind_end = [min(I1, X(:)+cell_size(1)) min(I2, Y(:)+cell_size(2)) min(I3, Z(:)+cell_size(3))]-1;
        
        n_hyper_cell = size(ind_start, 1);
        hyper_min = zeros(n_hyper_cell, 1);
        hyper_max = zeros(n_hyper_cell, 1);
        
        % Loop though all the hyper cells and construct Min/Max hyper cell volume
        for i = 1:n_hyper_cell
            min_hyper_cell = intensity_min(ind_start(i, 1):ind_end(i,1), ind_start(i, 2):ind_end(i,2), ind_start(i, 3):ind_end(i,3));
            max_hyper_cell = intensity_max(ind_start(i, 1):ind_end(i,1), ind_start(i, 2):ind_end(i,2), ind_start(i, 3):ind_end(i,3));
            hyper_min(i) = min(min_hyper_cell(:));
            hyper_max(i) = max(max_hyper_cell(:));
        end
    end
    
    % Each column of F is a CellSet for an isovalue. 
    % The computation of similarity maps excludes background (i.e., isovalue
    % = 0).
    F = zeros(n_hyper_cell, num_iso, 'single');
    
    for i = 1 : num_iso
        % Default (simple isosurface cell intersection)
        F(hyper_min < i & hyper_max > i, i) = 1;
        
        % Uncomment the following code to enable Boundary cells and Homogeneous cells
        % and gradient weighted CellSets (See Section 6 Discussion in the paper)
        %         cross_cell_indices = find(hyper_min < i & hyper_max > i);
        %         cell_span = double(hyper_max - hyper_min);
        %         boundary_cell_indices = find((hyper_min == i & hyper_max ~= i) | (hyper_min ~= i & hyper_max == i));
        %         homogeneous_cell_indices = find(hyper_min == i & hyper_max == i);
        %         F(cross_cell_indices, i) = sqrt(1./cell_span(cross_cell_indices));
        %         F(boundary_cell_indices,i) = 0.5./cell_span(boundary_cell_indices);
        %         F(homogeneous_cell_indices,i) = 1;
    end
    
    overlap_table = F' * F;
    num_cells_isosurface = diag(overlap_table)';
    hyper_similarity_table = bsxfun(@rdivide,overlap_table, num_cells_isosurface);
    
    octree_maps = [octree_maps; {hyper_similarity_table}];
    
    % Reduce cell size by factor of 2
    cell_size = cell_size / 2;
end
end

% helper
function [num_iso, num_cell, I1, I2, I3, intensity_min, intensity_max] = vol_statistics(volume)
num_iso = max(volume(:));
[I1, I2, I3] = size(volume);
num_cell = (I1-1)*(I2-1)*(I3-1);
[intensity_min, intensity_max] = getCellsMinMax(volume);
end