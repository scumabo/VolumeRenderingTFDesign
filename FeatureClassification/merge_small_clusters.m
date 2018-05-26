function member_stats = merge_small_clusters(centroids, cluster_table, lut, member_stats )
% merge clusters with small isosurfaces

global AREA;

areas_centroids = AREA(centroids);
area_thresh = max(AREA) * 0.01;
small_labels = find(areas_centroids < area_thresh);
labels_at_centroids = cluster_table(centroids);
small_labels = labels_at_centroids(small_labels);

K = max(size(centroids, 1), size(centroids,2));
n_small_labels = max(size(small_labels,1), size(small_labels,2));
n_new_centroids = K - n_small_labels +1;

if ( n_small_labels > 1 )
    for i = 1:n_small_labels
        cluster_table(cluster_table == small_labels(i)) = min(small_labels);
    end
   
   del_min_idx = find(small_labels==min(small_labels));
   small_labels(del_min_idx) = [];
   counter = 1;
   while (max(cluster_table) > n_new_centroids)
       idx = find(cluster_table == max(cluster_table));
       cluster_table(idx) = small_labels(counter);
       counter = counter + 1;
   end
    
    % compute some statistics about current cluster configuration
    member_stats = do_cluster_stats( cluster_table, lut, n_new_centroids );
        
    % update cluster centroids
    member_stats(:,1) = compute_new_centroids( member_stats, n_new_centroids );
end