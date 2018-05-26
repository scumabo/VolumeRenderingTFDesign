function a_ism = load_ism_png( dir, filename, do_invert )
%loads png of isosurface sim. map


fn_hd_ism = fullfile(dir, filename );

fid = fopen(fn_hd_ism);
if (fid == -1)
   h = errordlg('cannot read from file "%s"', path);   
end


a_ism = imread( fn_hd_ism );
a_ism = rgb2gray(a_ism);

a_ism = imrotate(a_ism, -90);
if (do_invert)
    a_ism = invertIm(a_ism);
end

a_ism = im2double(a_ism);
%figure, imshow(a_ism,[]);impixelinfo;