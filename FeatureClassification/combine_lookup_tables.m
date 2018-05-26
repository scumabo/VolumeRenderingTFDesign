function combine_lookup_tables()
%combines two lookup tables


%filename = '/blank0/data/clustering/neghip_lookup_table_hd_max_srate1.csv';
%filename3 = '/blank0/data/clustering/neghip_lookup_table_hd_max_srate1_2.csv'; 
%filename2 = '/blank0/data/clustering/neghip_lookup_table_hd_max_srate1_full.csv'; %hnut_lookup_table_hd_max10.csv';

filename = '/blank0/data/mesh_output/sphere_lookup_table_hd_max_srate1.csv';
filename3 = '/blank0/data/mesh_output/sphere_lookup_table_hd_max_srate1_2.csv';
filename_out = '/blank0/data/mesh_output/sphere_lookup_table_hd_max_srate1_full.csv';

a = csvread(filename);
b = csvread(filename3);

N = size(a,1);
M = size(b,1);
I = size(a,2);

c = zeros(I,I);
c(1:N, :) = a;
c(N+1:I, :) = b;

lookup_table = mirror_missing_distances( c );

%% check symmetry
check_m_symmetry( lookup_table );
csvwrite(filename_out,lookup_table);

