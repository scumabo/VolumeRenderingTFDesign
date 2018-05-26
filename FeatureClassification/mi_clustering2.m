function [K, sign_isovalues, member_stats] = mi_clustering2( mean_hd_table, max_hd_table, area_table, data_name )
%clusters isovalue based on Hausdorff distance

% adaptive k-means clustering (in Hausdorff distance space):
% two stages: 
% (1) get centroids and assign points to clusters depending on distance
% (2) update centroids and re-assign points to clusters
% (3) if cluster configuration is unhappy (clusters' energy is imbalanced),
% split cluster with largest energy. go back to (1)
% (4) merge clusters if they are two close (i.e., unhappy). go back to (1).
%

global NUM_CLUSTERS;
global DO_EXACT_NUM_CLUSTERS;

global AREA_WEIGHTED_CENTROIDS;
global AREA_WEIGHTED;
global AREA_TABLE;
global RAND_INIT;
global S_RATE;
global MAX_ISO;
global N_ISOS;
global CENTROIDS;
global MAX_NUM_CLUSTERS;
global CSVOBJ;

RAND_INIT = false;
S_RATE = 1;
AREA_WEIGHTED = false;
AREA_WEIGHTED_CENTROIDS = false;
MAX_ISO = size(mean_hd_table,1);
N_ISOS = isov2idx(MAX_ISO);
CSVOBJ = [];

%% read lookup table
AREA_TABLE = area_table';
%AREA_TABLE = get_area_weights( area_table )';
%AREA_TABLE = AREA_TABLE.^0.8;

initial_centroids = 2;  % 1:guess 2:equal 3:random
switch initial_centroids
    case 1
        CENTROIDS = init_guess_clustering();
    case 2
        CENTROIDS = init_equal_clustering();
    case 3
        rand_vec = get_rand_vector();
        CENTROIDS = rand_vec(1:MAX_NUM_CLUSTERS);
end

K = size(CENTROIDS, 1);
mean_hd_title = 'mean Hausdorff distance';
display_hd_map( mean_hd_table, [],CENTROIDS, mean_hd_title, 0, data_name );

lookup_table = cov_pre2lookup(mean_hd_table);

%% start clustering (main loop) %%
frame_id = 1;
is_merge = true;

while ( (is_merge ) ) 
        [ member_stats, frame_id ] =  kmeans_hd( max_hd_table, lookup_table, frame_id, data_name);
        
        %display_hd_map( mean_hd_table, member_stats, [], mean_hd_title, frame_id, data_name );
        vec = extract_non_empty_surfaces( CENTROIDS );
        num_clusters = size(vec, 1);
        if ( num_clusters == NUM_CLUSTERS && DO_EXACT_NUM_CLUSTERS)
       
            sign_isovalues = extract_non_empty_surfaces( CENTROIDS );
            sign_isovalues = sort(sign_isovalues);
            display_hd_map(mean_hd_table, member_stats, [], mean_hd_title, frame_id, data_name );
            return;
        end
            
    %% check if a clusters can be merged
    
    is_merge = merge_clusters( member_stats, mean_hd_table );
end

%% wrap up

sign_isovalues = extract_non_empty_surfaces( CENTROIDS );
sign_isovalues = sort(sign_isovalues);
display_hd_map(mean_hd_table, member_stats, [], mean_hd_title, frame_id, data_name );



%% helper
function [ member_stats, frame_id ] =  kmeans_hd( max_hd_table, lookup_table, frame_id, data_name)
%kmeans clustering on Hausdorff distance

global CENTROIDS;
global USE_MAX_HD;
global AREA_WEIGHTED_CENTROIDS;
global AREA_TABLE;
global K;

fprintf( '### do clustering for K = %i clusters ...', K );
iter = 1;
converged = false;
while ( ~converged ) %k-means
    
    %% (1) assign points/isosurfaces to current clusters/centroids
    cluster_table = do_clustering( lookup_table );
    
    % compute some statistics about current cluster configuration
    if ( USE_MAX_HD )
        member_stats = do_cluster_stats( cluster_table, max_hd_table, AREA_TABLE );
    else
        member_stats = do_cluster_stats( cluster_table, lookup_table, AREA_TABLE );
    end
    
    %% (2) update cluster centroids
    if (AREA_WEIGHTED_CENTROIDS)
        new_centroids = compute_new_centroids_areaw( cluster_table );
    else
        new_centroids = compute_new_centroids( member_stats );
    end
    
    converged = check_convergence( new_centroids );
    iter = iter + 1;
    
    CENTROIDS = new_centroids;
    member_stats(:,1) = CENTROIDS; %set new centroids to member stats
    
%   mean_hd_title = 'mean Hausdorff distance';
%   writes frame
%   display_hd_map( mean_hd_table, member_stats, [], mean_hd_title, frame_id, data_name );
    frame_id = frame_id + 1;
    
end
fprintf( ' num iterations %i.\n', (iter-1) );

            
            
%% helper function do clustering
function isovalue_to_cluster = do_clustering( lookup_table )
%do clustering with lookup from Hausdorff distance

global N_ISOS;
global K;
global CENTROIDS;

CENTROIDS = validate_centroids( CENTROIDS );

max_dist = max(max(lookup_table(:, 3:4)));
isovalue_to_cluster = zeros(N_ISOS,1);

%FIXME: make this loop parallel
%parpool(4) parfor i=1:3, c(:,i) = eig(rand(1000)); end
for isov_idx = 2:N_ISOS %start at idx=2 since idx=1 is distance to itself
    % get closest distance to any of the cluster ref points
    %fprintf( 'processing isovalue = %i ...\n', isovalue);
    
    min_distance = max_dist;
    cluster = 1;
    
    for k = 1:K
        centroid_idx = isov2idx( CENTROIDS(k) );
        
        if ( centroid_idx < 1  || centroid_idx > N_ISOS )
            error( 'current centroid out of bounds: centroid_idx = %i', centroid_idx);
        end
        
        if isov_idx == centroid_idx
            dist = 0;
        elseif isov_idx < centroid_idx
            dist = get_distance( lookup_table, isov_idx, centroid_idx );
        else
            dist = get_distance( lookup_table, centroid_idx ,isov_idx );
        end
        
       if ( dist < min_distance && ~isnan( dist ) )
            min_distance = dist;
            cluster = k;
       end
       
    end
    
    isovalue_to_cluster( isov_idx ) = cluster;
    
end


%% helper
function [member_stats ] = do_cluster_stats( cluster_table, lookup_table, area_table )
%count num members per cluster and isovalue sum per cluster

global K;
global CENTROIDS;
global USE_AREA_UPD_CENTROIDS;

member_stats(:,1) = CENTROIDS;

%for each cluster
for k = 1:K
    
    %get all indices of cluster table that belong to current cluster
    I = find(cluster_table==k); 
    
    m_count = size(I,1);
    %currently not used, would be euclidean distance
    %m_isum = sum(I);
    member_stats(k,2) = m_count; %num members per cluster
    
    if ( m_count > 0 )
        %currently not used, would be euclidean distance
        %member_mean_dist_to_centroids(k,1) = m_isum / m_count; 
        
        %euclidean distance
        %member_stats(k,4) = min(I); %used in display_hd_map
        %member_stats(k,5) = max(I); %used in display_hd_map
        
        %create table with all HDs for current cluster
        cluster_hd_table = gen_cluster_table(lookup_table, m_count, I);   

        %sum all rows to get HD sum for all candidate centroids
        ccand_hd_sums = sum( cluster_hd_table, 2 );
        if (USE_AREA_UPD_CENTROIDS)
            cluster_area_table = area_table(I);
            ccand_hd_sums = ccand_hd_sums ./ cluster_area_table;
        end
        
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

%member_stats(:,11) = member_mean_dist_to_centroids; %mean centroids, currently not used

%member_mean_dist_to_centroids = round_centroids( member_mean_dist_to_centroids );
%member_mean_dist_to_centroids = abs(CENTROIDS - member_mean_dist_to_centroids );

%member_stats(:,3) = member_mean_dist_to_centroids; %NOTE: currently not used
%member_stats(:,7) = member_hd_min; %NOTE: currently empty
%member_stats(:,9) = member_hd_min_member; %NOTE: currently empty


%% parames for parallel execution
% %parpool(4);
%delete(gcp); % parallel computing
