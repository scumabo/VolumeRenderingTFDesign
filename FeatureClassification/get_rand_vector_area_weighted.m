function rand_vec = get_rand_vector_area_weighted()
%returns rand vector with given number of isovalues

global AREA_TABLE;
global N_ISOS;

rand_vec = rand(N_ISOS, 1);

for r = 1:N_ISOS
    rvalue = rand_vec(r);
    rand_vec(r) = sum(rvalue >= cumsum(AREA_TABLE));
end

rand_vec = round_centroids( rand_vec );
