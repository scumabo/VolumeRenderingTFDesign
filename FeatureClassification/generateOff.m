function generateOff ( isovalue, dataname )

global BASE_DIR;
global IN_DIR;


command = sprintf('/blank0/bin/ijkmcube -o %s/%s_iso%0.2f.off %0.2f %s/%s/%s.nrrd', IN_DIR, dataname, isovalue, isovalue, BASE_DIR, dataname, dataname);
[status, cmdout] = system(command, '-echo');