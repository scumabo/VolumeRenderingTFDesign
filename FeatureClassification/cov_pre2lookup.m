function lookup = cov_pre2lookup ( mean_hd_table )
K = size(mean_hd_table, 1);
lookup = ones(K*(K-1)/2, 4);
row = 1;
for i = 1:K-1
    for j = i+1:K
        lookup(row, 1) = i;
        lookup(row, 2) = j;
        lookup(row, 3) = mean_hd_table(i, j);
        lookup(row, 4) = mean_hd_table(j, i);
        row = row + 1;
    end
end

