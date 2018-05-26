function plot_ris(isos, weights, energies, axis_handle, m_color, m_line_width, marker_symb )
%displays hd map

% %% load colormaps
% load cm_YIGnBuY.mat
% load cb_BrBG.mat
% load cb_GOr.mat
% load cb_PiYG.mat
% load cb_RdYIBu.mat
% load cb_PuOr.mat
% load cb_BrPu.mat
% load cm_BBr.mat

%% display figure

set(gcf, 'currentaxes', axis_handle); 
hold on;

set(axis_handle,'xtick',[1  50  100  150  200  250],...
    'ytick',[1  50  100  150  200 250],...
    'DataAspectRatio',[1 1 1],'xMinorTick', 'on', 'YMinorTick', 'on', 'XAxisLocation', 'top','fontsize',14 );

nclusters = max(size(isos, 1),size(isos,2));
colormap = [178/255, 24/255, 43/255; 244/255, 165/255, 130/255];
for isov = 1:nclusters
    x = isos(isov);
    weight = weights(isov);
        plot(x, x, marker_symb, 'MarkerSize', 8,'LineWidth',m_line_width, 'color', m_color );
%     plot(x, x, marker_symb, 'MarkerSize', 8,'LineWidth',m_line_width, 'color', colormap(isov,:) );
    if (weight > 0)
        plot(x, x, 'o', 'MarkerSize', weight,'LineWidth',m_line_width, 'color', m_color );
% plot(x, x, 'o', 'MarkerSize', weight,'LineWidth',m_line_width, 'color', colormap(isov,:) );
    end
    
%     mean_hd_dist = energies(isov); %energy of current cluster
%     if (mean_hd_dist <= 0 || isnan(mean_hd_dist))
%         plot(x,x,'.', 'MarkerSize',2,'LineWidth',m_line_width, 'color', m_color );
%     else
%         plot(x,x,'o', 'MarkerSize',mean_hd_dist,'LineWidth',m_line_width, 'color', m_color );
%     end

end
%set(get(axis_handle,'xLabel'),'String', 'isovalues','fontsize',20 );
%set(get(axis_handle,'yLabel'),'String', 'isovalues', 'fontsize',20);

hold off;




