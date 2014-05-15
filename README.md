----------------------------------------
#### Data:


Vectorview-all.lout:
Contains data regarding the sensors (squids): Their (x,y) location and their type (gradiometer x, gradiometer y, magnetometer)


----------------------------------------
#### Functions:

###### src_infrastructure:


	getSensorData - 
	         reads the Vectorview file and outputs the sensor type and location (x,y)


	createSubmissionCsv(trail_num, predictions, submission_file_name) - 
	         gets a zero,one predictions vector and outputs writes the submission file


	showChannelsWeights - 
	        gets a vector of weights one for each channel in the MEG and draws a heat map.



###### src_feature_creation:


	[sensor_in_pyramid_group, groupedTogether] = createSpatialPyramid(sensor_location, number_of_groups_in_lower_level) - 
	 groups together spatially neighboring sensors and repeat this using larger group (until all channels are in one group)

	createKCenters -
	          generates a bag-of-features representation for the timeseries



###### src_classification:


	do_online_classification - 
	       uses VW (online classifier) to classify the data. First it scrambels the order then it writes the data in VW format to a temp file and runs VW.

	lib_svm_classification - 
	       uses LIBSVM for classifcation

	toVWformat - 
	       writes the data to a file using the VW format

	splitSamplesUsingGroups -
	       splits the data into X-folds in a way that all samples from the same group should be in the same fold.
	       input:    An identity matrix (num_samples x num_groups)
	                 Number of folds.
	       outputs:  The training set to be used at each fold.
	                 The groups used at each fold.

	minmaxScaleFeatures - 
	       scales each features so that the minimum value should be 0 and that the maximum should be 1.

	zeroMeanUnitVarFeatures - 
	       scales each feature so that its mean (over all samples) is zero and its std is one.

	groupScaling - 
	       for each group it scales all the group samples using only data from the samples of the group


###### Other:

	mainClassification - 
	     Loads the samples and does classifcation using five folds

	mainChannelClassification - 
	     Split the data into the different channels than for each channel it tries to perform classifcation indepentently.

	divideToPreAndPostStimulus - 
	     divides the timeseries into pre and post stimulus

	dataMatrix = normalizeTrailPriorToStimulus(preStimulsData,postStimulsData) -
	     normalize each trail using the prestimulus mean and std (zero mean, unit std)

