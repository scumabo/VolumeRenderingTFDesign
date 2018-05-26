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
end