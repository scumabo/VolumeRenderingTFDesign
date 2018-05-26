%% helpers convert idx in lookup table to isovalue and vise versa
function isovalue = idx2isov( idx )
%converts isovalue to idx in lookup table

global S_RATE;

%min value = 1, max value = max_iso
isovalue = (idx - 1) * S_RATE + 1; 