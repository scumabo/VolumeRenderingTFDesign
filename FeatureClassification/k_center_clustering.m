function [centers, member_stats, cluster_table] = k_center_clustering( lut, num_clusters, axis_handle )

global KMEANS_DO_MERGING;

global AREA_WEIGHTED_CENTROIDS;
global AREA_WEIGHTED;
global RAND_INIT;
global S_RATE;
global MAX_ISO;
global N_ISOS;
global CENTROIDS;
global MAX_NUM_CLUSTERS;
global CSVOBJ;
global K;
global DO_CLUSTERING_VIDEO;

RAND_INIT = false;
S_RATE = 1;
AREA_WEIGHTED = false;
AREA_WEIGHTED_CENTROIDS = false;
MAX_ISO = size(lut,1);
N_ISOS = isov2idx(MAX_ISO);
CSVOBJ = [];

% Initialize K if not specified
if (num_clusters > 0)
    K = num_clusters;
else
    K = 10;
end

%% read lookup table
centers = zeros(K, 1);

% Randomly pick the first center
centers(1) = round( N_ISOS * rand(1) );

% Initialize distance table and cluster_table
distance_table = lut(centers(1), :);
cluster_table = ones(N_ISOS, 1);

for i = 2:K
    farthest_point = find(distance_table == max(distance_table))
    
    centers(i) = farthest_point;
    
    distance_to_new_center = lut(centers(i), :);
    
    for j=1:N_ISOS
        if(distance_table(j) > distance_to_new_center(j))
            distance_table(j) = distance_to_new_center(j);
            cluster_table(j) = i;
        end
    end
    
end


member_stats(:, 1) = centers;
member_stats(:, 2) = centers;
member_stats(:, 3) = centers;
member_stats(:, 4) = centers;
member_stats(:, 5) = centers;
member_stats(:, 6) = centers;
member_stats(:, 7) = centers;
member_stats(:, 8) = centers;

