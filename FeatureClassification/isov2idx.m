%% helpers convert idx in lookup table to isovalue and vise versa
function idx = isov2idx( isovalue )
%converts isovalue to idx in lookup table

global S_RATE;

%min value = 1, max value = max_iso
idx = (isovalue-1) / S_RATE + 1; 