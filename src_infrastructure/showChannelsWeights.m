function showChannelsWeights(channelWeights)
% display the value of each of the 306 channels


[sensor_location, is_magnetometer, is_gradiometer_x, is_gradiometer_y] = getSensorsData();


figure;
scatter(sensor_location(:,1), sensor_location(:,2), 80,channelWeights,'fill');
colorbar;
end