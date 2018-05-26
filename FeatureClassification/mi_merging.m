function [sign_isovalues, member_stats] = mi_merging( mean_hd_table, init_guess, data_name )
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

global RAND_INIT;
global S_RATE;
global MAX_ISO;
global N_ISOS;
global CENTROIDS;
global CSVOBJ;
global K;

RAND_INIT = false;
%S_RATE = 1;
MAX_ISO = size(mean_hd_table,1);
N_ISOS = isov2idx(MAX_ISO);
CSVOBJ = [];

CENTROIDS = init_guess;
CENTROIDS = validate_centroids( CENTROIDS );

K = size(CENTROIDS, 1);
mean_hd_title = 'mean Hausdorff distance';
%display_hd_map( mean_hd_table, [],CENTROIDS, mean_hd_title, 0, data_name );


%% start clustering (main loop) %%
frame_id = 1;
is_merge = true;

while ( (is_merge ) ) 
        [ member_stats, frame_id ] =  kmeans_hd( mean_hd_table, frame_id, data_name, K, CENTROIDS);
        CENTROIDS = member_stats(:,1);
        num_clusters = size(CENTROIDS, 1);
        if ( num_clusters == NUM_CLUSTERS && DO_EXACT_NUM_CLUSTERS)
       
            sign_isovalues = sort(CENTROIDS);
            %display_hd_map(mean_hd_table, member_stats, [], mean_hd_title, frame_id, data_name );
            return;
        end
            
    %% check if a clusters can be merged
    
    is_merge = merge_clusters( member_stats, mean_hd_table );
end

%% wrap up

sign_isovalues = sort(CENTROIDS);
%display_hd_map(mean_hd_table, member_stats, [], mean_hd_title, frame_id, data_name );



%% helper
function [ member_stats, frame_id ] =  kmeans_hd( mean_hd_table, frame_id, data_name, K, previous_centroids )
%kmeans clustering on Hausdorff distance

fprintf( '### do clustering for K = %i clusters ...', K );
iter = 1;
converged = false;
while ( ~converged ) %k-means
    
    %% (1) assign points/isosurfaces to current clusters/centroids
    cluster_table = assign2clusters( mean_hd_table, K, previous_centroids );
    
    % compute some statistics about current cluster configuration
    member_stats = do_cluster_stats( cluster_table, mean_hd_table, K );
    
    %% (2) update cluster centroids
    new_centroids = compute_new_centroids( member_stats, K );
    
    converged = check_convergence( new_centroids, previous_centroids );
    iter = iter + 1;
    
    member_stats(:,1) = new_centroids; %set new centroids to member stats
    previous_centroids = new_centroids;
    
    mean_hd_title = 'mean Hausdorff distance';
%   writes frame
    %display_hd_map( mean_hd_table, member_stats, [], mean_hd_title, frame_id, data_name );
    frame_id = frame_id + 1;
    
end
fprintf( ' num iterations %i.\n', (iter-1) );

            
            
%% helper function do clustering
function isovalue_to_cluster = assign2clusters( lookup_table, K, centroids )
%do clustering with lookup from Hausdorff distance

global N_ISOS;

max_dist = max(max(lookup_table));
isovalue_to_cluster = zeros(N_ISOS,1);

for isov_idx = 1:N_ISOS 
    % get closest distance to any of the cluster ref points
    %fprintf( 'processing isovalue = %i ...\n', isovalue);
    
    min_distance = max_dist;
    cluster = 1;
    
    for k = 1:K
        centroid_idx = isov2idx( centroids(k) );
        
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
