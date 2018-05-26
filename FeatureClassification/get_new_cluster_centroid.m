function centroid = get_new_cluster_centroid()
%returns new cluster centroid

global AREA_WEIGHTED;
global K;
global CENTROIDS;

if (AREA_WEIGHTED)
    rand_vec = get_rand_vector_area_weighted();
else
    rand_vec = get_rand_vector();
end

N = size(rand_vec,1);

centroid_exists = false;

for n = 1:N
    centroid = rand_vec(n);
    if (centroid >=1 )
        for k = 1:K
            exist_centroid = CENTROIDS(k,1);
            if (centroid == exist_centroid || centroid == 0 )
                centroid_exists = true;
            end
        end
        if (~centroid_exists)
            return
        end
    end
end