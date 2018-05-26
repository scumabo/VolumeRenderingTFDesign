function out_centroids = compute_new_centroids_areaw( cluster_table, K )
%compute new centroids instead of computing the mean, weight by surface area

out_centroids = get_area_weighted_centroids( cluster_table );

for k = 1:K
    new_centroid = out_centroids(k,1);
    
    %check if cluster has zero members
    if ( isnan(new_centroid) )
        new_centroid = get_new_cluster_centroid();
        out_centroids(k,1) = new_centroid;
    end
end

out_centroids = round_centroids( out_centroids );
out_centroids(:, 1) = validate_centroids( out_centroids(:,1));