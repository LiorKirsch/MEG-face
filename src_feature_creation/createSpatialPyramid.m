function [sensor_in_pyramid_group, groupedTogether] = createSpatialPyramid(sensor_location, number_of_groups_in_lower_level)
    s = RandStream('mcg16807','Seed',1);
    RandStream.setGlobalStream(s);

    number_of_sensors = size(sensor_location,1);
    numberOfClusters = number_of_groups_in_lower_level;
    [clusters,centers] = kmeans(sensor_location,numberOfClusters,'replicates',1000);


    scatter(sensor_location(:,1), sensor_location(:,2), 15, clusters);
    linked_centers = linkage(centers,'ward','euclidean');

    pyramid = calc_pyramid_levels(linked_centers, number_of_groups_in_lower_level,number_of_sensors);
    sensor_in_pyramid_group = pyramid(clusters,:);
    groupedTogether = [];
    for i =1: size(pyramid,2)
        figure;
        scatter(sensor_location(:,1), sensor_location(:,2), 15, sensor_in_pyramid_group(:,i) );
        groupedTogether = [groupedTogether, full(sparse(1:number_of_sensors, sensor_in_pyramid_group(:,i),1))];
    end
    groupedTogether = groupedTogether ==1;
end

function pyramid = calc_pyramid_levels(linked_centers, number_of_groups_in_lower_level,number_of_sensors)

    

    % in each pyramid level we have half the elements
    levelsInPyramid = ceil(log2(number_of_groups_in_lower_level)); % not including the base level
    divideByTwo = 2.^(0:levelsInPyramid);
    num_elements_in_level = ceil(number_of_groups_in_lower_level./divideByTwo);

    pyramid = cluster(linked_centers,'maxclust',num_elements_in_level );
    
%     pyramid = nan(number_of_sensors, levelsInPyramid +1);
%     for i =1:(levelsInPyramid +1)
%         pyramid(:,i) = cluster(linked_centers,'maxclust',num_elements_in_level );
%     end
end