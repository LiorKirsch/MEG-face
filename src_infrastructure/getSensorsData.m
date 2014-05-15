function [sensor_location, is_magnetometer, is_gradiometer_x, is_gradiometer_y] = getSensorsData()

[sensor_index, sensor_x, sensor_y]  = textread('Vectorview-all.lout', '%f %f %f %*f %*f %*s', 'headerlines',1,'whitespace','\t');

sensor_location = [sensor_x, sensor_y];

sensor_type = mod(sensor_index,10);

is_magnetometer = sensor_type ==1;
is_gradiometer_x = sensor_type ==2;
is_gradiometer_y = sensor_type ==3;

% numberOfClusters = 10;
% clusters = kmeans(sensor_location,numberOfClusters);

% % ===== displays the sensors location and type =====
hold on;
gscatter(sensor_x, sensor_y, sensor_type);
% text( sensor_x ,sensor_y , cellstr(int2str((1:length(sensor_index) ).')), 'horizontal','left', 'vertical','bottom','fontsize',10);

hold off;
legend('magnetometer','gradiometer x','gradiometer y');
end