function dist = get_distance( lookup, iso1, iso2 )
tic
index = find(lookup(:,1) == iso1 & lookup(:,2) == iso2);
dist = lookup(index, 3);
toc