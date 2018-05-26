function [cluster_table, sign_isovalues, member_stats] = mi_dpmeans2(lut, lut_hd_mean, lut_hd_max, lut_ism, data_name, lambda, I_area, area, do_small_isos, handles )
%clusters isosurfaces based on their Hausdorff distance

% use isosurface area weighting during clustering algorithm
% 
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
tmp = lut(:, CENTROIDS(1,1) ); %get all distances to new centroid
old_obj = sum(tmp) + K * lambda;



%% start clustering (main loop) %%
frame_id = 1;
delta = Inf;

while ( delta > 1e-3 )
    [ cluster_table, member_stats, frame_id, K ] =  dpkmeans_hd( lut, frame_id, data_name, K, CENTROIDS, lambda, I_area, area, do_small_isos );
    
    CENTROIDS = member_stats(:,1);
    
    if (DO_CLUSTERING_VIDEO)
        plot_ris(CENTROIDS, member_stats(:,2), member_stats(:,6), handles.lut_axis, [0.5 0.5 0.5], 1 );
    end
    
    % start with point that has shortest distance to all other points
    % sum of distances from every point to all others is shortest.     new_obj =  sum(member_stats(:,3)) + lambda * K;
    new_obj =  sum(member_stats(:,3)) + lambda * K;
    delta = old_obj - new_obj;
    old_obj  = new_obj;
end

%% wrap up

sign_isovalues = sort(CENTROIDS);
%display_hd_map(lut, member_stats, [], mean_hd_title, frame_id, data_name );


%% helper
function [ cluster_table, member_stats, frame_id, K ] =  dpkmeans_hd( lut, frame_id, data_name, K, previous_centroids, lambda, I_area, area, do_small_isos )
%kmeans clustering on Hausdorff distance

fprintf( '### do clustering for K = %i clusters ...\n', K );

%% (1) assign points/isosurfaces to current clusters/centroids
[cluster_table, tmp_centroids] = assign2clusters( lut, K, previous_centroids, lambda, I_area, area, do_small_isos );
K = size( tmp_centroids, 1 );

% compute some statistics about current cluster configuration
member_stats = do_cluster_stats( cluster_table, lut, K );

%% (2) update cluster centroids
new_centroids = compute_new_centroids( member_stats, K );

member_stats(:,1) = new_centroids; %set new centroids to member stats

%   writes frame
frame_id = frame_id + 1;


            
            
%% helper function do clustering
function [isovalue_to_cluster, centroids] = assign2clusters( lookup_table, K, centroids, lambda, I_area, area, do_small_isos )
%do clustering with lookup from Hausdorff distance

n_isos = size(lookup_table,1);
isovalue_to_cluster = zeros(n_isos,1);
large_area = true;
%area = exp(area/max(area));
%area = log(area);

for n = 1:n_isos 
    % loop through isovalues dependent on their area
    isov_idx = I_area(n);    
    
    %%find distance from point to all centroids
    dist2centroids = lookup_table(isov_idx, centroids); %only works for symmetric lookup_table
    
    m_dist = min(dist2centroids);
    
    if(large_area) %normalized area at isovalue isov_idx
        norm_area = (area(isov_idx)/(max(area)));
    else
        norm_area = (area(isov_idx)/(max(area)));
    end

    if ( norm_area <= 0 )
        norm_area =  0.0000001;
    end
    
    dist_thresh = lambda/norm_area;
  
    if ( do_small_isos )
        dist_thresh = lambda*norm_area;
        
    end
    if ( m_dist > dist_thresh )
        % create a new cluster with centroid at isov_idx
        K = K+1;
        centroids(K,1) = isov_idx;
        isovalue_to_cluster( isov_idx )  =  K;
        I_area = [I_area(1:n) fliplr(I_area(n+1:n_isos))];
        
        if(large_area)
            large_area = false;
        else
            large_area = true;
        end
    else
        % assign current point to an existing cluster
        cluster_idx = find( dist2centroids==m_dist );
        isovalue_to_cluster( isov_idx )  =  cluster_idx(1,1);
        
    end
end

