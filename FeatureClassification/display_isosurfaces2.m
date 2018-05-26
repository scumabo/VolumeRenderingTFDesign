function display_isosurfaces2( data_name, isos, isos_title )
%displays isosurfaces in array


global BASE_DIR;

path = sprintf('%s/%s/screenshots/smooth/%s_iso%02d.png', BASE_DIR, data_name, data_name, 1 );

fid = fopen(path);
if (fid == -1)
   errordlg('cannot read from file "%s"', path);   
end
fclose(fid);

im1 = imread(path);
[m,n,l] = size(im1);

n_isos = max(size(isos,2), size( isos, 1));
n_cols = floor(sqrt(n_isos));
n_rows = ceil(n_isos / n_cols);

figure; 

counter = 1;

for row = 0:(n_rows-1)
    for col = 0:(n_cols-1)
        
        if (counter <= n_isos)
            iso = isos(counter);
            if (iso > 0)
                fn_im = sprintf('%s/%s/screenshots/smooth/%s_iso%02d.png', BASE_DIR, data_name, data_name, iso );
                im = imread(fn_im);
                
                subplot(n_rows, n_cols, counter), imshow(im, 'Border','tight'); title(sprintf('iso = %i', iso));
                set(gca,'XTick',[]);
                set(gca,'YTick',[]);
      
            end
            
        end
        
        counter = counter + 1;
        
    end %cols
end %rows

