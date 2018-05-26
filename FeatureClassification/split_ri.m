function child_isos = split_ri(x_pos, axis_handle)
%splits current ri
global ISOS;
global CL_MEMBERS;
global LUT;
global AREA;
global I_THRESH;
global DATA_NAME;

%FIXME: turn off video clustering global DO_CLUSTERING_VIDEO;


%find closest centroid
[tmp2, idx] = min(abs(ISOS-x_pos));
ri = ISOS(idx);

%select sub table for members of ri only
[row_idx, col_idx] = find(CL_MEMBERS==ri);
isosc = CL_MEMBERS(row_idx, :);
isosc = isosc(abs(isosc) > 0);

i1 = find(I_THRESH==isosc(1));
i2 = find(I_THRESH==isosc(end));
child_lut = LUT(i1:i2, i1:i2);
n_members = size(isosc,2);

[a, I_area] = sort(AREA(i1:i2), 2, 'descend');

%I_area = 1:n_members;

lambda = pick_lambda( child_lut, 2 );

[cluster_table, isos2, member_stats] = mi_dpmeans( child_lut, lambda, I_area, axis_handle );
%[isos2, member_stats] = mi_clustering( child_lut, I_area, DATA_NAME, 2, axis_handle );

%map isos back to original map

n_children = size(isos2,1);
child_isos = zeros(n_children,1);
msg_children = sprintf('children centroids of %i: ', ri);
for n=1:n_children
    iso = isos2(n);
    child_isos(n) = isosc(iso);
    
    msg_children = sprintf('%s %i', msg_children, child_isos(n));
    if (n < n_children)
        msg_children = sprintf('%s, ', msg_children);
    end
end
helpdlg (msg_children );


