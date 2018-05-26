function vec = get_vector_area_weighted()
%returns rand vector with given number of isovalues

%FIXME: before use this, check if K is ok or replace with MAX_NUM_CLUSTERS

global AREA_TABLE;
global MAX_ISO;
global K;

step = uint16(MAX_ISO/K);
vec = [step:step:K*step];

for r = 1:K
    rvalue = vec(r);
    vec(r) = sum(rvalue >= cumsum(AREA_TABLE));
end

vec = validate_centroids( vec' );