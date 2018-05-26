function Octree_tables = load_octree_table( data_name )
%loads ism table form png and inverts it

global MESH_DATA_DIR;

%fn_area = sprintf('%s/%s__area.csv', MESH_DATA_DIR, data_name );
%a_area1 = csvread( fn_area );

load(sprintf('%s/%s', MESH_DATA_DIR, data_name ));

for i = 1 : size(Octree_tables, 1)
    Octree_tables{i} = replaceNaNbyMax(1 - min(Octree_tables{i}, Octree_tables{i}'));
end


