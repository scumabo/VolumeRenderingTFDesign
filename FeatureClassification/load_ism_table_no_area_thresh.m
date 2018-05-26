function a_ism = load_ism_table_no_area_thresh( data_name )
%loads ism table form png and inverts it

global MESH_DATA_DIR;

fn_ism = sprintf('%s.vs.dat.mi.raw', data_name );
a_ism = load_ism_raw( MESH_DATA_DIR, fn_ism, true );

%since a_ism start from 0 we remove the first row and column
a_ism = a_ism(2:size(a_ism,1), 2:size(a_ism, 2));

