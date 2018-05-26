function lut = load_approx_isosim_table( data_name, appendix )
%loads ism table form png and inverts it

global MESH_DATA_DIR;

%fn_area = sprintf('%s/%s__area.csv', MESH_DATA_DIR, data_name );
%a_area1 = csvread( fn_area );

tic

load(sprintf('%s/%s_approx_isosim_%s.mat', MESH_DATA_DIR, data_name, appendix ));
a_propose = 1 - similarity_table;

toc

%%replace NaN values by max hd value in current table
%FIXME: not sure, if this is correct handling
%Bo: need to be tested
a_propose = replaceNaNbyMax( a_propose );

%indices that are skipped to do mapping to isovalues

lut = a_propose;



function mat = replaceNaNbyMax( mat )
%rplaces NaN values by max available value
max_val = max(max(mat));
nels = size(mat,1);

for col = 1:nels
    for row = 1:nels
        if (isnan(mat(row,col)))
            mat(row,col) = max_val;
        end
    end
end