function lambda = pick_lambda( X, n_clusters )

[n,d] = size(X);

ccand_hd_sums = sum( X, 2 );
min_hd_sum = min( ccand_hd_sums );
idx_new_centroid = find( ccand_hd_sums == min_hd_sum );

% if there are multiple min take the first as centroid                                               
T = idx_new_centroid(1,1);

for i = 1:n_clusters
    %add a point to T
    for j = 1:n
        dis_to_T(j, i) = min(X(j, T));
    end
    [lambda,ind] = max(dis_to_T(:, i));
    T = [T; ind];
end
lambda = lambda + 1e-10;








