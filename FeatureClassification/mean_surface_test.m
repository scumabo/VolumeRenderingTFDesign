function mean_surface_test(cluster_table, lut, data_name)
global BASE_DIR;

    %     % generate mean surface for each cluster;
%     for i = 1 : size(isos,2)
%         member = find(cluster_table==i);
%         mem_isos = I_thres(member);
%         mean_surface = zeros(64, 64, 64);
%         for j = 1 : size(mem_isos,2)
%             % read the DT volumeDataume
%             filename = sprintf('%s/%s/DT/%s_iso%0.2f.raw', BASE_DIR, data_name, data_name, mem_isos(j));
%             fid = fopen(filename); %open the file
%             dtvolumeDataTmp = fread(fid,[64*64 64],'float32'); %each slice will be a column
%             dtvolumeData = reshape(dtvolumeDataTmp,[64 64 64]); %reshape to the original dimensions
%             if ~nnz(mean_surface)
%                 mean_surface = dtvolumeData;
%             else
%                 mean_surface = min(mean_surface, dtvolumeData);
%             end
%             fclose(fid);
%         end
%         
%         % write mean_surface to raw file
%         precision = 'float32';
%         filename = sprintf('%s/%s/test/%s_cluster%0.2f.raw', BASE_DIR, data_name, data_name, i);
%         fid = fopen(filename, 'w');
%         
%         xMax = size(mean_surface, 1);
%         yMax = size(mean_surface, 2);
%         zMax = size(mean_surface, 3);
%         for z = 1:1:(zMax)
%             for y = 1:1:(yMax)
%                 fwrite(fid, double(mean_surface(:,y,z)), precision);
%             end
%         end
%         fclose(fid);
% 
%     end
    
% test mean_surface
do_min = true;
do_max = false;
do_mean = false;
do_mean_surface = true;
do_centroid = false;
I1 = 64;
I2 = 64;
I3 = 64;
start = [2, 23, 40, 58, 69];
range = [21,17, 18, 11, 21];
for i = 1 : size(start, 2)
    member = find(cluster_table==i);
    for count = 1:range(1, i)
        if count == 1
            mem_isos = start(1, i);
        else
            mem_isos = [mem_isos start(1, i)+count-1];
        end
    end
    
    if do_mean_surface
        %mem_isos = [23,24,25,26];
        mean_surface = zeros(I1, I2, I3);
        for j = 1 : size(mem_isos,2)
            % read the DT volumeDataume
            filename = sprintf('%s/%s/DT/%s_iso%0.2f.raw', BASE_DIR, data_name, data_name, mem_isos(j));
            fid = fopen(filename); %open the file
            dtvolumeDataTmp = fread(fid,[I1*I2 I3],'float32'); %each slice will be a column
            dtvolumeData = reshape(dtvolumeDataTmp,[I1 I2 I3]); %reshape to the original dimensions
            if ~nnz(mean_surface)
                mean_surface = dtvolumeData;
            else
                if do_min
                    mean_surface = min(mean_surface, dtvolumeData);
                    union_type = 'min';
                elseif do_mean
                    mean_surface = (mean_surface + dtvolumeData)/range(1, i);
                    union_type = 'mean';
                elseif do_max
                    mean_surface = max(mean_surface, dtvolumeData);
                    union_type = 'max';
                end
            end
            fclose(fid);
        end
        
        % write mean_surface to raw file
        precision = 'float32';
        filename = sprintf('%s/%s/test/raw/%s_cluster_%s_from%0.2fto%0.2f.raw', BASE_DIR, data_name, data_name, union_type, start(1,i), start(1,i)+range(1,i)-1);
        fid = fopen(filename, 'w');
        
        xMax = size(mean_surface, 1);
        yMax = size(mean_surface, 2);
        zMax = size(mean_surface, 3);
        for z = 1:1:(zMax)
            for y = 1:1:(yMax)
                fwrite(fid, double(mean_surface(:,y,z)), precision);
            end
        end
        fclose(fid);
        
        % convert raw to nrrd
        nrrd_name = sprintf('%s/%s/test/nrrd/%s_cluster_%s_from%0.2fto%0.2f.nrrd', BASE_DIR, data_name, data_name, union_type, start(1,i), start(1,i)+range(1,i)-1);
        command_nrrd = sprintf('unu make -i %s -t float -s %d %d %d -sp 0.48828125 0.48828125 0.6667 -e raw -o %s', filename, xMax, yMax, zMax, nrrd_name);
        status = system(command_nrrd, '-echo');
        
        % call ijkmcube to extract '0' isosurface of dt volume
        mean_surface_name = sprintf('%s/%s/test/mean_surfaces/%s_cluster_%s_from%0.2fto%0.2f.off', BASE_DIR, data_name, data_name, union_type, start(1,i), start(1,i)+range(1,i)-1);
        command_off = sprintf('ijkmcube -o %s %0.2f %s', mean_surface_name, 1, nrrd_name);
        status = system(command_off, '-echo');
        
        % calculate the distance between the mean_surface and the members
        for j = 1 : 88
            % current index isosurface and mean surface calculation
            mem_isosurface_name = sprintf('%s/%s/orig/%s_iso%0.2f.off', BASE_DIR, data_name, data_name, j+1);
            mean_surface_name = sprintf('%s/%s/test/mean_surfaces/%s_cluster_%s_from%0.2fto%0.2f.off', BASE_DIR, data_name, data_name, union_type, start(1,i), start(1,i)+range(1,i)-1);
            command_off = sprintf('mesh -val1 %s -val2 %s', mem_isosurface_name, mean_surface_name);
            [status,cmdout] = system(command_off, '-echo');
            
            temp_table(1, j) = j+1;
            temp_table(2, j) = str2double(cmdout);
        end
        
        filename = sprintf('%s/%s/test/%s_cluster_%s_from%0.2fto%0.2f.csv', BASE_DIR, data_name, data_name, union_type, start(1,i), start(1,i)+range(1,i)-1);
        csvwrite(filename, temp_table);
    end
    
    if do_centroid
        %create table with all HDs for current cluster
        cluster_hd_table = lut(mem_isos, mem_isos);   

        %sum all rows to get HD sum for all candidate centroids
        ccand_hd_sums = sum( cluster_hd_table, 2 );
        
        %member with shortest sum of HD distances becomes new centroid
        min_hd_sum = min( ccand_hd_sums );
        idx_new_centroid = find( ccand_hd_sums == min_hd_sum ); 
        idx_new_centroid1 = idx_new_centroid(1,1); % if there are multiple min
                                                   % take the first as centroid     
        new_centroid = mem_isos( idx_new_centroid1 ); %isovalue of new centroid
        
        for j = 1 : 88
            temp_table(1, j) = j+1;
            temp_table(2, j) = lut(j+1, new_centroid );
            
        end
       
        filename = sprintf('%s/%s/test/%s_cluster_isosurface_from%0.2fto%0.2f.csv', BASE_DIR, data_name, data_name, start(1,i), start(1,i)+range(1,i)-1);
        csvwrite(filename, temp_table);

    end
    
    
end

end
