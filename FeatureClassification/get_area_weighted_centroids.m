function new_centroids = get_area_weighted_centroids( cluster_table )
%count num members per cluster and isovalue sum per cluster

global AREA_TABLE;
global K;

new_centroids = zeros(K,1);
member_count= zeros(K,1);

for k = 1:K
    I = find(cluster_table==k);
    member_count(k) = sum(I);
    sum_area_k = sum(AREA_TABLE(I));
    AREA_TABLE(I) = AREA_TABLE(I) /sum_area_k;
    new_centroids(k) = sum(AREA_TABLE(I) .* I);
end