function [clustCent,data2cluster, ms_cluster_table] = MeanShiftCluster(lut, dataPts, cluster_table, KNN)
%perform MeanShift Clustering of data using a flat kernel
%
% ---INPUT---
% dataPts           - input data, (numDim x numPts)
% bandWidth         - is bandwidth parameter (scalar)
% plotFlag          - display output if 2 or 3 D    (logical)
% ---OUTPUT---
% clustCent         - is locations of cluster centers (numDim x numClust)
% data2cluster      - for every data point which cluster it belongs to (numPts)
% cluster2dataCell  - for every cluster which points are in it (numClust)
% 
% Bryan Feldman 02/24/06
% MeanShift first appears in
% K. Funkunaga and L.D. Hosteler, "The Estimation of the Gradient of a
% Density Function, with Applications in Pattern Recognition"


%*** Check input ****
if nargin < 2
    error('no bandwidth specified')
end
global N_ISOS;

%**** Initialize stuff ***
numPts = size(dataPts, 1);
numClust        = 0;
initPtInds      = 1:numPts;
stopThresh      = 0;                       %when mean has converged
clustCent       = [];                                   %center of cluster
beenVisitedFlag = zeros(1,numPts,'uint8');              %track if a points been seen already
numInitPts      = numPts;                               %number of points to posibaly use as initilization points
clusterVotes    = zeros(1,numPts,'uint16');             %used to resolve conflicts on cluster membership
ms_cluster_table = zeros(N_ISOS,1);

% for all the points: compute its convergence
for stInd = 1:numPts
    cur_Mean = dataPts(stInd, :);
    
    while 1
        DistToAll = lut(dataPts(:,:) ,cur_Mean);         % distance from current mean to all points
       % [sortedValues,sortIndex] = sort(DistToAll(:));
       % inInds = sortIndex(1:KNN);                        % KNN points to determin window size
        inInds      = find(DistToAll < 0.6);               %points within bandWidth 
       
        OldMean = cur_Mean;                                   %save the old mean
        % compute the new mean (centroids)
        cluster_hd_table = lut(dataPts(inInds), dataPts(inInds));
        ccand_hd_sums = sum( cluster_hd_table^2, 2 );
        min_hd_sum = min( ccand_hd_sums );
        idx_new_centroid = find( ccand_hd_sums == min_hd_sum );
        
        if any(dataPts(inInds(idx_new_centroid)) == cur_Mean)
            cur_Mean = cur_Mean;
        else
            cur_Mean = dataPts(inInds(idx_new_centroid(1,1)));
        end
        
        %**** if mean doesn't move much stop this cluster ***
        if norm(cur_Mean-OldMean) == 0
            
            if find(clustCent == cur_Mean)
               ms_cluster_table(dataPts(stInd, :)) = find(clustCent == cur_Mean);
               % update members from k_means: comment out if only m_shift
               ms_cluster_table(find(cluster_table == cluster_table(dataPts(stInd, :)))) = find(clustCent == cur_Mean);
            else
                numClust                    = numClust+1;                   %increment clusters
                clustCent(:,numClust)       = cur_Mean;                     %record the centroid
                ms_cluster_table(dataPts(stInd, :)) = numClust;
                % update members from k_means: comment out if only m_shift
                ms_cluster_table(find(cluster_table == cluster_table(dataPts(stInd, :)))) = numClust;
            end
            break;
        end
    end
end

