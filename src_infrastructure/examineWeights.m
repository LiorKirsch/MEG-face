function examineWeights(weightsMatrix, sensorIndex, timeIndex)

    [num_sensors, time ] = size(weightsMatrix);
    
    for i =1:num_sensors
       figueString = sprintf('sensor %d weights', sensorIndex(i) );
       figure('name',figueString);  
       plot(timeIndex, weightsMatrix(i,:) ); 
    end

end