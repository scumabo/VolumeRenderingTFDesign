function varargout = play(varargin)
% PLAY MATLAB code for play.fig
%      PLAY, by itself, creates a new PLAY or raises the existing
%      singleton*.
%
%      H = PLAY returns the handle to a new PLAY or the handle to
%      the existing singleton*.
%
%      PLAY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLAY.M with the given input arguments.
%
%      PLAY('Property','Value',...) creates a new PLAY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before play_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to play_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help play

% Last Modified by GUIDE v2.5 23-Sep-2017 15:37:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @play_OpeningFcn, ...
                   'gui_OutputFcn',  @play_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before play is made visible.
function play_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to play (see VARARGIN)

% Choose default command line output for play
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes play wait for user response (see UIRESUME)
% uiwait(handles.figure1);
clc;

%default values
global DO_MANIX;
global MIN_AREA_THRESH;

global DATA_NAME;
global MESH_DATA_DIR;
global ISO_OFFSET;
global BASE_DIR;
global IS_SYMMETRIC;
global LUT_TITLE;      % name of the similarity table
global LUT;
global AREA;
global DO_SMALL_ISOS;
global I1;
global I2;
global NUM_CLUSTERS;
global MIN_ISO;
global MAX_ISO;             % what is this?
global NUM_ISOVALUES;
global I_THRESH;
global I_AREA;
global DO_CLUSTERING_VIDEO;
global DO_MERGE_SMALLS;
global AREA_PERCENTAGE;
global MERGE_HAPPY_THRESH;
global NUM_K_INIT;
global CLUSTERING_TYPE;
global BATCH_SEEDS;
global KMEANS_DO_MERGING;
global TwoD_TF;
global MIN_GRADIENT;
global NUM_GRADIENT;
global VOLUME;
global VOLUME_GRADIENT;
global D1;
global D2;
global D3;
global VOL_DOWNSAMPLE;

global isoMinThres;
global isoMaxThres;


IS_SYMMETRIC = true;
DO_MANIX = true;
MIN_AREA_THRESH = 1;
LUT_TITLE = 'mean Hausdorff distance';
DATA_NAME = 'manix128';
ISO_OFFSET = 0;
DO_SMALL_ISOS = false;
DO_MERGE_SMALLS = false;
KMEANS_DO_MERGING =false;
LUT = [];
AREA = [];
I1 = 0;
I2 = 0;
NUM_CLUSTERS = 0;
MIN_ISO = 1;
MAX_ISO = 0;
NUM_ISOVALUES = 0;
I_THRESH = [];
I_AREA = [];
DO_CLUSTERING_VIDEO = false;
AREA_PERCENTAGE = 0.5;
MERGE_HAPPY_THRESH = 0.5;
BATCH_SEEDS = false;
TwoD_TF = false;
D1=128;
D2=128;
D3=115;
VOL_DOWNSAMPLE = false;

% make sure the data source is correct
values = inputdlg({'Enter your data base directory:' }, 'data directory', 1,{ './' });
BASE_DIR = values{1};

values = inputdlg({'Enter your metrics directory:' }, 'metric directory', 1,{ 'metrics' });
tmp = values{1};
MESH_DATA_DIR = sprintf('%s/%s', BASE_DIR, tmp);

init_datasets();

CLUSTERING_TYPE = 1; %k-means

init_kmeans(handles);



% --- Outputs from this function are returned to the command line.
function varargout = play_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in menu_datasets.
function menu_datasets_Callback(hObject, eventdata, handles)
% hObject    handle to menu_datasets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_datasets contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_datasets

global DATA_NAME;


contents = cellstr(get(hObject,'String'));
DATA_NAME = contents{get(hObject,'Value')};
init_datasets();
init_kmeans(handles);


% --- Executes during object creation, after setting all properties.
function menu_datasets_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_datasets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in menu_luts.
function menu_luts_Callback(hObject, eventdata, handles)
% hObject    handle to menu_luts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_luts contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_luts

global LUT_TITLE;

contents = cellstr(get(hObject,'String'));
LUT_TITLE = contents{get(hObject,'Value')};

init_kmeans(handles);

% --- Executes during object creation, after setting all properties.
function menu_luts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_luts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% bomain
% --- Executes on button press in kmeans_button.
function kmeans_button_Callback(hObject, eventdata, handles)
% hObject    handle to kmeans_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global DATA_NAME;
global LUT;
global ISOS;
global DO_MERGE_SMALLS;
global NUM_K_INIT;
global MIN_ISO;
global TwoD_TF;
global LUT_TITLE;
global NUM_GRADIENT;
global MIN_GRADIENT;
global NUM_ISOVALUES;
global D1;
global D2;
global D3;
global VOL_DOWNSAMPLE;
global VOLUME;
global VOLUME_GRADIENT;
global isoMinThres;

