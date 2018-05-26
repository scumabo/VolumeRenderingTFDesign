function vec = init_guess_clustering()
%initial guess based on isosurface area

global AREA_TABLE;
global N_ISOS;
global MAX_NUM_CLUSTERS;

cum_area_len= 0;

prev_y = AREA_TABLE(1);
prev_x = 1;

cum_area_len = 0;

for x = 2:N_ISOS
   y = AREA_TABLE(x);
   
   dist = sqrt((x-prev_x).^2 + (y-prev_y).^2);
   cum_area_len(end+1) = cum_area_len(end) + dist;
   
   prev_x = x;
   prev_y = y;
    
end

num_dist = size(cum_area_len,2);

start =cum_area_len(2);
step = (cum_area_len(num_dist) - start )/ MAX_NUM_CLUSTERS;

last_s = 3;
vec = zeros(MAX_NUM_CLUSTERS,1);
for p = 1:MAX_NUM_CLUSTERS
    thresh = start + p*step;
    
    s = last_s+1;
    
    if (s > num_dist)
        return;
    end
    val = cum_area_len(s);
    
    %FIXME: if same, skip
    
    while (val < thresh )
        s = s+1;
        if (s > num_dist)
            return;
        end
        val  = cum_area_len(s);
    end
    vec(p) = s;
    last_s = s;
end

    

