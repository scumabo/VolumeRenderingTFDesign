function mi_table = run_clustering_experiments()
%run clustering experiments for vis14 paper

clearvars;
clc;
close all;


global BASE_DIR;
global MESH_DATA_DIR;

BASE_DIR = '/blank0/data';
MESH_DATA_DIR = sprintf('%s/mesh_out_asym', BASE_DIR);

global IS_SYMMETRIC;
IS_SYMMETRIC = true;

global USE_AREA_UPD_CENTROIDS;
USE_AREA_UPD_CENTROIDS = false;

global USE_MAX_HD;
USE_MAX_HD  = false;

global MAX_NUM_CLUSTERS;
MAX_NUM_CLUSTERS = 20;

global DO_EXACT_NUM_CLUSTERS;
DO_EXACT_NUM_CLUSTERS = true;
global NUM_CLUSTERS;
NUM_CLUSTERS = 4;

global MERGE_HAPPY_THRESH;
MERGE_HAPPY_THRESH = 1.5; %manix/hnut0.75;  % manix: 1.5
global MIN_AREA_THRESH;
MIN_AREA_THRESH = 5000; %previously 60;

global LAMBDA;
LAMBDA = 2;
global ISO_OFFSET;
ISO_OFFSET = 0;

global DO_MANIX;
global DO_NEGHIP;
global DO_HNUT128;
global DO_ENGINE;
global DO_CARP;
global DO_GMM1;
global DO_GMM2;
global DO_GMM3;
global DO_HYDROGEN;
global DO_ML;
global DO_FS;
global DO_MANIX64;


DO_NEGHIP = false;
DO_MANIX = true;
DO_HNUT128 = false;
DO_ENGINE = false;
DO_CARP = false;
DO_GMM1 = false;
DO_GMM2 = false;
DO_GMM3 = false;
DO_HYDROGEN = false;
DO_ML = false;
DO_FS = false;

row_idx = 1;

if (DO_HYDROGEN)
    data_name = 'hydrogen';
    mis = cluster_one_dataset(data_name );
    mi_table(row_idx, :) = mis';
    row_idx = row_idx + 1;
end

if (DO_GMM1)
    data_name = 'gmm1';
    mis = cluster_one_dataset(data_name );
    mi_table(row_idx, :) = mis';
    row_idx = row_idx + 1;
end


if (DO_GMM2)
    data_name = 'gmm2';
    mis = cluster_one_dataset(data_name );
    mi_table(row_idx, :) = mis';
    row_idx = row_idx + 1;
end

if (DO_GMM3)
    data_name = 'gmm3';
    mis = cluster_one_dataset(data_name );
    mi_table(row_idx, :) = mis';
    row_idx = row_idx + 1;
end

if (DO_CARP)
    data_name = 'carp1';
    mis = cluster_one_dataset(data_name );
    mi_table(row_idx, :) = mis';
    row_idx = row_idx + 1;
end


if (DO_ENGINE)
    data_name = 'engine2';
    mis = cluster_one_dataset(data_name );
    mi_table(row_idx, :) = mis';
    row_idx = row_idx + 1;
end

if (DO_HNUT128)
    data_name = 'hnut128';
    mis = cluster_one_dataset(data_name );
    mi_table(row_idx, :) = mis';
    row_idx = row_idx + 1;
end

if ( DO_NEGHIP )
    data_name = 'neghip';
    mis = cluster_one_dataset(data_name );
    mi_table(row_idx, :) = mis';
    row_idx = row_idx + 1;
end

if ( DO_MANIX )
    data_name = 'manix128';
    mis = cluster_one_dataset(data_name );
    mi_table(row_idx, :) = mis';
    row_idx = row_idx + 1;
end

if ( DO_MANIX64 )
    data_name = 'manix';
    mis = cluster_one_dataset(data_name );
    mi_table(row_idx, :) = mis';
    row_idx = row_idx + 1;
end

if ( DO_ML)
    data_name = 'marschnerlobb';
    mis = cluster_one_dataset(data_name );
    mi_table(row_idx, :) = mis';
    row_idx = row_idx + 1;
end

if ( DO_FS )
    data_name = 'lambda3D';
    mis = cluster_one_dataset(data_name );
    mi_table(row_idx, :) = mis';
    row_idx = row_idx + 1;
end

filename = sprintf( '%s/mean_isos/%imis.csv', BASE_DIR, NUM_CLUSTERS );
csvwrite( filename, mi_table );






