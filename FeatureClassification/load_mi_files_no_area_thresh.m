function [a_mean, a_max] = load_mi_files_no_area_thresh( data_name )
%loads related files

global IS_SYMMETRIC;
global MESH_DATA_DIR;
global MAX_ISO;

%fn_area = sprintf('%s/%s__area.csv', MESH_DATA_DIR, data_name );
fn_hd_max = sprintf('%s/%s_lookup_table_hd_max.csv', MESH_DATA_DIR, data_name );
fn_hd_mean = sprintf('%s/%s_lookup_table_hd_mean.csv', MESH_DATA_DIR, data_name );


% if exist( fn_area, 'file' )
%   % File exists.  Do stuff....
%   a_area1 = csvread( fn_area );
% 
% else
%   % File does not exist.
%   warningMessage = sprintf('Warning: file does not exist:\n%s', fn_area);
%   uiwait(msgbox(warningMessage));
%   a_area1 = zeros(1,200);
% end

if exist( fn_hd_mean, 'file' )
  % File exists.  Do stuff....
  a_mean = csvread( fn_hd_mean );

else
  % File does not exist.
  warningMessage = sprintf('Warning: file does not exist:\n%s', fn_hd_mean);
  uiwait(msgbox(warningMessage));
  a_mean = zeros(200,200);
end

if exist( fn_hd_max, 'file' )
  % File exists.  Do stuff....
  a_max = csvread( fn_hd_max );
  
else
  % File does not exist.
  warningMessage = sprintf('Warning: file does not exist:\n%s', fn_hd_max);
  uiwait(msgbox(warningMessage));
  a_max = zeros(200,200);
end

if (IS_SYMMETRIC)
    
%     %% check symmetry
%     check_m_symmetry( a_mean );
%     check_m_symmetry( a_max );
%     lookup_table = mirror_missing_distances( lookup_table );
%     csvwrite(filename2,lookup_table);

   %create symmetric Hausdorff distance table
   a_max = create_symm_hd_table( a_max );
   a_mean = create_symm_hd_table( a_mean );
end

% make area-diff table
% a_area = zeros(n_isos, n_isos);
% 
% for col = 1:n_isos
%     for row = 1:n_isos
%         a1 = a_area1(col);
%         a2 = a_area1(row);
%         a_diff = abs(a1-a2);
%         a_area(row, col) = a_diff;
%     end
% end

%%replace NaN values by max hd value in current table
%FIXME: not sure, if this is correct handling
%Bo: tested it is OKay
a_max = replaceNaNbyMax( a_max );
a_mean = replaceNaNbyMax( a_mean );


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
