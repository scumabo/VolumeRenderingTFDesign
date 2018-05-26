function [cluster_table, sign_isovalues, member_stats] = mi_dpmeans(lut, lambda, I_area, axis_handle )
%clusters isosurfaces based on their Hausdorff distance

% dpmeans adapted to isosurfaces and Hausdorff distance
% see:
% Revisiting k-means: New Algorithms via Bayesian Nonparametrics
% Authors: Brian Kulis & Michael I. Jordan
% Year: 2012
% Contact: KULIS@CSE.OHIO-STATE.EDU, Department of CSE, Ohio State University, Columbus, OH


global S_RATE;
global CENTROIDS;
global K;
global DO_CLUSTERING_VIDEO;

S_RATE = 1;

% start with point that has shortest distance to all other points
% sum of distances from every point to all others is shortest. 

% start with one cluster
% sum all rows to get HD sum for all candidate centroids
ccand_hd_sums = sum( lut, 2 );
% member with shortest sum of HD distances becomes new centroid
min_hd_sum = min( ccand_hd_sums );
idx_new_centroid = find( ccand_hd_sums == min_hd_sum );
% if there are multiple min take the first as centroid
                                               
CENTROIDS = idx_new_centroid(1,1);
K = size(CENTROIDS, 1);

%compute inital obj
tmp = lut(:, CENTROIDS(1,1) ); %get all distances to centroid
old_obj = sum(tmp) + K * lambda; %see formula (1) in [KJ:12]


%% start clustering (main loop) %%
frame_id = 1;
delta = Inf;

while ( delta > 1e-3 )
    [ cluster_table, member_stats, frame_id, K ] =  dpkmeans_hd( lut, frame_id, K, CENTROIDS, lambda, I_area );
    
    CENTROIDS = member_stats(:,1);
    
    if (DO_CLUSTERING_VIDEO)
        plot_ris(CENTROIDS, member_stats(:,2), member_stats(:,6), axis_handle, [0.5 0.5 0.5], 1, '+' );
    end    
     
    % compute delta between last and current iteration
    % balance between number of clusters and sum of distances of all members to their centroid 
    new_obj =  sum(member_stats(:,3)) + lambda * K;
    delta = old_obj - new_obj;
    old_obj  = new_obj;
end



%% wrap up

sign_isovalues = sort(CENTROIDS);


%% helper
function [ cluster_table, member_stats, frame_id, K ] =  dpkmeans_hd( lut, frame_id, K, previous_centroids, lambda, I_area )
%kmeans clustering on Hausdorff distance

fprintf( '### do clustering for K = %i clusters ...\n', K );

%% (1) assign points/isosurfaces to current clusters/centroids
[cluster_table, tmp_centroids] = assign2clusters( lut, K, previous_centroids, lambda, I_area );
K = size( tmp_centroids, 1 );

% compute some statistics about current cluster configuration
member_stats = do_cluster_stats( cluster_table, lut, K );

%% (2) update cluster centroids
new_centroids = compute_new_centroids( member_stats, K );

member_stats(:,1) = new_centroids; %set new centroids to member stats

%   writes frame
frame_id = frame_id + 1;


            
            
%% helper function do clustering
function [isovalue_to_cluster, centroids] = assign2clusters( lookup_table, K, centroids, lambda, I_area )
%do clustering with lookup from Hausdorff distance

n_isos = size(lookup_table,1);
isovalue_to_cluster = zeros(n_isos,1);

for n = 1:n_isos 

    % loop through isovalues dependent on their area
    %isov_idx =  I_area(n);    
    isov_idx = n;
    
    %%find distance from point to all centroids
    dist2centroids = lookup_table(isov_idx, centroids); %only works for symmetric lookup_table
    
    m_dist = min(dist2centroids);
    
    if ( m_dist > lambda )
        % create a new cluster with centroid at isov_idx
        K = K+1;
        centroids(K,1) = isov_idx;
        isovalue_to_cluster( isov_idx )  =  K;
       % I_area = [I_area(1:n) fliplr(I_area(n+1:n_isos))];
    else
        % assign current point to an existing cluster
        cluster_idx = find( dist2centroids==m_dist );
        isovalue_to_cluster( isov_idx )  =  cluster_idx(1,1);
        
    end
        
end

