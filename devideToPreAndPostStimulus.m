function [preStimulsDataMatrix, postStimulsDataMatrix] = devideToPreAndPostStimulus(dataMatrix,tmin, tmax, sfreq,tmin_original)
% dataMatrix, trial x channel x time
% timeBeforeStimilus


beginningOfStimulus = (tmin - tmin_original) * sfreq+1;
endOfStimulus = (tmax - tmin_original) * sfreq;

preStimulsDataMatrix = dataMatrix(:, :, 1:beginningOfStimulus);
postStimulsDataMatrix = dataMatrix(:, :, beginningOfStimulus:endOfStimulus);


end
