function dataMatrix = normalizeTrailPriorToStimulus(preStimulsData,postStimulsData)
% dataMatrix, trial x channel x time

% find the mean and std over time of each (trial,channel) for the idle time
meanStimuls = mean(preStimulsData,3) ;
stdStimuls = std(preStimulsData,0,3) ;

dataMatrix = postStimulsData - repmat(meanStimuls, [1,1,size(postStimulsData,3)]);
dataMatrix = dataMatrix ./ repmat(stdStimuls, [1,1,size(postStimulsData,3)]);

end