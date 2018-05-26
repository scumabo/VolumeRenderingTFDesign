function [sign_isovalues, parents_stats] = mi_xmeans_splitting2( mean_hd_table, data_name )
%clusters isovalue based on Hausdorff distance


% Improving X-means clustering with MNDL
% Shahbaba, M. ; Dept. of Electr. & Comput. Eng., Ryerson Univ., Toronto, ON, Canada ; Beheshti, S.
% contact: mshahbab@ryerson.ca
% link to the paper: http://ieeexplore.ieee.org/xpls/abs_all.jsp?tp=&arnumber=6310493&tag=1)

% X-means: adaptive k-means clustering (in Hausdorff distance space):
% (1) get centroids and assign points to clusters depending on distance
% (2) update centroids and re-assign points to clusters
% (3) run k-means for each found cluster with K=2 
% (4) compute MNDL scores for parent and child clusters
% (5) keep either parent or children, whichever have the lower MNDL score

% some information on the MNDL computation from mshahbab@ryerson.ca
% Yes W_{j} belongs to each cluster and W is its overall value ((7) and (12) are related). 
% The procedure is exactly the same as xmeans with this difference that in 
% each step we consider two scenarios (K=1 and K=2) for MNDL and not BIC. 
% The choice of (K=1 or K=2) over a set of samples gives the Z value, 
% so when you choose K=2, you basically get the related Z for K=2 and no 
% need to sum up children values.
% If I'm not wrong the alpha was chosen based on an equation which was used
% in the ref [13], it gives a condition for the alpha value. But more or 
% less the alpha and beta should be around 3 or less. For a Gaussian
% distribution 3 gives almost 0.95 confidence. I think you need to set 
% it experimentally for your application and see what works better.  
%
% I believe you can easily try to implement the equations (9) for a given 
% alpha value (see [13]), if all goes well for two clusters Z value of K=2 
% will be smaller than Z value of K=1.
%
% That's all I have on top of my mind, to give you more details I have to 
% dig into my old laptop for the code and documentations, 
% I'll do my best to find it, but for now I think a good choice of alpha 
% and implementation of (9) to (12) should be also helpful. 



global S_RATE;
global MAX_ISO;
global N_ISOS;
global CENTROIDS;
global K;
global MNDL_SCORE;

K = 2; %start initially with 2 clusters, split when needed

S_RATE = 1;
MAX_ISO = size(mean_hd_table,1);
N_ISOS = isov2idx(MAX_ISO);
MNDL_SCORE = 0;

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
    parent_var = zeros(K,1);
    children_var = zeros(K,3);
    parent_err = zeros(K,1);
    children_err = zeros(K,1);
    
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
            [parent_diff2, parent_err(k)] = compute_stats( R, mean_hd_table, I, parent );
            [child1_diff2, child1_err] = compute_stats( R1, cluster_mean_table, I1, child1_idx );
            [child2_diff2, child2_err] = compute_stats( R2, cluster_mean_table, I2, child2_idx );
            children_var(k, 1) = child1_diff2; %)/(R1-2);
            children_var(k, 2) = child2_diff2; %)/(R2-2);
            children_var(k, 3) = (child1_diff2 + child2_diff2)/(R1+R2-2);
            children_err(k, 1) = child1_err;
            children_err(k, 2) = child2_err;
            parent_var(k) =  parent_diff2 /R;
            
            
%            display_hd_map3( cluster_mean_table, parent_idx, child1_idx, child2_idx, parent_var, child1_var, child2_var, start_isov );
%            display_hd_map3( cluster_mean_table, parent_idx, child1_idx, child2_idx, parents_stats(k,6), children_energies( k,1 ), children_energies( k,2 ), start_isov );
        end
        
    end
    
    % compute bic scores for CENTROIDS and children
    % update CENTROIDS with highest bic-scores from parent-children groups
    
    num_previous_clusters = K;
    for k=1:num_previous_clusters
        % keep for every cluster either parent or children as centroid(s)
        % cluster configuration that has lower score is kept
        n_obs = children_nmembers(k,1) + children_nmembers(k,2);
        parent_score = mndl( parent_var(k), n_obs, 1, parent_err(k)); 
        children_score = mndl(children_var(k,3), n_obs, 2, children_err(k,1)+children_err(k,2));

        split = ( parent_score - children_score > 0 );
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
            parents_stats(k, 13) = children_var(k, 1);
            parents_stats(K, 13) = children_var(k, 2);
            parents_stats(k, 14) = children_err(k,1);
            parents_stats(K, 14) = children_err(k,2);
            
        else
            
            % else if score1 is larger, do nothing configuration is kept as is
            % but update BIC score
            
            parents_stats(k, 13) = parent_var(k);
            parents_stats(k, 14) = parent_err(k);
            
        end
        
    end
    
    % compute global BIC score
    % (a) compute variances of all clusters; (b) compute log-likelihood of
    % all clusters, (c) compute BIC
    global_diff2 = sum(parents_stats(:, 13));
    global_nmembers = sum(parents_stats(:, 2)); %should be N_ISOS
    global_var = global_diff2 / (global_nmembers - K);
       
    global_err = sum(parents_stats(:, 14));
    global_mndl = mndl(global_var, N_ISOS, K, global_err );
    %compute global MNDL score
   
    %display_hd_map(mean_hd_table, parents_stats, [], mean_hd_title, frame_id, data_name );
    converged = (abs(MNDL_SCORE - global_mndl) < 12.75);
    MNDL_SCORE = global_mndl;
end

    

%% wrap up
sign_isovalues = sort(CENTROIDS);
display_hd_map(mean_hd_table, parents_stats, [], mean_hd_title, frame_id, data_name );


%helper
function mndl_score = mndl( cluster_variance, n_members, n_clusters, W )
%computes MNDL score

Q_a = 0.9; % chosen form paper
Q_b = 0.9;
%NOTE about alpha/beta: author says should be smaller than 3 
% -> 0.95 confidence
% see ref [13] from paper
beta = 3; 
alpha = 3; 

K_w = (1 - n_clusters / n_members) * cluster_variance;

K_sa = alpha * alpha * cluster_variance;
K_sa = K_sa + W - 0.5 * K_w;
K_sa = sqrt(K_sa);
K_sa = K_sa * 2 * alpha * cluster_variance / sqrt(n_members);

U_qa = W - K_w + K_sa;
U_qa = U_qa + 2 * alpha * alpha * cluster_variance / n_members;

mndl_score = n_clusters / n_members * cluster_variance;
mndl_score = mndl_score + U_qa;
mndl_score = mndl_score + beta * sqrt(2*n_clusters) * cluster_variance / n_members;


%%helper
function [cluster_diff2, W] = compute_stats( Rk, lut, J, centroid )
%computes cluster variances

cluster_diff = lut( J, centroid );
cluster_diff2 = sum( cluster_diff .* cluster_diff );

W = cluster_diff2 / Rk;




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

