function a_ism = load_ism_table( data_name )
%loads ism table form png and inverts it

global MESH_DATA_DIR;
global MIN_AREA_THRESH;

fn_area = sprintf('%s/%s__area.csv', MESH_DATA_DIR, data_name );
a_area1 = csvread( fn_area );

a_ism = load_ism_table_no_area_thresh( data_name );

%indices that are skipped to do mapping to isovalues
I = find(a_area1>=MIN_AREA_THRESH);

a_ism = a_ism(I,I);
