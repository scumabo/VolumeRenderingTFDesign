function is_merge = merge_clusters( member_stats, lookup_table )
%merges clusters on defined conditions

global K;
global CENTROIDS;
global MERGE_HAPPY_THRESH;
global DO_EXACT_NUM_CLUSTERS;
global IS_SYMMETRIC;
global NUM_CLUSTERS;

is_merge = false;
max_hd = max(max(lookup_table));
hd_distances_centroids = ones(K);
hd_distances_centroids = hd_distances_centroids * max_hd;

%FIXME: do asymmetric
for k = 1:K
    centroid_k = CENTROIDS(k);
    for j = (k+1):K
        centroid_j = CENTROIDS(j);
        dist1 = lookup_table(centroid_k, centroid_j);
        hd_distances_centroids(k,j) = dist1;
        if (~IS_SYMMETRIC)
            dist2 = lookup_table(centroid_j, centroid_k);
            hd_distances_centroids(j,k) = dist2;
        end
    end
end

min_cols = min(hd_distances_centroids);
min_rows = min(hd_distances_centroids');

col = find(min_cols == min(min_cols));
row = find(min_rows == min(min_rows));

% in case there are multiple min cols, min rows
col = col(1,1);
row = row(1,1);

centroid1 =  member_stats(col,1);
centroid2 =  member_stats(row,1);

dist = hd_distances_centroids(row, col);

is_happy = dist > MERGE_HAPPY_THRESH; %FIXME: how to evaluate this threshold automatically


if  ( DO_EXACT_NUM_CLUSTERS )
    if K == NUM_CLUSTERS
        is_happy = true ;
    else
        is_happy = false;
    end
end

if ( ~is_happy )
    new_centroid = (centroid1 + centroid2)/2;
    %fprintf('\t\t# merge cluster with centroids = %i and %i with hd_mean_dist = %f ...', centroid1, centroid2, dist );
    %k = find(member_stats(:,1) == max(centroid1, centroid2 ));
    %CENTROIDS = CENTROIDS(setdiff(1:K,k),:);
    CENTROIDS(col) = new_centroid;
    CENTROIDS = CENTROIDS(setdiff(1:K,row),:);
    %fprintf(' deleted centroid and entered new centroid %i... \n', new_centroid );
    K = K-1;
    CENTROIDS = round_centroids( CENTROIDS );
    CENTROIDS = validate_centroids( CENTROIDS);   
    is_merge = true;
end