%init_kmeans( handles );
tic
[isos0, member_stats, cluster_table] = mi_clustering( LUT, NUM_K_INIT, handles.lut_axis );

%[isos0, member_stats, cluster_table] = k_center_clustering( LUT, NUM_K_INIT, handles.lut_axis );

if ~TwoD_TF
    if (DO_MERGE_SMALLS)
        member_stats = merge_small_clusters( isos0, cluster_table, LUT, member_stats );
    end
    
    ISOS = sort(isos0);
    
    n_clusters = max(size(ISOS,1), size(ISOS,2));
    set(handles.text_status, 'String', sprintf('found %i clusters', n_clusters));
    
    create_global_clusters( cluster_table, ISOS );
    
    ISOS  = ISOS + isoMinThres -1;
    
    %display hd map and its representative isosurfaces
    plot_ris(ISOS, member_stats(:,2), member_stats(:,6), handles.lut_axis, 'white', 2, '+' );
%     xlabel('Isovalue', 'Fontsize', 15);
%     ylabel('Isovalue', 'Fontsize', 15);
%     set(gca,'xaxisLabelLocation','bottom');
    
    %display representative isovalues
    display_isovalues( handles.text_isos, ISOS );
%     export_fig(handles.lut_axis, 'C:\Users\XiaoBo\Desktop\test_image\manix128_overlap_cluster14','-png');
    contents = cellstr(get(handles.WeighintSchema,'String'));
    weighting = contents{get(handles.WeighintSchema,'Value')};
    
    lvl = get(handles.octreeLevel,'String');
    
    
    if strcmp(weighting, 'Level')
        export_fig(handles.lut_axis, sprintf('C:/Users/XiaoBo/Desktop/test_image/%s_%s_%s_clustered', DATA_NAME, LUT_TITLE, lvl),'-png');
    else
        export_fig(handles.lut_axis, sprintf('C:/Users/XiaoBo/Desktop/test_image/%s_%s_%s_clustered', DATA_NAME, LUT_TITLE, weighting),'-png');
    end
    
    
else    % 2D TF histogram classification
    
    % Map scalar value to (intensity, gradient) pair and attach classified label to
    % each member output the cluster centroids (data pair).
    
    C_intensity = ceil(member_stats(:,1)/(NUM_GRADIENT)-1);   % index for isovalue starting from 0
    C_gradient = member_stats(:,1) - C_intensity*NUM_GRADIENT;
    vol_itensity = C_intensity + isoMinThres;
    vol_gradient = C_gradient + MIN_GRADIENT - 1;
    
    isos1  = member_stats(:,1) + isoMinThres -1;
    
    n_clusters = max(size(vol_itensity,1), size(vol_itensity,2));
    set(handles.text_status, 'String', sprintf('found %i clusters', n_clusters));
    
    %display hd map and its representative isosurfaces
    plot_ris(isos1, member_stats(:,2), member_stats(:,6), handles.lut_axis, 'white', 2, '+' );
    
    %display representative isovalues
    display_isovalue_gradient( handles.text_isos, vol_itensity, vol_gradient );
    
    %display the classified 2D TF histogram 
    scalars = cluster_table';
    TF_histogram = zeros(NUM_GRADIENT, NUM_ISOVALUES);
    for i = 1:size(scalars,2)
        [intensity, gradient] = scaler_to_pair(i);
        TF_histogram(gradient, intensity) = scalars(i);
    end
    
    figure
    % color map for bonsai
%     cmap=[
%           58 95 11
%           223 194 128
%           128 205 193
%           94 60 153
%           44 123 182
%           166 97 26
%      ];
 
%      cmap=[
%           58 95 11
%           223 194 128
%           223 194 128
%           166 97 26
%           166 97 26
%           166 97 26
%     ];
%     cmap=[
%           43 131 186
%           215 25 28
%           227 146 100
%           171 221 164
%      ];
 
% tooth
  cmap=[
          170 170 255
          223 194 128
          255 85 255
          170 0 0 
          0 85 0
          0 0 255
          170 170 0
     ];
 
 
 %   imshow(TF_histogram/n_clusters);
  imagesc(TF_histogram/n_clusters);
  colormap(cmap/255);
 %   colormap('default');
  %  colorbar;
    
    axis off
    set(gca,'YDir','normal')
    hold on
    plot(vol_itensity(:), vol_gradient(:), 'ok','MarkerSize',5)
%     export_fig(gcf, sprintf('C:/Users/XiaoBo/Desktop/test_image/%s_Clusters_%d', DATA_NAME, n_clusters),'-png');
%     plot(VOLUME(:),VOLUME_GRADIENT(:),'+w','MarkerSize',1)   
%     export_fig(gcf, sprintf('C:/Users/XiaoBo/Desktop/test_image/%s_Clusters_%d+data', DATA_NAME, n_clusters),'-png');
    

