function data = groupScaling(data, group_id)

    groups = unique(group_id);
    
    for i = 1:length(groups)
       currentGroupSamples = group_id == groups(i);
       data(currentGroupSamples,:) = zeroMeanUnitVarFeatures( data(currentGroupSamples,:) );
%        data(currentGroupSamples,:) = minmaxScaleFeatures( data(currentGroupSamples,:) );
    end
  
end