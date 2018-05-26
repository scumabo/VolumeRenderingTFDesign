function lookup_table = mirror_missing_distances( lookup_table )
%fills missing values of lookup table by mirroring

% expected: upper triangle is computed

N = size(lookup_table);

for row = 1:N
    for col = 1:N
        
        if (col ~= row)
            ut_value = lookup_table(col, row);
            lw_value = lookup_table(row, col);
            
            if (ut_value == 0)
                lookup_table(col, row) = lw_value;
            end
            
            if (lw_value == 0)
                 lookup_table(row, col) = ut_value;
            end
            
        end
    end
end