%% Visualize the 'Examplar Surface'
%     for i = 1:n_clusters
%         if VOL_DOWNSAMPLE
%             display_surface_raw(vol_itensity(i), vol_gradient(i), 16, 16, 16, i);
%         else
%             display_surface_raw(vol_itensity(i), vol_gradient(i), D1, D2, D3, i);
%         end 
%         
%     end


end
toc
% help function: map a scalar value to(intensity, gradient)
function [intensity, gradient] = scaler_to_pair(scalar)
global MIN_ISO;
global NUM_GRADIENT;
global MIN_GRADIENT;

C_intensity = ceil(scalar/(NUM_GRADIENT)-1);
C_gradient = scalar - C_intensity*NUM_GRADIENT;
intensity = C_intensity + MIN_ISO;
gradient = C_gradient + MIN_GRADIENT - 1;
    
% help function: visualize generated cell
function display_surface_raw(vol_itensity, vol_gradient, D1, D2, D3, groupNum)
global VOLUME;
global VOLUME_GRADIENT;

n = [D1 D2 D3]-1; % number of cells along each direction of imageW

% find the min and max for each cell
intensity_min = Inf(n);
intensity_max = -Inf(n);
gradient_min = Inf(n);
gradient_max = -Inf(n);

vertex_idx = {1:n(1), 1:n(2), 1:n(3); ...
    2:n(1)+1, 1:n(2), 1:n(3); ...
    2:n(1)+1, 2:n(2)+1, 1:n(3); ...
    1:n(1), 2:n(2)+1, 1:n(3); ...
    1:n(1), 1:n(2), 2:n(3)+1; ...
    2:n(1)+1, 1:n(2), 2:n(3)+1; ...
    2:n(1)+1, 2:n(2)+1, 2:n(3)+1; ...
    1:n(1), 2:n(2)+1, 2:n(3)+1 };

for ii=1:8                             % loop thru vertices of all cells
    intensity_min = min(VOLUME(vertex_idx{ii, :}), intensity_min);
    intensity_max = max(VOLUME(vertex_idx{ii, :}), intensity_max);
    
    gradient_min = min(VOLUME_GRADIENT(vertex_idx{ii, :}), gradient_min);
    gradient_max = max(VOLUME_GRADIENT(vertex_idx{ii, :}), gradient_max);
end

[row, col, slice] = ind2sub(n, find(intensity_min < vol_itensity & intensity_max > vol_itensity & gradient_min < vol_gradient & gradient_max > vol_gradient));
voxel_indices = [row, col, slice;
    row+1, col, slice;
    row+1, col+1, slice;
    row+1, col, slice+1;
    row, col+1, slice;
    row, col, slice+1;
    row, col+1, slice+1;
    row+1, col+1, slice+1;];
voxel_indices = unique(voxel_indices, 'rows');
index = sub2ind(n+1, voxel_indices(:, 1), voxel_indices(:, 2), voxel_indices(:, 3));
test = zeros(D1, D2, D3);
test(index) = 100;

showVolume(test,sprintf('feature(%d, %d)', vol_itensity, vol_gradient));

% export_fig(gcf, sprintf('C:/Users/XiaoBo/Desktop/test_image/feature(%d, %d)', vol_itensity, vol_gradient),'-png');



function [hd_mean_table, hd_max_table, ism_table] = init_kmeans( handles )
%initializes kmeans params

global DATA_NAME;
global LUT_TITLE;
global LUT;
global MIN_ISO;
global MAX_ISO;
global isoMinThres;
global isoMaxThres;
global octree_table;

clc;
set(handles.text_isos, 'String', '');
set(handles.lut_axis, 'Visible', 'on');
set(handles.text_status, 'String', '...');


[hd_mean_table, hd_max_table] = load_mi_files_no_area_thresh( DATA_NAME );

ism_table = [];
% normalize the mean_table
LUT = hd_mean_table;
octree_level = 1;

if (strcmp(LUT_TITLE, 'mean Hausdorff distance') )
    LUT = hd_mean_table;
end
if (strcmp(LUT_TITLE, 'max Hausdorff distance') )
    LUT = hd_max_table;
end
if (strcmp(LUT_TITLE, 'inverted isosurface similarity') )
    ism_table = load_ism_table_no_area_thresh( DATA_NAME );
    LUT = ism_table;
end

% Cube overlapping based new similarity metric
if (strcmp(LUT_TITLE, 'proposed') )
    octree_table = load_octree_table( sprintf('%s_approx_iso_all.mat', DATA_NAME) );
    [LUT, octree_level] = linearAggregation(octree_table);
    
    
end

if (strcmp(LUT_TITLE, 'jaccard') )
    octree_table = load_octree_table( sprintf('%s_jaccard_all.mat', DATA_NAME) );
    [LUT, octree_level] = linearAggregation(octree_table);
    
end

if (strcmp(LUT_TITLE, 'voxel approximation') )
    LUT = load_voxel_approx( DATA_NAME );
end

