function display_hd_map3(a, parent, child1, child2, parent_var, child1_var, child2_var, start_pos )
%displays hd map

close all;

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
imshow(a,[]), colormap( cm_BBr ); hold on;
%impixelinfo;
hcb = colorbar();
set(get(hcb,'ylabel'),'String', 'mean Hausdorff distance', 'fontsize',fsize); %'maximum Hausdorff distance'
%set(hcb,'ytick',[0 1 2 3 4 5 10 15 20 25 30 35 40 ]);

ha = gca;
siz_a = size(a,1);
step = double(uint16(siz_a/6));
xy_steps = [1 1+step 1+2*step 1+3*step 1+4*step 1+5*step];
xy_pos = [start_pos start_pos+step start_pos+2*step start_pos+3*step start_pos+4*step start_pos+5*step];
xy_str = num2cell(xy_pos);
set(ha, 'XTickLabel',xy_str, 'XTick',xy_steps);
set(ha, 'yTickLabel',xy_str, 'yTick',xy_steps);

set(ha,'DataAspectRatio',[1 1 1],'xMinorTick', 'on', 'YMinorTick', 'on', 'XAxisLocation', 'top');

set(get(ha,'xLabel'),'String', 'isovalues','fontsize',fsize );
set(get(ha,'yLabel'),'String', 'isovalues', 'fontsize',fsize);

plot(parent, parent,'k+', 'MarkerSize',8,'LineWidth',1);
plot(child1, child1,'w+', 'MarkerSize',8,'LineWidth',1);
plot(child2, child2,'w+', 'MarkerSize',8,'LineWidth',1);

plot(parent, parent,'ko', 'MarkerSize',parent_var,'LineWidth',1);
plot(child1, child1,'wo', 'MarkerSize',child1_var,'LineWidth',1);
plot(child2, child2,'wo', 'MarkerSize',child2_var,'LineWidth',1);


hold off;


	