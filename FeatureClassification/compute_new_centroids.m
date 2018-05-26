function out_centroids = compute_new_centroids( member_stats, K )
%compute new centroids

out_centroids = member_stats(:,12); %member with shortes HD sum

% validate the centroids
for k = 1:K
    new_centroid = out_centroids(k,1);
    
    %check if cluster has zero/nan members
    if ( isnan(new_centroid) || new_centroid < 0 )
        new_centroid = get_new_cluster_centroid();
        out_centroids(k,1) = new_centroid;
    end
end
% Centroid only allow integer: integer sampling rate
out_centroids = round_centroids( out_centroids);
out_centroids(:, 1) = validate_centroids( out_centroids(:,1) );