set(handles.LevelSelection, 'Max', octree_level);
set(handles.LevelSelection, 'Min', 1);
if octree_level ~= 1
    set(handles.LevelSelection, 'SliderStep', [1/(octree_level - 1), 1]);
end
set(handles.LevelSelection, 'Value', octree_level);
set(handles.octreeLevel, 'String', octree_level);

MAX_ISO = size(LUT, 1);

% plot the similarity map
load cb_YIOrBr2.mat 
hi = imshow(LUT,[], 'Parent', handles.lut_axis); colormap( cb_YIOrBr2); 
impixelinfo;
hcb = colorbar();
set(get(hcb,'ylabel'),'String', LUT_TITLE, 'fontsize', 20); 
set( hi, 'ButtonDownFcn',@split_cluster_menu );

% set the default thresh to the whole range of data
%set(handles.IsothreshMin, 'String', sprintf('%d', MIN_ISO));
%set(handles.IsothresMax, 'String', sprintf('%d', MAX_ISO));
isoMinThres = MIN_ISO;
isoMaxThres = MAX_ISO;

% screenshot: similarity map
%screenshot_path = sprintf('C:\Users\XiaoBo\Desktop\test_image');
% export_fig(handles.lut_axis, sprintf('C:/Users/XiaoBo/Desktop/test_image/%s_%s', DATA_NAME, LUT_TITLE),'-png');

function split_cluster_menu( objectHandle , eventData  )
%test

klick_type = get( ancestor(objectHandle,'figure'), 'SelectionType' );

if (strcmp(klick_type, 'alt'))
    ha  = get(objectHandle,'Parent');
    coordinates = get(ha,'CurrentPoint');
%    coordinates = coordinates(1,1:2);
%    message     = sprintf('x: %.1f , y: %.1f',coordinates (1) ,coordinates (2));
%    helpdlg(message);
    x = floor(coordinates(1,1));
    
%    msg = sprintf('helpdlg(''centroid: %i'')', xx);
    msg = sprintf('split_ri(%i, %i)', x, ha);
    hcmenu = uicontextmenu;
    % Define callbacks for context menu
    hcb1 = [msg]; %['set(gco,''LineStyle'',''--'')'];
    % Define the context menu items and install their callbacks
    item1 = uimenu(hcmenu,'Label','split','Callback',hcb1);
    % Locate line objects
    hlines = findall(ha,'Type','line');
    % Attach the context menu to each line
    for line = 1:length(hlines)
        set(hlines(line),'uicontextmenu',hcmenu)
    end
end


function display_isovalues( handle, isos )
%displays resulting representative isovalues

n_isos = max(size(isos,1),size(isos,2));
iso_labels = '';
for isov = 1:n_isos;
    x = isos(isov);
    iso_labels = sprintf('%s%i', iso_labels, x);
    if (isov < n_isos)
        iso_labels = sprintf('%s, ', iso_labels);
    end
end

set(handle, 'String', iso_labels);


function display_isovalue_gradient( handle, isos, gradients )
%displays resulting representative isovalues

n_isos = max(size(isos,1),size(isos,2));
iso_labels = '';
for isov = 1:n_isos;
    x = isos(isov);
    y = gradients(isov);
    iso_labels = sprintf('%s(%i, %i)', iso_labels, x, y);
    if (isov < n_isos)
        iso_labels = sprintf('%s, ', iso_labels);
    end
end

set(handle, 'String', iso_labels);

function create_global_clusters( cluster_table, isos )
%creates global cluster table
global MIN_ISO;
global CL_MEMBERS;
CL_MEMBERS = [];

n_clusters = size(isos,1);
for c=1:n_clusters
    I = find(cluster_table==c);
    isosc = I+MIN_ISO-1;
    s2 = size(isosc,1);
    CL_MEMBERS(c, 1:s2) = isosc';
end


function init_datasets()
%initializes datasets

global DO_MANIX;
global DO_MANIX64;
global DO_NEGHIP;
global DO_HNUT128;
global DO_ENGINE;
global DO_CARP;
global DO_GMM1;
global DO_GMM2;
global DO_GMM3;
global DO_HYDROGEN;
global DO_FS;
global DO_FUEL;
global DO_SUPERNOVA;
global DO_COMBUSTION;
global DO_BONSAI;
global DO_TOOTH;
global DO_SUPERNOVA_ENTROPY;
global DO_FEET;

global MIN_GRADIENT;
global NUM_GRADIENT;
global BASE_DIR;
global NUM_ISOVALUES;
global VOLUME;
global VOLUME_GRADIENT;
global D1;
global D2;
global D3;
global VOL_DOWNSAMPLE;


global DATA_NAME;

if (strcmp(DATA_NAME, 'manix128') )
    DO_MANIX = true;
    D1 = 128;
    D2 = 128;
    D3 = 115;
    
    % Hard Code used for index mapping (!only works for integer sampling)
    MIN_GRADIENT = 1;
    NUM_GRADIENT = 100;    % 101
    NUM_ISOVALUES = 149;   % 150
