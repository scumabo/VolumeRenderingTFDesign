function exists = is_centroid(centroids, prev_centroid, k )
%% check if centroid value exists

num_centroids = size(centroids, 1);

exists = false;
for j = 1:num_centroids
    if (j ~= k)
        next_centroid = centroids(j,1);
        if (prev_centroid == next_centroid)
            exists = true;
            return
        end
    end
end