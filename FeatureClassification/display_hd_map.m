function display_hd_map(a, stats_a, stats_b, title, frame_id, data_name, centroid_labels_in )
%displays hd map

%close all;

global BASE_DIR;
global NUM_ISOS;
global CSVOBJ;

fsize = 20;

%% load colormaps
load cm_YIGnBuY.mat
load cb_BrBG.mat
load cb_GOr.mat
load cb_PiYG.mat
load cb_RdYIBu.mat
load cb_PuOr.mat
load cb_BrPu.mat
load cm_BBr.mat

%% display figure
iptsetpref('ImshowAxesVisible', 'on');
iptsetpref('ImtoolInitialMagnification', 'fit');
iptsetpref('ImshowInitialMagnification', 'fit');

figure; 
set(gcf, 'Position', [10, 10, 768, 768]);
set(gcf, 'Color', 'white'); % white bckgr
imshow(a,[]), colormap( cb_PuOr ); hold on;
%impixelinfo;
hcb = colorbar();
set(get(hcb,'ylabel'),'String', title, 'fontsize',fsize); %'maximum Hausdorff distance'
%set(hcb,'ytick',[0 1 2 3 4 5 10 15 20 25 30 35 40 ]);

ha = gca;
set(ha,'xtick',[1  50  100  150  200  250],...
    'ytick',[1  50  100  150  200 250],...
    'DataAspectRatio',[1 1 1],'xMinorTick', 'on', 'YMinorTick', 'on', 'XAxisLocation', 'top');

set(get(ha,'xLabel'),'String', 'isovalues','fontsize',fsize );
set(get(ha,'yLabel'),'String', 'isovalues', 'fontsize',fsize);


nclusters = size(stats_a, 1);
for isov = 1:nclusters
    x = stats_a(isov,1);
    weight = stats_a(isov,2);
    if (weight > 0)
        plot(x,x,'k+', 'MarkerSize',weight,'LineWidth',1);
    end
    
%     mean_dist = stats_a(isov,3);
%     if (mean_dist == 0)
%         plot(x,x,'k.', 'MarkerSize',2,'LineWidth',1);
%     else
%         plot(x,x,'ko', 'MarkerSize',mean_dist,'LineWidth',1);
%     end

    mean_hd_dist = stats_a(isov,6); %energy of current cluster
    if (mean_hd_dist <= 0 || isnan(mean_hd_dist))
        plot(x,x,'k.', 'MarkerSize',2,'LineWidth',1);
    else
        plot(x,x,'ko', 'MarkerSize',mean_hd_dist,'LineWidth',1);
    end
%     min_member = stats_a(isov,4);
%     max_member = stats_a(isov,5);
%     
%     plot(min_member,min_member,'bx', 'MarkerSize',4,'LineWidth',1);
%     plot(max_member,max_member,'bx', 'MarkerSize',4,'LineWidth',1);

end

if (size(stats_a,1) > 0)
    sorted_isos = sort(centroid_labels_in(:,1));
    centroid_labels = sprintf('%i', sorted_isos(1,1));
    tmp = sorted_isos(1,1);
    for isov = 2:nclusters
        x = sorted_isos(isov,1);
        centroid_labels = sprintf('%s, %i', centroid_labels, x);
        tmp = [tmp, x];
    end
%     if(size(tmp, 2) < size(CSVOBJ, 2))
%         for i = 1:size(CSVOBJ, 2) - size(tmp,2)
%             tmp = [tmp, 0];
%         end
%     end
%    CSVOBJ(frame_id, :) = tmp; %FIXME: what is wrong here?
    text(1, NUM_ISOS+5 ,sprintf('centroids=(%s)', centroid_labels));
end

nisov = size(stats_b, 1);
for isov = 1:nisov
    x = stats_b(isov,1);
    plot(x,x,'k+', 'MarkerSize',8,'LineWidth',1);
end

base_dir = sprintf('%s/%s/', BASE_DIR, data_name);
frames_dir = strcat( base_dir, '/clustering/');

fig_path = sprintf('%s/frame%03d.jpg', frames_dir, frame_id );

saveas(gcf, fig_path);

% export_fig( gcf, ...      % figure handle
%     fig_path,... % name of output file without extension
%     '-nocrop',...
%     '-jpg', ...           % file format
%     '-r180' );

hold off;






%backup for later
% cb_BrBG = get(gcf, 'Colormap');
% save('cm_BrBG','cb_BrBG')
% load cm_BrBG
% set(gcf, 'Colormap', cm_BrBG);


	

%% display images as labels
% @Itmar Katz gives a solution very close to what I want to do, which I've marked as 'accepted'. In the meantime, I made this dirty solution using subplots, which I've given here for completeness. It only works up to a certain size input matrix though, and only displays well when the figure is square.
% 
% 
% conf_mat = randn(5);
% A = imread('peppers.png');
% tick_images = {A, A, A, A, A};
% 
% n = length(conf_mat) + 1;
% 
% % plotting axis labels at left and top
% for i = 1:(n-1)
%     subplot(n, n, i + 1); 
%     imshow(tick_images{i});
%     subplot(n, n, i * n + 1);
%     imshow(tick_images{i});
% end
% 
% % generating logical array for where the confusion matrix should be
% idx = 1:(n*n);
% idx(1:n) = 0;
% idx(mod(idx, n)==1) = 0;
% 
% % plotting the confusion matrix
% subplot(n, n, find(idx~=0));
% imshow(conf_mat);
% axis image
% colormap(gray)

