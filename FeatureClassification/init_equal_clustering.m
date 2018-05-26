function vec = init_equal_clustering( lut_size, num_clusters )
%initial evenly divide the isovalues based on num of clussters

vec = zeros( num_clusters, 1 );
step = lut_size/num_clusters;
step = uint16(step);

%alternative, start at half a step than at 1 with initial seeds
half_step = uint16(step/2);

j = 1;
for i = half_step:step:lut_size
    vec(j) = i;
    j = j + 1;
end
vec = round_centroids(vec);
vec = vec(1:num_clusters);
