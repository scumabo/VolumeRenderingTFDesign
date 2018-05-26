function fix_duplicate_vertices( dirname, filename )
% slightly repositions duplicated vertices in off files

path = fullfile(dirname, filename);

[vert, faces] = read_off( path );

if ~exist('vert','var')
    error('The vertex list (vert) must be specified.');
end
if ~exist('faces','var')
    error('The vertex connectivity of the triangle faces (faces) must be specified.');
end

vnew = vert';
n_duplicates = Inf;
eps = 0.0001;
while (n_duplicates > 1)
    % find unique/duplicate rows (vertices)
    [tmp, indexm, indexn] =  unique(vnew, 'rows', 'stable');
    
    % search most frequent vertex
    m = mode( indexn );
    duplicates = find( indexn==m );
    
    % move the vertices with the indices n
    n_duplicates = size(duplicates,1);
    
    for d = 2:n_duplicates
        
        pos = duplicates(d);
        v = vnew(pos, :);
        v = v + eps * d;
        vnew(pos, :) = v;   
        
    end   
end


renormalize = 0;
write_off( path, vnew, faces, renormalize);
