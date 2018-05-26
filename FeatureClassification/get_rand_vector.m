function rand_vec = get_rand_vector()
%returns rand vector with given number of isovalues

global MAX_ISO;
global N_ISOS;

%rand('seed', 1);
rand_vec = rand(N_ISOS, 1);
rand_vec = rand_vec * floor(MAX_ISO);
rand_vec = round_centroids(rand_vec);
