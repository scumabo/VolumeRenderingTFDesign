function check_m_symmetry( mat )
%check symmetry in matrix

[I1, I2] = size(mat);

if (I1 ~= I2 )
    error('size of matrix is not symmetric');
end

for row = 1:I1
    for col = row:I2
        val_a = mat(col,row);
        val_b = mat(row, col);
        
        if (val_a ~= val_b)
            error('detected asymmetric value pair (%i,%i)', row, col);
        end
        
    end
end

