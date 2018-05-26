function demo2D(dataset, out_dir)

    close all; clc;
    
    addpath('./data/2D')
    addpath('./Helper')
    output_path = out_dir
    
    % Name of the source volume: 'tooth.raw' or 'bonsai.raw'
    data_name = dataset;
    
    % Read Raw Volume
    [raw_volume, I1, I2, I3, S1, S2, S3] = readRawVolume(data_name);
    
    % Compute the gradient magnitude volume
    [fx, fy, fz] = gradient(raw_volume, S1, S2, S3);
    raw_gradient = (fx.^2 + fy.^2 + fz.^2).^(1/2);
    
    % Compute the hierarchical cell-oriented similarity maps
    if (strcmp(data_name, 'bonsai.raw'))
        % Use these thresholds to reproduce the similarity map in the paper for
        % bonsai dataset. Essentially, large isovalues and gradient magnitudes that
        % correspond to (almost) empty features are excluded to reduce
        % computation. Alternatively, one can also re-quantize the fields to lower
        % precisions (see Section 6 Discussion in the paper).
        %similarity_table = similarity_map2D(raw_volume, raw_gradient, true, 229, 100);
        similarity_table = similarity_map2D_loop(raw_volume, raw_gradient, true, 229, 100);
    else
        similarity_table = similarity_map2D(raw_volume, raw_gradient, true);
    end
    
    disp('=== Saving results ===')
    save(sprintf('%s/%s_similarity_table2D.mat', output_path, data_name), 'similarity_table', '-v7.3');
end