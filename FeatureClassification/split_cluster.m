function is_split = split_cluster( member_stats )
%splits clusters on defined conditions

global K;
global CENTROIDS;
global MAX_ISO;
global SPLIT_HAPPY_THRESH;
global NUM_CLUSTERS;
global DO_EXACT_NUM_CLUSTERS;

is_split = false;

%member_count = member_stats(:, 2);
cluster_hd_sums = member_stats(:, 6);
%min_hd_dist_to_center = member_stats(:, 7);
%max_hd_dist_to_center = member_stats(:, 8);
%hd_extremas = max_hd_dist_to_center - min_hd_dist_to_center;
%hd_means = cluster_hd_sums ./ member_count;
k = find(cluster_hd_sums == max(cluster_hd_sums)); %find cluster idx with largest cum hd sum

% version 1
% %new_thresh = hd_means(k);
% new_thresh = cum_hd_sum(k);
% is_happy = (abs(SPLIT_HAPPY_THRESH - new_thresh ) < 5); %0.01);
% SPLIT_HAPPY_THRESH = new_thresh;

%version 2
stdev_energy = sqrt(var(cluster_hd_sums));
is_happy = stdev_energy < SPLIT_HAPPY_THRESH;

if  ( DO_EXACT_NUM_CLUSTERS )
    is_happy = is_happy && K == NUM_CLUSTERS ;
end

if ( ~is_happy )
    
    fprintf('\t## split cluster with centroid = %i and hd_sum = %f...', member_stats(k,1), cluster_hd_sums(k) );
    %split
    K = K+1; %increase global cluster size
        
    %introduce one new centroid based on Hausdorff distance (the one
    %farthest away from the current centroid)
    new_centroid1 =  CENTROIDS(k);
    new_centroid2 =  member_stats(k, 10);

    %make sure centroid does not go out-of-bound
    if (new_centroid1 < 1 )
        new_centroid1 = 1;
    end
    if (new_centroid2 < 1 )
        new_centroid2 = 1;
    end
    if (new_centroid1 > MAX_ISO )
        new_centroid1 = MAX_ISO;
    end
    if (new_centroid2 > MAX_ISO )
        new_centroid2 = MAX_ISO;
    end   
    
    fprintf( ' new centroids %i and %i.\n', new_centroid1, new_centroid2);
    
    CENTROIDS(k) = new_centroid1;
    CENTROIDS(K) = new_centroid2;
    
    CENTROIDS = round_centroids( CENTROIDS );
    CENTROIDS = validate_centroids( CENTROIDS);
    
    is_split = true;
end


%%helper and backup of code

%    while ( (is_split  || ~converged) && ( K <= MAX_NUM_CLUSTERS) )
        %% check if a clusters can be split
%        is_split = split_cluster( member_stats );
        
%        if (is_split )
%            converged = false;
%        end
%    end
    
    %display_hd_map( mean_hd_table, member_stats, [], mean_hd_title, frame_id, data_name );

