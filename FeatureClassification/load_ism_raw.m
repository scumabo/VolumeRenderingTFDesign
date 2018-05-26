function a_ism = load_ism_raw( dir, filename, do_invert )
%loads png of isosurface sim. map

fn_ism = fullfile(dir, filename );

if exist( fn_ism, 'file' )
    % File exists.  Do stuff....
    fid = fopen(fn_ism);
    if (fid == -1)
        h = errordlg('cannot read from file "%s"', path);
    end
    
    n_isos = 256;
    tmp = fread( fid, n_isos*n_isos, 'single' );
    
    a_ism = reshape( tmp, [n_isos n_isos]);
    
    if (do_invert)
        a_ism = 1 - a_ism;
    end
    
else
    % File does not exist.
    warningMessage = sprintf('Warning: file does not exist:\n%s', fn_ism);
    uiwait(msgbox(warningMessage));
    a_ism = zeros(200,200);
end

