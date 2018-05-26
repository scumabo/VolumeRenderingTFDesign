function batch_fix_meshes( )
%batch process to clean meshes from duplicate vertices

dirname = '/blank0/data/manix128/mis/29';

%for dir orig
subdir = sprintf('%s/orig', dirname);
batch_convert_off_in_dir( subdir );

subdirs = { 'dct', 'wt', 'ta' };
n_subdirs = size( subdirs, 2 );

for s = 1:n_subdirs
    subdirname = subdirs{s};
    subdir = sprintf('%s/%s', dirname, subdirname);
    files = dir( subdir );  
    
    % if file idx has ratio subdirs
    dir_idx = find( [files.isdir] );
    n_ratio_dirs = length(dir_idx);
    if (n_ratio_dirs > 2)
        for d = 1:n_ratio_dirs
            subsubdirname = files(d).name ;
            if ( ~strcmp(subsubdirname, '.') && ~strcmp(subsubdirname, '..'))
                subsubdir = sprintf('%s/%s', subdir, subsubdirname);
                batch_convert_off_in_dir( subsubdir );
            end
        end
    end
    
end


function batch_convert_off_in_dir( subdir )
%converts off files given a file index (within a directory)

files = dir( subdir );
file_idx = find( ~[files.isdir] );
n_files = length(file_idx);

parpool();

parfor f = 1:n_files
    
    filename = files(file_idx(f)).name;
    
    if (strfind(filename, 'off'))
        
        fprintf('processing %s ... ' , filename);
        
        fix_duplicate_vertices( subdir, filename );
        
        fprintf('done\n' );
        
    end
   
end

delete(gcp);

