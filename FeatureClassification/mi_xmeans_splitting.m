function [sign_isovalues, parents_stats] = mi_xmeans_splitting( mean_hd_table, data_name )
%clusters isovalue based on Hausdorff distance

% X-means: adaptive k-means clustering (in Hausdorff distance space):
% (1) get centroids and assign points to clusters depending on distance
% (2) update centroids and re-assign points to clusters
% (3) run k-means for each found cluster with K=2
% (4) compute BIC scores for parent and child clusters
% (5) keep either parent or children, whichever have the higher BIC score

global S_RATE;
global MAX_ISO;
global N_ISOS;
global CENTROIDS;
global K;
global BIC_SCORE;

K = 2; %start initially with 2 clusters, split when needed

S_RATE = 1;
MAX_ISO = size(mean_hd_table,1);
N_ISOS = isov2idx(MAX_ISO);
BIC_SCORE = 0;

CENTROIDS = init_equal_clustering(N_ISOS, K);

mean_hd_title = 'mean Hausdorff distance';
%display_hd_map( mean_hd_table, [],CENTROIDS, mean_hd_title, 0, data_name );

%% start clustering (main loop) %%
frame_id = 1;
converged = false;
while ( ~converged ) %k-means
    [ parents_stats, frame_id, cluster_table ] =  kmeans_hd( mean_hd_table, frame_id, data_name, K, CENTROIDS );
    CENTROIDS = parents_stats(:,1);
   
    %display_hd_map( mean_hd_table, parents_stats, [], mean_hd_title, frame_id, data_name );
    children_nmembers = zeros(K,2);
    children_energies = zeros(K,2);
    children = zeros(K,2);
    parent_ll = zeros(K,1);
    children_ll = zeros(K,2);
    
    %% for each cluster do a K-means with K=2
    for k=1:K
        %update table to current members
        %get all indices of cluster table that belong to current cluster
        I = find(cluster_table==k);
        m_count = size(I,1);
        
        if ( m_count > 0 )
            parent = CENTROIDS(k);
            start_isov = min(I);
            %parent_idx = parent - start_isov;
            %create table with all HDs for current cluster
            cluster_mean_table = mean_hd_table(I, I);
                   
            child_centroids = init_equal_clustering( m_count, 2 );
            
            %ch_start_pos = (k-1)*k+1;
            [ children_stats, frame_id2, cluster_table_children ] =  kmeans_hd( cluster_mean_table, frame_id, data_name, 2, child_centroids );
            child_centroids = children_stats(:,1);
            
            child1_idx = child_centroids( 1 );
            child2_idx = child_centroids( 2 );
            children(k,1) = I( child1_idx );
            children(k,2) = I( child2_idx );
            I1 = find( cluster_table_children==1 );
            I2 = find( cluster_table_children==2 );
            children_nmembers( k, 1 ) = size( I1, 1 );
            children_nmembers( k, 2 ) = size( I2, 1 );
            R = sum( children_nmembers(k, :) );
            R1 = children_nmembers( k, 1 );
            R2 = children_nmembers( k, 2 );
            
            %children energies
            children_energies( k,1 ) = children_stats(1,6);
            children_energies( k,2 ) = children_stats(2,6);
            
            % log likelihood
            [parent_ll(k), parent_var] = compute_ll( R, R, 1, mean_hd_table, I, parent );
            [children_ll(k,1), child1_var] = compute_ll( R, R1, 2, cluster_mean_table, I1, child1_idx );
            [children_ll(k,2), child2_var] = compute_ll( R, R2, 2, cluster_mean_table, I2, child2_idx );
                      
