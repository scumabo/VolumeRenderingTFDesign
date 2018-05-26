clc;
clear tmp;
clear raw_volume;
clear fid;

% parameters
store_path_name = 'C:\Users\XiaoBo\Desktop\test_table';
path_name = 'D:\Documents\Research Papers\Research 2014\GI2014\Data\';
data_name = 'bonsai128';
raw_file_name = sprintf('%s/%s/%s.raw', path_name, data_name, data_name );

I1 = 128;
I2 = 128;
I3 = 64;

% read raw volume
fid = fopen(raw_file_name);
tmp = fread( fid, [I1*I2 I3], 'uint8' );
raw_volume = reshape( tmp, [I1 I2 I3]);
fclose(fid);

%raw_volume(128, 128, 115:128) = 0;

% call function
[m,n,p] = size(raw_volume);
[X,Y,Z] = meshgrid(1:n,1:m,1:p);

% Generate all the points
% PT = zeros(I1*I2*I3, 3);
% for i = 1:I1
%     for j = 1:I2
%         for k = 1:I3
%             PT(I2*I3*(i-1)+I3*(j-1)+k, :) = [i, j, k]; 
%         end
%     end
% end
% OC = OcTree(PT);
% a = 1;

%gen_vol_octree(raw_volume);
gen_similarity_iso_table2( raw_volume, data_name, store_path_name );
% fv = isosurface(raw_volume,3);
% p = patch(fv);
% isonormals(X,Y,Z,raw_volume,p)
% set(p,'FaceColor','red','EdgeColor','none');
% daspect([1,1,1])
% view(3); axis tight
% camlight 
% lighting gouraud
 %[F,V,col] = MarchingCubes(X,Y,Z,raw_volume, 255);