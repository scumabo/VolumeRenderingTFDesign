function centroids = validate_centroids( centroids )
%returns new cluster centroid

global AREA_WEIGHTED;
global MAX_ISO;
global N_ISOS;

if (AREA_WEIGHTED)
    rand_vec = get_rand_vector_area_weighted();
else
    rand_vec = get_rand_vector();
end
num_centroids = size(centroids, 1);
for k = 1:num_centroids
    new_centroid = centroids(k,1);
    n = 1;
    while ( (is_centroid(centroids, new_centroid, k ) || new_centroid < 1 || new_centroid > MAX_ISO ))
        if (n > N_ISOS)
            if (AREA_WEIGHTED)
                rand_vec = get_rand_vector_area_weighted();
            else
                rand_vec = get_rand_vector();
            end
            n = 1;
        end
        new_centroid = rand_vec(n);
        n = n+1;
    end
    
    centroids(k,1) = new_centroid;
end

centroids = round_centroids(centroids);