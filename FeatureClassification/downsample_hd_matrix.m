function b = downsample_hd_matrix(a)
%downsample distances of hd matrix

[I1, I2] = size(a);

factor = 4;

J1 = uint16(I1/factor);
J2 = uint16(I2/factor);

b = zeros(J1,J2);

j1=1;
for i1 = 1:factor:I1
    j2=1;
    for i2 = 1:factor:I2
        val = a(i1, i2);
        b(j1, j2) = val;  
        j2 = j2 + 1;
    end
    j1 = j1 +1;
end
