function isos_sorted = priorize_isovalues( isos, area_table )
%returns rand vector with given number of isovalues

%x = sum(isovalue >= cumsum(area_table));
area_table = get_area_weights( area_table )';

nisos = size(isos, 1);
weights = zeros(nisos,1);

for isov = 1:nisos
    isovalue = isos(isov);
    x = area_table(isovalue);
    weights(isov) = x;
end
I = 0;
for isov = 1:nisos
    weight = weights(isov);
    if (weight < 0.00001)
        if (I == 0)
            I = isov;
        else
            I(end+1) = isov;
        end
    end
end

isos = isos(setdiff(1:nisos,I),:);
weights = weights(setdiff(1:nisos,I),:);

nisos = size(isos, 1);
isos_sorted= zeros(nisos,1);

for isov = 1:nisos
    idx = find(weights == max(weights));
    isos_sorted(isov) = isos(idx);
    weights(idx) = 0;
end

