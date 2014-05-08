----------------------------------------
Data:


Vectorview-all.lout:
Contains data regarding the sensors (squids): Their (x,y) location and their type (gradiometer x, gradiometer y, magnetometer)


----------------------------------------
Function:


getSensorData - 
reads the Vectorview file and outputs the sensor type and location (x,y)

divideToPreAndPostStimulus - 
 divides the timeseries into pre and post stimulus

dataMatrix = normalizeTrailPriorToStimulus(preStimulsData,postStimulsData) -
 normalize each trail using the prestimulus mean and std (zero mean, unit std)

[sensor_in_pyramid_group, groupedTogether] = createSpatialPyramid(sensor_location, number_of_groups_in_lower_level) - 
 groups together spatially neighboring sensors and repeat this using larger group (until all channels are in one group)

createKCenters -
 generates a bag-of-features representation for the timeseries
