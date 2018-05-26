function display_isosurfaces( data_name, isos, isos_title )
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

offset = 5;
img = ones(n_rows*(m+offset)+offset, n_cols*(n+offset)+offset, l);
img = img * 180;

img = uint8(img);

counter = 1;

for row = 0:(n_rows-1)
    for col = 0:(n_cols-1)
        
        if (counter <= n_isos)
            iso = isos(counter);
            if (iso > 0)
                fn_im = sprintf('%s/%s/screenshots/smooth/%s_iso%02d.png', BASE_DIR, data_name, data_name, iso );
                im = imread(fn_im);
                
                s_row = row * (m+2*offset) +1;
                e_row = s_row + m -1;
                s_col = col * (n+2*offset) + 1;
                e_col = s_col + n -1;
                img(s_row:e_row,s_col:e_col, :) = im;
            end
            
        end
        
        counter = counter + 1;
        
    end %cols
end %rows

figure, imshow(img,[]); title(isos_title);
