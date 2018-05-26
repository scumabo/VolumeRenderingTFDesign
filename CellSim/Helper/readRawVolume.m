function [scalarVolume, I1, I2, I3, S1, S2, S3] = readRawVolume(data_name) 

if strcmp(data_name, 'manix.raw')
    I1 = 128;
    I2 = 128;
    I3 = 115;
    
    S1 = 0.48828125;
    S2 = 0.48828125;
    S3 = 0.66669999999999996;
    
    % read raw volume
    fid = fopen(data_name);
    scalarVolume = fread(fid, [I1*I2 I3], 'uint8' );
    scalarVolume = reshape(scalarVolume, [I1 I2 I3]);
    fclose(fid);
end

if strcmp(data_name, 'tooth.raw')
    I1 = 256;
    I2 = 256;
    I3 = 161;
    
    S1 = 1;
    S2 = 1;
    S3 = 1;
    
    % read raw volume
    fid = fopen(data_name);
    tmp = fread( fid, [I1*I2 I3], 'uint8' );
    scalarVolume = reshape( tmp, [I1 I2 I3]);
    fclose(fid);
    
end

if strcmp(data_name, 'bonsai.raw')
    I1 = 256;
    I2 = 256;
    I3 = 256;
    
    S1 = 1;
    S2 = 1;
    S3 = 1;
    
    % read raw volume
    fid = fopen(data_name);
    tmp = fread( fid, [I1*I2 I3], 'uint8' );
    scalarVolume = reshape( tmp, [I1 I2 I3]);
    fclose(fid);
    
end

if strcmp(data_name, 'turbulent_combustion.raw')
    I1 = 128;
    I2 = 256;
    I3 = 32;
    
    S1 = 1;
    S2 = 1;
    S3 = 1;
    
    % read raw volume
    fid = fopen(data_name);
    tmp = fread( fid, [I1*I2 I3], 'uint8' );
    scalarVolume = reshape( tmp, [I1 I2 I3]);
    fclose(fid);
    
end

if strcmp(data_name, 'fuel.raw')
    I1 = 64;
    I2 = 64;
    I3 = 64;
    
    S1 = 1;
    S2 = 1;
    S3 = 1;
    
    % read raw volume
    fid = fopen(data_name);
    tmp = fread( fid, [I1*I2 I3], 'uint8' );
    scalarVolume = reshape( tmp, [I1 I2 I3]);
    fclose(fid);
    
end