else
    DO_MANIX = false;
end
if (strcmp(DATA_NAME, 'manix64') )
    DO_MANIX64 = true;
    DATA_NAME = 'manix';
else
    DO_MANIX64 = false;
end
if (strcmp(DATA_NAME, 'hnut128') )
    DO_HNUT128 = true;
else
    DO_HNUT128= false;
end
if (strcmp(DATA_NAME, 'neghip') )
    DO_NEGHIP = true;
else
    DO_NEGHIP = false;
end
if (strcmp(DATA_NAME, 'gmm1') )
     DO_GMM1 = true;
else
     DO_GMM1 = false;
end
if (strcmp(DATA_NAME, 'gmm2') )
    DO_GMM2 = true;
else
    DO_GMM2  = false;
end
if (strcmp(DATA_NAME, 'gmm3') )
    DO_GMM3  = true;
else
    DO_GMM3  = false;
end
if (strcmp(DATA_NAME, 'hydrogen') )
    DO_HYDROGEN = true;
    
    D1 = 128;
    D2 = 128;
    D3 = 128;
   
else
    DO_HYDROGEN = false;
end
if (strcmp(DATA_NAME, 'engine') )
    DO_ENGINE = true;
    
    D1 = 128;
    D2 = 128;
    D3 = 64;
    
    % Hard Code used for index mapping (!only works for integer sampling)
    MIN_GRADIENT = 1;
    NUM_GRADIENT = 153;
    NUM_ISOVALUES =  254;
    
else
    DO_ENGINE = false;
end
if (strcmp(DATA_NAME, 'carp1') )
    DO_CARP  = true;
    D1 = 128;
    D2 = 128;
    D3 = 128;
    
    % Hard Code used for index mapping (!only works for integer sampling)
    MIN_GRADIENT = 1;
    NUM_GRADIENT = 80;
    NUM_ISOVALUES =  130;
    
else
    DO_CARP = false;
end
if (strcmp(DATA_NAME, 'fluid simulation') )
    DO_FS  = true;
    DATA_NAME = 'lambda3D';
else
    DO_FS  = false;
end
if (strcmp(DATA_NAME, 'fuel') )
    DO_FUEL  = true;
    DATA_NAME = 'fuel';
    
    D1 = 64;
    D2 = 64;
    D3 = 64;
    
else
    DO_FUEL  = false;
end
if (strcmp(DATA_NAME, 'supernova128') )
    DO_SUPERNOVA  = true;
    DATA_NAME = 'supernova128';
    
    D1 = 128;
    D2 = 128;
    D3 = 128;
    
    % Hard Code used for index mapping (!only works for integer sampling)
    MIN_GRADIENT = 1;
    NUM_GRADIENT = 130;
    NUM_ISOVALUES = 200;
else
    DO_SUPERNOVA  = false;
end
if (strcmp(DATA_NAME, 'TurbulentCombustion') )
    DO_COMBUSTION  = true;
    DATA_NAME = 'TurbulentCombustion';
    
    D1 = 128;
    D2 = 256;
    D3 = 32;
else
    DO_COMBUSTION  = false;
end

if (strcmp(DATA_NAME, 'bonsai') )
    DO_BONSAI  = true;
    DATA_NAME = 'bonsai';
    
    D1 = 256;
    D2 = 256;
    D3 = 256;
    
    % Hard Code used for index mapping (!only works for integer sampling)
    % Old: cut iso-gradient values
    MIN_GRADIENT = 1;
    NUM_GRADIENT = 100;
    NUM_ISOVALUES = 229;
%     MIN_GRADIENT = 1;
%     NUM_GRADIENT = 139;
%     NUM_ISOVALUES = 254;
    
else
    DO_BONSAI  = false;
end

if (strcmp(DATA_NAME, 'tooth') )
    DO_TOOTH  = true;
    DATA_NAME = 'tooth';
    
    D1 = 256;
    D2 = 256;
    D3 = 161;
    
    % Hard Code used for index mapping (!only works for integer sampling)
    MIN_GRADIENT = 1;
    NUM_GRADIENT = 71;
    NUM_ISOVALUES = 254;
else
    DO_TOOTH  = false;
end

if (strcmp(DATA_NAME, 'supernova_entropy') )
    DO_SUPERNOVA_ENTROPY  = true;
    DATA_NAME = 'supernova_entropy';
    
    D1 = 320;
    D2 = 320;
    D3 = 320;
    
else
    DO_BONSAI  = false;
end

if (strcmp(DATA_NAME, 'feet') )
    DO_FEET  = true;
    DATA_NAME = 'feet';
    
    D1 = 256;
    D2 = 256;
    D3 = 256;
    
      % Hard Code used for index mapping (!only works for integer sampling)
    MIN_GRADIENT = 1;
    NUM_GRADIENT = 70;
    NUM_ISOVALUES = 253;
