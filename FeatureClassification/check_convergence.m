function  converged = check_convergence( new_centroids, previous_centroids )
%checkes whether the clustering algorithm already converged


converged = false;

num_centroids = size(new_centroids, 1);
%FIXME: check if K == num_centroids

diff = abs( previous_centroids - new_centroids );

for k = 1:num_centroids
    c_diff = abs(diff(k));
    
    if (c_diff  > 0)
        converged = false;
        return
    else
        converged = true;
    end
end
