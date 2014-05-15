function data = zeroMeanUnitVarFeatures(data)
% Do min max scaling of the features
    data = (data - repmat(mean(data,1),size(data,1),1))*diag(1./(std(data,1,1)));
end