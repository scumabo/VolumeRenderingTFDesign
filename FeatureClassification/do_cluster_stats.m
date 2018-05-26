function [member_stats ] = do_cluster_stats( cluster_table, lookup_table, K )
%count num members per cluster and isovalue sum per cluster

member_stats = zeros(K,13);

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
        cluster_hd_table = lookup_table(I, I);   

        %sum all rows to get HD sum for all candidate centroids
        ccand_hd_sums = sum( cluster_hd_table, 2 );
        
        %member with shortest sum of HD distances becomes new centroid
        min_hd_sum = min( ccand_hd_sums );
        idx_new_centroid = find( ccand_hd_sums == min_hd_sum ); 
        idx_new_centroid1 = idx_new_centroid(1,1); % if there are multiple min
                                                   % take the first as centroid     
        new_centroid = I( idx_new_centroid1 ); %isovalue of new centroid
        member_stats(k,12) = new_centroid;
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
        
        tmp = lookup_table(I, new_centroid ); %get all distances to new centroid
        %tmp = tmp + K * lambda;                                  
        member_stats(k,3) = sum(tmp); %used to compute convergence                                            
   end
end

%member_stats(:,11) = member_mean_dist_to_centroids; %mean centroids, currently not used

%member_mean_dist_to_centroids = round_centroids( member_mean_dist_to_centroids );
%member_mean_dist_to_centroids = abs(CENTROIDS - member_mean_dist_to_centroids );

%member_stats(:,3) = member_mean_dist_to_centroids; %NOTE: currently not used
%member_stats(:,7) = member_hd_min; %NOTE: currently empty
%member_stats(:,9) = member_hd_min_member; %NOTE: currently empty