%            display_hd_map3( cluster_mean_table, parent_idx, child1_idx, child2_idx, parent_var, child1_var, child2_var, start_isov );
%            display_hd_map3( cluster_mean_table, parent_idx, child1_idx, child2_idx, parents_stats(k,6), children_energies( k,1 ), children_energies( k,2 ), start_isov );
        end
        
    end
    
    % compute bic scores for CENTROIDS and children
    % update CENTROIDS with highest bic-scores from parent-children groups
    
    num_previous_clusters = K;
    for k=1:num_previous_clusters
        % keep for every cluster either parent or children as centroid(s)
        % cluster configuration that has higher score is kept
        n_obs = children_nmembers(k,1) + children_nmembers(k,2);
        parent_score = bic(parent_ll(k), 1, n_obs);
        children_score = bic(children_ll(k,1) + children_ll(k,2), 2, n_obs);

        split = ( children_score - parent_score > 0 );
        if ( split )
            fprintf( '\t### split cluster = %i to children (%i,%i) with BIC = %i ...\n', CENTROIDS(k), children(k,1), children(k,2), children_score );
 
            CENTROIDS(k) = children(k,1);
            K = K + 1; %update global K
            CENTROIDS(K) = children(k,2);
          
            %note: update parents_stats and children_stats
            parents_stats(k, :) = 0;
            parents_stats(k, 1) = children(k,1);
            parents_stats(K, 1) = children(k,2);
            parents_stats(k, 2) = children_nmembers(k,1);
            parents_stats(K, 2) = children_nmembers(k,2);
            parents_stats(k, 6) = children_energies(k,1);
            parents_stats(K, 6) = children_energies(k,2);
            parents_stats(k, 13) = children_ll(k,1);
            parents_stats(K, 13) = children_ll(k,2);
            
        else
            
            % else if score1 is larger, do nothing configuration is kept as is
            % but update BIC score
            parents_stats(k, 13) = parent_ll(k);
            
        end
        
    end
    
    % compute global BIC score
    % (a) compute variances of all clusters; (b) compute log-likelihood of
    % all clusters, (c) compute BIC
    global_ll = sum(parents_stats(:, 13));
    global_bic = bic(global_ll, K, N_ISOS);
   
    %display_hd_map(mean_hd_table, parents_stats, [], mean_hd_title, frame_id, data_name );
    converged = (abs(BIC_SCORE - global_bic) < 10);
    BIC_SCORE = global_bic;
end

    

%% wrap up
sign_isovalues = sort(CENTROIDS);
%display_hd_map(mean_hd_table, parents_stats, [], mean_hd_title, frame_id, data_name );


%helper
function bic_score = bic( ll, n_clusters, n_obs)
%computes BIC score

%BIC score MATLAB version
% slightly different formula than x-means paper
%[aic, bic] = aicbic( ll, n_clusters, n_obs );

%BIC score x-means
M=1;
p = n_clusters - 1 + M* n_clusters + 1;
bic_score = ll - (p/2) * log(n_obs);


%%helper
function [ll, cluster_variance] = compute_ll( R, Rk, n_clusters, lut, J, centroid )
%computes the log-likelihood for x-means

% x: local cluster points
% R: total number of points
% Rn: number of cluster points of current cluster
% K: num clusters

M=1; %number of dimensions, D=1 for set of isovalues

cluster_diff = lut( J, centroid );
cluster_diff2 = sum( cluster_diff .* cluster_diff );
cluster_variance = 1/(Rk-1) * cluster_diff2;

ll = -(Rk/2) * log(2*pi);
ll = ll - (((Rk*M)/2) * log(cluster_variance));
ll = ll - ((Rk-n_clusters)/2);
ll = ll + (Rk * log(Rk));
ll = ll - (Rk * log(R));



%% helper
function [ member_stats, frame_id, cluster_table ] =  kmeans_hd( mean_hd_table, frame_id, data_name, K, previous_centroids )
%kmeans clustering on Hausdorff distance

fprintf( '### k-means clustering for K = %i ...', K );
iter = 1;
converged = false;
while ( ~converged ) %k-means
    
    %% (1) assign points/isosurfaces to current clusters/centroids
    cluster_table = assign2clusters( mean_hd_table, K, previous_centroids );
    
    member_stats = do_cluster_stats( cluster_table, mean_hd_table, K );
    
    %% (2) update cluster centroids

    new_centroids = compute_new_centroids( member_stats, K );
    
    converged = check_convergence( new_centroids, previous_centroids );
    iter = iter + 1;
    
    member_stats(:,1) = new_centroids; %set new centroids to member stats
    previous_centroids = new_centroids;
%   mean_hd_title = 'mean Hausdorff distance';
%   writes frame
%   display_hd_map( mean_hd_table, member_stats, [], mean_hd_title, frame_id, data_name );
    frame_id = frame_id + 1;
    
end
fprintf( ' num iterations %i.\n', (iter-1) );

            
            
%% helper function do clustering
function isovalue_to_cluster = assign2clusters( lookup_table, K, centroids )
%do clustering with lookup from Hausdorff distance

lut_size = size( lookup_table, 1);

max_dist = max(max(lookup_table));
isovalue_to_cluster = zeros(lut_size,1);

for isov_idx = 1:lut_size 
    % get closest distance to any of the cluster ref points
    %fprintf( 'processing isovalue = %i ...\n', isovalue);
    
    min_distance = max_dist;
    cluster = 1;
    
    for k = 1:K
        centroid_idx = isov2idx( centroids(k) );
        
        if ( centroid_idx < 1  || centroid_idx > lut_size )
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

