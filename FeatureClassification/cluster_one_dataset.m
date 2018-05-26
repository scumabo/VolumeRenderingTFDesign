function [isos, lut, member_stats2] = cluster_one_dataset( data_name )
%does clustering for one dataset and produces clustering images

global LAMBDA;
global ISO_OFFSET;
global ISOS;
global CLUSTER_TABLE;
global S_RATE;
S_RATE = 1;

[hd_mean_table, hd_max_table, I_thres, I_area, area] = load_mi_files( data_name );
ism_table = load_ism_table( data_name, area );

lut = hd_mean_table;
title = 'mean HD';

do_merging = true;
if (do_merging)
    isos1 = init_equal_clustering(size(lut,1), 20);
    [isos2, member_stats2] = mi_merging( lut, isos1, data_name );
    isos = I_thres(isos2);
    display_hd_map(lut, member_stats2, [], title, 0, data_name, isos' );
    
end

do_splitting = false;
if (do_splitting)
    [cluster_table, isos2, member_stats2] = mi_dpmeans( lut, hd_mean_table, hd_max_table, ism_table, data_name, LAMBDA, I_area );
    isos = I_thres(isos2);
   
    isos = isos + ISO_OFFSET;
    
    %test mean surfaces
    %mean_surface_test(cluster_table, lut, data_name);
    
    display_hd_map(lut, member_stats2, [], title, 0, data_name, isos' );impixelinfo;
%     display_isosurfaces(data_name, isos', 'representative isosurfaces');
    n_isos = size(isos,2);
    CLUSTER_TABLE = zeros(size(cluster_table,1), 1);
    for c=1:n_isos
        I = find(cluster_table==c);
        isosc = I_thres(I);
        CLUSTER_TABLE(isosc) = c;
%        display_isosurfaces(data_name, isosc', sprintf('cluster: %i - %i', min(isosc), max(isosc)));
    end

end

isos = sort(isos);
ISOS = isos;