else
    DO_FEET  = false;
end

% load the volume and calculate statistics
raw_file_name = sprintf('%s/%s/%s.raw', BASE_DIR, DATA_NAME, DATA_NAME );
% read raw VOLUME
precision = 'uint8';
fid = fopen(raw_file_name);
tmp = fread( fid, [D1*D2 D3], precision );
VOLUME = reshape( tmp, [D1 D2 D3]);
fclose(fid);

% downsample the VOLUME for testing purpose
if VOL_DOWNSAMPLE
    T1 = 16;
    T2 = 16;
    T3 = 16;
    VOLUME = imresize3d(VOLUME, [], [T1, T2, T3], 'cubic', 'replicate');
else
    T1 = D1;
    T2 = D2;
    T3 = D3;
end
% calculate gradient
[fx, fy, fz] = gradient(VOLUME);
VOLUME_GRADIENT = (fx.^2 + fy.^2 + fz.^2).^(1/2);


% % Used for index mapping (!only works for integer sampling)
% MIN_GRADIENT = min(VOLUME_GRADIENT(:))+1;
% NUM_GRADIENT = ceil(max(VOLUME_GRADIENT(:))-1);
% NUM_ISOVALUES = max(VOLUME(:))- min(VOLUME(:))-1;
    
    
% --- Executes on button press in button_close_figures.
function button_close_figures_Callback(hObject, eventdata, handles)
% hObject    handle to button_close_figures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h1 = gcf;
set(h1, 'HandleVisibility', 'off');
close all;
set(h1, 'HandleVisibility', 'on');


% --- Executes on button press in display_ris_button.
function display_ris_button_Callback(hObject, eventdata, handles)
% hObject    handle to display_ris_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ISOS;
global DATA_NAME;

n_isos = max(size(ISOS,1),size(ISOS,2));

if (n_isos < 1 )
    errordlg('no representatives set: run clustering first');
else
    display_isosurfaces2(DATA_NAME, ISOS, 'representative isosurfaces');
end

% --- Executes on button press in display_members_button.
function display_members_button_Callback(hObject, eventdata, handles)
% hObject    handle to display_members_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ISOS;
global DATA_NAME;
global CL_MEMBERS;

n_clusters = max(size(ISOS,1),size(ISOS,2));

if (n_clusters < 1 )
    errordlg('no representatives set: run clustering first');
