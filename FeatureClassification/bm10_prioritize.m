function [isovalues, weights, energies] = bm10_prioritize( lut )

clear ISO_QUEUE;
clear PRIO_QUEUE;
clear IDX;

global IDX;
global ISO_QUEUE;
global PRIO_QUEUE;

IDX = 1;

start_iso = 1;
prioritize( start_iso, lut );

% find most representative isovalues
n_isos = size(lut,1);
isovalues = zeros(n_isos, 1);
for i = 1:n_isos
    [maxPriority, maxIndex] = max(PRIO_QUEUE);
    isovalues(i) = ISO_QUEUE(maxIndex);
    iso_idx = isovalues(i) + 1 - start_iso;
    for j=1:n_isos
        iso2_idx = ISO_QUEUE(j) + 1 - start_iso;
       
        if j == maxIndex
            PRIO_QUEUE(j) = 0;
        else
            PRIO_QUEUE(j) = PRIO_QUEUE(j)/(1+lut(iso2_idx, iso_idx));
        end
    end
end

weights = 1:5:n_isos;
weights = n_isos - weights;
energies = zeros(n_isos, 1);

%%help function
function prioritize( start, V )

global IDX;
global ISO_QUEUE;
global PRIO_QUEUE;

n_isos = size(V,1);
vecSum = sum( V, 2 );
[SDv, maxindex] = max(vecSum/n_isos);

ISO_QUEUE(IDX) = maxindex+start-1;
PRIO_QUEUE(IDX) = SDv*n_isos;
IDX = IDX + 1;

v1_end_idx = maxindex -1;
if v1_end_idx >= 1
    V1 = V(1:v1_end_idx, 1:v1_end_idx);
    prioritize(start, V1);
end

v2_start_idx = maxindex+1;
if v2_start_idx <= n_isos
    V2 = V(v2_start_idx:n_isos,v2_start_idx:n_isos);
    prioritize(start+maxindex, V2);
end




