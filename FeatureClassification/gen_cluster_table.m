function cluster_hd_table = gen_cluster_table( lookup_table, m_count , I)
cluster_hd_table = ones(m_count, m_count);
for i = 1:m_count
    for j = 1:m_count
        if(i == j)
            cluster_hd_table(i, j) = 0;
        elseif (i < j) 
            cluster_hd_table(i, j) = get_distance( lookup_table, I(i, 1), I(j, 1));
        else
            cluster_hd_table(i, j) = get_distance( lookup_table, I(j, 1), I(i, 1));
        end
    end
end