else
    
    for c=1:n_clusters
        isosc = CL_MEMBERS(c, :); 
        isosc = isosc(abs(isosc) > 0);
        display_isosurfaces2(DATA_NAME, isosc', sprintf('cluster: %i - %i', min(isosc), max(isosc)));
    end
end

function display_dist(handles)
%displays dist of selected lut
global I1;
global I2;
global LUT;
global MIN_ISO;
global MAX_ISO;
global LUT_TITLE;
global I_THRESH;

if (I1 <= MAX_ISO && I2 <= MAX_ISO && I1 > MIN_ISO && I2 > MIN_ISO)
    
    idx1 = find(I_THRESH == I1);
    idx2 = find(I_THRESH == I2);
    
    dist  = LUT(idx1, idx2);
    if (strcmp( LUT_TITLE, 'inverted isosurface similarity map'))
        dist = 1-dist;
    end
    set(handles.text_dist_i1_i2, 'String', sprintf('%.04f', dist));
    
else
    set(handles.text_dist_i1_i2, 'String', '');
end

function edit_split_cluster_Callback(hObject, eventdata, handles)
% hObject    handle to edit_split_cluster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_split_cluster as text
%        str2double(get(hObject,'String')) returns contents of edit_split_cluster as a double

x = str2double(get(hObject,'String'));
child_isos = split_ri( x, handles.lut_axis);


% --- Executes during object creation, after setting all properties.
function edit_split_cluster_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_split_cluster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_disp_ris_bm10.
function button_disp_ris_bm10_Callback(hObject, eventdata, handles)
% hObject    handle to button_disp_ris_bm10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BM10_ISOS;
global DATA_NAME;

n_isos = max(size(BM10_ISOS,1),size(BM10_ISOS,2));

if (n_isos < 1 )
    errordlg('no representatives set: run BM:10 clustering first');
else
    display_isosurfaces2(DATA_NAME, BM10_ISOS, 'BM:10 representative isosurfaces');
end




% --- Executes on selection change in menu_clustering_type.
function menu_clustering_type_Callback(hObject, eventdata, handles)
% hObject    handle to menu_clustering_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_clustering_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_clustering_type

global CLUSTERING_TYPE;

contents = cellstr(get(hObject,'String'));
type = contents{get(hObject,'Value')};

if ( strcmp( type, 'K-means'))
    CLUSTERING_TYPE = 1;
    switch_type_visibility( handles, 'on', 'off' );    
%    init_kmeans(handles);
end

%helper
function switch_type_visibility( handles, val_type1, val_type2 )

global KMEANS_DO_MERGING;

set(handles.do_merging, 'Visible', val_type1 );
set(handles.text_seed_num, 'Visible',  val_type1);
set(handles.num_k_init_value, 'Visible', val_type1 );
set(handles.batch_seed_inits, 'Visible', val_type1 );

if (KMEANS_DO_MERGING)
    switch_merging_visibility( handles, 'on');
else
    switch_merging_visibility( handles, 'off');
end


set(handles.text_min_thresh, 'Visible', val_type2 );
set(handles.min_area_value, 'Visible', val_type2 );
set(handles.button_comp_lambda, 'Visible', val_type2 );
set(handles.button_init_lambda, 'Visible', val_type2 );
set(handles.text_lambda, 'Visible', val_type2 );
set(handles.text_area_perc, 'Visible', val_type2 );
set(handles.lambda_value, 'Visible', val_type2 );
set(handles.percentage_area_value, 'Visible', val_type2 );
set(handles.num_clusters_value, 'Visible', val_type2 );
set(handles.text_num_clusters, 'Visible', val_type2 );

%helper
function switch_merging_visibility( handles, val_type )

set(handles.text_min_dist, 'Visible', val_type );
set(handles.min_dist_value, 'Visible', val_type );

    
% --- Executes during object creation, after setting all properties.
function menu_clustering_type_CreateFcn(hObject, ~, handles)
% hObject    handle to menu_clustering_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function num_k_init_value_Callback(hObject, eventdata, handles)
% hObject    handle to num_k_init_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_k_init_value as text
%        str2double(get(hObject,'String')) returns contents of num_k_init_value as a double
global NUM_K_INIT;
 
NUM_K_INIT = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function num_k_init_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_k_init_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in do_clustering_button.
function do_clustering_button_Callback(hObject, eventdata, handles)
% hObject    handle to do_clustering_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global CLUSTERING_TYPE;
global BATCH_SEEDS;

switch CLUSTERING_TYPE
    case 1
        
        %init_kmeans(handles);
        if (BATCH_SEEDS)
            
            kmeans_button_batch_Callback(hObject, eventdata, handles);

        else
            
            kmeans_button_Callback(hObject, eventdata, handles);
            
        end
        
    otherwise
        
       % init_dpmeans(handles);
        dpmeans_button_Callback(hObject, eventdata, handles);
        
end


% --- Executes on button press in batch_seed_inits.
function batch_seed_inits_Callback(hObject, eventdata, ~)
% hObject    handle to batch_seed_inits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of batch_seed_inits

global BATCH_SEEDS;

BATCH_SEEDS = get(hObject,'Value');   


% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7
global TwoD_TF;
global BASE_DIR;
global MESH_DATA_DIR;
if get(hObject,'Value') ~= 0
    TwoD_TF = true;
    MESH_DATA_DIR =  sprintf('%s/metrics/2D', BASE_DIR);
else
    TwoD_TF = false;
    MESH_DATA_DIR =  sprintf('%s/metrics', BASE_DIR);
end


% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
global VOL_DOWNSAMPLE;
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox8
if get(hObject,'Value')== 0
    VOL_DOWNSAMPLE = false;
else
    VOL_DOWNSAMPLE = true;
end



function IsothreshMin_Callback(hObject, eventdata, handles)
% hObject    handle to IsothreshMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of IsothreshMin as text
%        str2double(get(hObject,'String')) returns contents of IsothreshMin as a double
global isoMinThres;
global isoMaxThres;
global LUT;
init_kmeans(handles);
isoMinThres = str2double(get(hObject,'String'));
isoMaxThres = str2double(get(handles.IsothresMax,'String'));
LUT = LUT(isoMinThres:isoMaxThres,isoMinThres:isoMaxThres);

% --- Executes during object creation, after setting all properties.
function IsothreshMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IsothreshMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function IsothresMax_Callback(hObject, eventdata, handles)
% hObject    handle to IsothresMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of IsothresMax as text
%        str2double(get(hObject,'String')) returns contents of IsothresMax as a double
global isoMaxThres;
global isoMinThres;
global LUT;
init_kmeans(handles);
isoMaxThres = str2double(get(hObject,'String'));
isoMinThres = str2double(get(handles.IsothreshMin,'String'));
%cut the similarity table
LUT = LUT(isoMinThres:isoMaxThres, isoMinThres:isoMaxThres);

% --- Executes during object creation, after setting all properties.
function IsothresMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IsothresMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global isoMinThres;
global isoMaxThres;
init_kmeans(handles);
set(handles.IsothreshMin, 'String', sprintf('%d', isoMinThres));
set(handles.IsothresMax, 'String', sprintf('%d', isoMaxThres));


% --- Executes during object creation, after setting all properties.
function lut_axis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lut_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate lut_axis


% --- Executes on mouse press over axes background.
function lut_axis_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to lut_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function do_clustering_button_CreateFcn(hObject, eventdata, handles)
% hObject    handle to do_clustering_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on key press with focus on do_clustering_button and none of its controls.
function do_clustering_button_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to do_clustering_button (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in WeighintSchema.
function WeighintSchema_Callback(hObject, eventdata, handles)
% hObject    handle to WeighintSchema (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DATA_NAME;
global LUT_TITLE;
global LUT;
global MIN_ISO;
global MAX_ISO;
global isoMinThres;
global isoMaxThres;
global octree_table;

if (strcmp(LUT_TITLE, 'mean Hausdorff distance') )
    LUT = hd_mean_table;
    return;
end
if (strcmp(LUT_TITLE, 'max Hausdorff distance') )
    LUT = hd_max_table;
    return;
end
if (strcmp(LUT_TITLE, 'inverted isosurface similarity') )
    ism_table = load_ism_table_no_area_thresh( DATA_NAME );
    LUT = ism_table;
    return;
end

%% Weightings
contents = cellstr(get(hObject,'String'));
weighting = contents{get(hObject,'Value')};

if (strcmp(weighting, 'LinearAggregation') )
    [LUT, octree_level] = linearAggregation(octree_table);
    plotMap(handles);
    export_fig(handles.lut_axis, sprintf('C:/Users/XiaoBo/Desktop/test_image/%s_%s_%s', DATA_NAME, LUT_TITLE, weighting),'-png');
end

if (strcmp(weighting, 'ExponentAggregation') )
    [LUT, octree_level] = ExponentAggregation(octree_table);
    plotMap(handles);
    export_fig(handles.lut_axis, sprintf('C:/Users/XiaoBo/Desktop/test_image/%s_%s_%s', DATA_NAME, LUT_TITLE, weighting),'-png');
end

if (strcmp(weighting, 'LogAggregation') )
    [LUT, octree_level] = LogAggregation(octree_table);
    plotMap(handles);
    export_fig(handles.lut_axis, sprintf('C:/Users/XiaoBo/Desktop/test_image/%s_%s_%s', DATA_NAME, LUT_TITLE, weighting),'-png');
end

if (strcmp(weighting, 'PowerAggregation') )
    [LUT, octree_level] = PowerAggregation(octree_table);
    plotMap(handles);
    export_fig(handles.lut_axis, sprintf('C:/Users/XiaoBo/Desktop/test_image/%s_%s_%s', DATA_NAME, LUT_TITLE, weighting),'-png');
end

if (strcmp(weighting, 'Level') )
    cur_lvl = str2double(get(handles.octreeLevel,'String'));
    
    LUT = octree_table{cur_lvl};
    plotMap(handles);
end


function plotMap(handles)
global DATA_NAME;
global LUT_TITLE;
global LUT;
global MIN_ISO;
global MAX_ISO;
global isoMinThres;
global isoMaxThres;
global octree_table;
MAX_ISO = size(LUT, 1);

% plot the similarity map
load cb_YIOrBr2.mat 
hi = imshow(LUT,[], 'Parent', handles.lut_axis); 
colormap( cb_YIOrBr2); 
% colormap(gray)

% set(gca,'XTickLabel',{'5000','10000','15000', '20000', '25000'})
% set(gca,'YTickLabel',{'5000','10000','15000', '20000', '25000'})

impixelinfo;
hcb = colorbar();
set(get(hcb,'ylabel'),'String', LUT_TITLE, 'fontsize', 20); 
set( hi, 'ButtonDownFcn',@split_cluster_menu );

% set the default thresh to the whole range of data
%set(handles.IsothreshMin, 'String', sprintf('%d', MIN_ISO));
%set(handles.IsothresMax, 'String', sprintf('%d', MAX_ISO));
isoMinThres = MIN_ISO;
isoMaxThres = MAX_ISO;


% --- Executes during object creation, after setting all properties.
function WeighintSchema_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WeighintSchema (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function LevelSelection_Callback(hObject, eventdata, handles)
% hObject    handle to LevelSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global DATA_NAME;
global LUT_TITLE;
global LUT;
global MIN_ISO;
global MAX_ISO;
global isoMinThres;
global isoMaxThres;
global octree_table;

lvl = get(hObject,'Value');

set(handles.octreeLevel, 'String', num2str(lvl));

LUT = octree_table{lvl, 1};

plotMap(handles);

% contents = cellstr(get(handles.WeighintSchema,'String'));
% weighting = contents{get(handles.WeighintSchema,'Value')};

export_fig(handles.lut_axis, sprintf('C:/Users/XiaoBo/Desktop/test_image/%s_%s_%d', DATA_NAME, LUT_TITLE, lvl),'-png');

% --- Executes during object creation, after setting all properties.
function LevelSelection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LevelSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function octreeLevel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to octreeLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
