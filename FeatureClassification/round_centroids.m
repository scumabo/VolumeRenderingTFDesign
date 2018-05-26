function centroids = round_centroids( centroids )
%rounds centroids to 0.25 precision

global S_RATE;

numerator = S_RATE * 100;
num_centroids = size(centroids,1);
for k = 1:num_centroids
   rounded_center_k = round_value(centroids(k,1), numerator, 100);
   centroids(k,1) = rounded_center_k;    
end