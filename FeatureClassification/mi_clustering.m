function [sign_isovalues, member_stats, cluster_table] = mi_clustering( lut, num_clusters, axis_handle )
%clusters isovalue based on Hausdorff distance

% naives k-means clustering (in isosurface similarity space):
% two stages: 
% (1) get centroids and assign points to clusters depending on distance
% (2) update centroids and re-assign points to clusters
%

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

% Initial K
if (num_clusters > 0)
    K = num_clusters;
else
    K = 20;
end

%% read lookup table

init_centroids = 2;  % 1:guess 2:equal 3:random 4: k-means++
switch init_centroids
    case 1
        CENTROIDS = init_guess_clustering();
    case 2
        CENTROIDS = init_equal_clustering(N_ISOS, K);
    case 3
        rand_vec = get_rand_vector();
        CENTROIDS = rand_vec(1:K);
    case 4
        CENTROIDS = init_kmeansplusplus(lut, K);
end

% CENTROIDS = [20, 240]';

%% start clustering (main loop) %%
frame_id = 1;
is_merge = true;

while ( (is_merge ) )
    [ cluster_table, member_stats, frame_id ] =  kmeans_hd( lut, frame_id, K);
    
     if (DO_CLUSTERING_VIDEO)
        plot_ris(CENTROIDS, member_stats(:,2), member_stats(:,6), axis_handle, [0.5 0.5 0.5], 1, '+' );
    end     
   
    if ( K == 1 || ~KMEANS_DO_MERGING)
        is_merge = false;
    else
        % check if two clusters can be merged
        is_merge = merge_clusters( member_stats, lut );
    end
end

%% wrap up

sign_isovalues = sort(CENTROIDS);



%% helper
function [ cluster_table, member_stats, frame_id ] =  kmeans_hd( lut, frame_id, K )
%kmeans clustering on Input similarity metric

global CENTROIDS;

fprintf( '### do clustering for K = %i clusters ...', K );
iter = 1;
converged = false;
while ( ~converged ) %k-means
    
    %% (1) assign points/isosurfaces to current clusters/centroids
    cluster_table = do_clustering( lut, K );
    
    % compute some statistics about current cluster configuration
    member_stats = do_cluster_stats( cluster_table, lut, K );
    
    %% (2) update cluster centroids
    new_centroids = compute_new_centroids( member_stats, K );
    converged = check_convergence( new_centroids, CENTROIDS );
    iter = iter + 1;
    
    CENTROIDS = new_centroids;
    member_stats(:,1) = CENTROIDS; %set new centroids to member stats
    
    frame_id = frame_id + 1;
    fprintf( 'iteration %i done \n', iter);
%     if iter>=20
%         converged = true;
%     end
end
fprintf( ' num iterations %i.\n', (iter-1) );

            
            
%% helper function do clustering
function isovalue_to_cluster = do_clustering( lookup_table, K )
%do clustering with lookup from Hausdorff distance

global N_ISOS;
global CENTROIDS;

CENTROIDS = validate_centroids( CENTROIDS );

max_dist = max(max(lookup_table));
isovalue_to_cluster = zeros(N_ISOS,1);

%FIXME: make this loop parallel
%parpool(4) parfor i=1:3, c(:,i) = eig(rand(1000)); end
for isov_idx = 1:N_ISOS %start at idx=2 since idx=1 is distance to itself; Bo: should start from 1
    % get closest distance to any of the cluster ref points
    %fprintf( 'processing isovalue = %i ...\n', isovalue);
    
    min_distance = max_dist;
    cluster = 1;
    
    for k = 1:K
        centroid_idx = isov2idx( CENTROIDS(k) );
        
        if ( centroid_idx < 1  || centroid_idx > N_ISOS )
            error( 'current centroid out of bounds: centroid_idx = %i', centroid_idx);
        end
        
        dist = lookup_table( isov_idx, centroid_idx );
        
        if ( dist < min_distance && ~isnan( dist ) )
            min_distance = dist;
            cluster = k;
        end
        
    end
    
    isovalue_to_cluster( isov_idx ) = cluster;
    
end


%% helper
function [member_stats ] = do_cluster_stats( cluster_table, lookup_table, K )
%count num members per cluster and isovalue sum per cluster

global CENTROIDS;

member_stats(:,1) = CENTROIDS;

%for each cluster
for k = 1:K
    
    %get all indices of cluster table that belong to current cluster
    I = find(cluster_table==k); 
    
    m_count = size(I,1);
    member_stats(k,2) = m_count; %num members per cluster
    
    if ( m_count > 0 )
        %currently not used, would be euclidean distance
        %member_mean_dist_to_centroids(k,1) = m_isum / m_count; 
        
        %euclidean distance
        %member_stats(k,4) = min(I); %used in display_hd_map
        %member_stats(k,5) = max(I); %used in display_hd_map
        
        %create table with all HDs for current cluster
        cluster_hd_table = lookup_table(I, I);   

        %sum all rows to get HD sum for all candidate centroids
        ccand_hd_sums = sum( cluster_hd_table, 2 );
        
        %member with shortest sum of HD distances becomes new centroid
        min_hd_sum = min( ccand_hd_sums );
        idx_new_centroid = find( ccand_hd_sums == min_hd_sum ); 
        idx_new_centroid1 = idx_new_centroid(1,1); % if there are multiple min
                                                   % take the first as centroid 
                                                  
                                                   
        
        member_stats(k,12) = I( idx_new_centroid1 ); %isovalue of new centroid
        member_stats(k,6) = min_hd_sum; %used in display_hd_map (= energy of cluster)
                
        %get isovalue farthest away from new centroid
        new_centroid_members = cluster_hd_table( idx_new_centroid1, : );
        max_hd = max( new_centroid_members );
        member_stats(k,8) = max_hd; %used if a cluster is split as new centroid
        max_hd_idx = find( new_centroid_members  == max_hd);
        max_hd_idx1 = max_hd_idx(1,1);%used if a cluster is split as new centroid
        member_stats(k,10) = I( max_hd_idx1 ); %used if a cluster is split as new centroid
        
        %display_hd_map( cluster_hd_table, [], [], sprintf('cluster %i', k), 1, 'hnut' );
        %display_hd_map( lookup_table, member_stats, [], sprintf('cluster %i', k), 1, 'hnut' );
   end
end

