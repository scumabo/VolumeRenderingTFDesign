function plot_cluster_distance_distributions( b, s1, s2, area )
%bla
global I_THRESH;
global BASE_DIR;
global LUT_TITLE;
global DATA_NAME;
%close all;

%b = symmetric hausdorff distance table

c = b(s1:s2, s1:s2);
m_size1 = 1;

c_sum = sum(c,1);
ri = find(c_sum==min(c_sum));


figure, hold on;
for n = 1:size(c,1)
    
    c_hd = c(n, :);
    plot(I_THRESH(s1):I_THRESH(s2), c_hd, 'k'); 
    
end

title(sprintf('cluster: %i to %i', I_THRESH(s1), I_THRESH(s2)))
xlabel('isovalues')
ylabel('distance')


set(gca, 'xMinorTick', 'on');

c_sum = sum(c,1);
ri = find(c_sum==min(c_sum));
ri = ri(1);
cri_hd = c(ri,:);
plot(I_THRESH(s1):I_THRESH(s2),cri_hd, 'b', 'LineWidth', 3); 
plot(I_THRESH(s1):I_THRESH(s2),cri_hd./area(s1:s2), 'k', 'LineWidth', 3); 

ri = find(c_sum==max(c_sum));
cri_hd = c(ri,:);
plot(I_THRESH(s1):I_THRESH(s2),cri_hd, 'r', 'LineWidth', 3); 

m_hdsum = (c_sum)/(I_THRESH(s2)-I_THRESH(s1)+1);
plot(I_THRESH(s1):I_THRESH(s2),m_hdsum, 'g', 'LineWidth', 3); 

% pic_dir = strcat( BASE_DIR, '/charts/');
% if (strcmp(LUT_TITLE, 'mean Hausdorff distance') )
%     fig_path = sprintf('%s/%s_mean_HDM_iso%02d~%02d', pic_dir,  DATA_NAME, I_THRESH(s1), I_THRESH(s2));
% end
% if (strcmp(LUT_TITLE, 'max Hausdorff distance') )
%     fig_path = sprintf('%s/%s_HDM_iso%02d~%02d', pic_dir,  DATA_NAME, I_THRESH(s1), I_THRESH(s2));
% end
% if (strcmp(LUT_TITLE, 'inverted isosurface similarity map') )
%     fig_path = sprintf('%s/%s_ISM_iso%02d~%02d', pic_dir,  DATA_NAME, I_THRESH(s1), I_THRESH(s2));
% end
% 
% export_fig(gcf,fig_path,'-png')

hold off;
