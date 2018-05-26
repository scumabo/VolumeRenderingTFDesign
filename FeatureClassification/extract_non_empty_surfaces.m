%% helper count non-empty clusters
function vec = extract_non_empty_surfaces( vec_in )
global AREA_TABLE;
global MIN_AREA_THRESH;

j = 1;
for i = 1:size(vec_in, 1)
    if AREA_TABLE(vec_in(i)) > MIN_AREA_THRESH
        vec(j, 1) = vec_in(i);
        j = j+1;
    end
end