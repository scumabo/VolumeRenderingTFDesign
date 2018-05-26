function update_groundtruth( b, s1, s2, s3, s4, s5, e5 )
%bla

close all;

%b = symmetric hausdorff distance table

% s1 = 2;
% s2 = 18;
% s3 = 36;
% s4 = 57;
% s5 = 67;
% 
% e5 = 89;

c1 = b(s1:s2-1, s1:s2-1);
c2 = b(s2:s3-1, s2:s3-1);
c3 = b(s3:s4-1, s3:s4-1);
c4 = b(s4:s5-1, s4:s5-1);
c5 = b(s5:e5, s5:e5);

c1_sum = sum(c1,1);
c2_sum = sum(c2,1);
c3_sum = sum(c3,1);
c4_sum = sum(c4,1);
c5_sum = sum(c5,1);

ri1 = find(c1_sum==min(c1_sum)) + s1 -1;
ri2 = find(c2_sum==min(c2_sum)) + s2 -1;
ri3 = find(c3_sum==min(c3_sum)) + s3 -1;
ri4 = find(c4_sum==min(c4_sum)) + s4 -1;
ri5 = find(c5_sum==min(c5_sum)) + s5 -1;


c1_hd = b(ri1,:);
c2_hd = b(ri2,:);
c3_hd = b(ri3,:);
c4_hd = b(ri4,:);
c5_hd = b(ri5,:);
min_hd = c1_hd(s1:s2-1);
min_hd(s2:s3-1) = c2_hd(s2:s3-1);
min_hd(s3:s4-1) = c3_hd(s3:s4-1);
min_hd(s4:s5-1) = c4_hd(s4:s5-1);
min_hd(s5:e5) = c5_hd(s5:e5);

m_size1 = 1;
m_size2 = 1;
m_size3 = 4;

figure, plot(c1_hd, 'k+', 'MarkerSize', m_size1); hold on;
plot(c2_hd, 'k+', 'MarkerSize', m_size1);
plot(c3_hd, 'k+', 'MarkerSize', m_size1);
plot(c4_hd, 'k+', 'MarkerSize', m_size1);
plot(c5_hd, 'k+', 'MarkerSize', m_size1);

ha = gca;
set(ha,'xtick', 0:5:89, 'xMinorTick', 'on');

[x1, y1] = get_intersection_point(c1_hd, c2_hd);
plot(x1, y1, 'ro', 'LineWidth', m_size2);

[x2, y2] = get_intersection_point(c2_hd, c3_hd);
plot(x2, y2, 'ro', 'LineWidth', m_size2);

[x3, y3] = get_intersection_point(c3_hd, c4_hd);
plot(x3, y3, 'ro', 'LineWidth', m_size2);

[x4, y4] = get_intersection_point(c4_hd, c5_hd);
plot(x4, y4, 'ro', 'LineWidth', m_size2);


% plot(c1_hd(s1:s2-1), 'b+', 'MarkerSize', m_size3);
% plot(c2_hd(s2:s3-1), 'g+', 'MarkerSize', m_size3);
% plot(c3_hd(s3:s4-1), 'k+', 'MarkerSize', m_size3);
% plot(c4_hd(s4:s5-1), 'b+', 'MarkerSize', m_size3);
% plot(c5_hd(s5:e5), 'g+', 'MarkerSize', m_size3);

plot(min_hd, 'b+', 'MarkerSize', m_size3);


hold off;
%close gcf;




