function demo1D(dataset, out_dir)

    close all; clc;
    
    addpath('./data/1D')
    addpath('./Helper')
    output_path = out_dir
    
    % Name of the source volume: 'manix.raw', 'fuel.raw', or 'turbulent_combustion.raw'
    data_name = dataset;
    
    % Read raw volume
    [raw_volume, I1, I2, I3, S1, S2, S3] = readRawVolume(data_name);
    
    tic
    % Compute the hierarchical cell-oriented similarity maps
    octree_maps = similarity_map1D(raw_volume, true);
    
    % Aggregate the similarity maps across all levels
    similarity_table = linear_aggregation(octree_maps);
    toc
    
    load ./data/cb_YIOrBr2.mat 
    h = imshow(1-similarity_table,[]); colormap(cb_YIOrBr2); 
    hcb = colorbar();
    set(get(hcb,'xlabel'),'String', 'Cell-oriented isosurface similarity map', 'fontsize', 20); 
    axis on
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    
    saveas(gcf, fullfile(output_path, 'similarity_map.png'));
    save(sprintf('%s/%s_similarity_table1D.mat', output_path, data_name), 'similarity_table');
    save(sprintf('%s/%s_octree_maps1D.mat', output_path, data_name), 'octree_maps');
end