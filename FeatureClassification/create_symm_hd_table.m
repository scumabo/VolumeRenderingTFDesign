function mat = create_symm_hd_table( mat )
%creates symmetric hd table

nels = size(mat,1);

for col = 1:nels
    for row = col:nels
        val1 = mat(row,col);
        val2 = mat(col, row);
        sym_hd = max(val1,val2);
        mat(row,col) = sym_hd;
        mat(col, row) = sym_hd;
    end
end
