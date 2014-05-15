function toVWformat(sparseData, labels, vwFileName)
    fid = fopen(vwFileName,'w');
    
    labels = labels *2 -1;
    num_samples = size(sparseData,1);
    fprintf('writing vw format to %s\n   ', vwFileName);
    for i =1:num_samples
        fprintf(fid, '%d | ', labels(i));
        
        trailFeatures = sparseData(i,:);
        trailNonZeroIndices = find( trailFeatures);
        trailNonZeroValues = trailFeatures(trailNonZeroIndices);
        tmpArray = [trailNonZeroIndices; trailNonZeroValues];
        tmpString = sprintf('%d:%d ', tmpArray );
        fprintf(fid, '%s\n',tmpString(1:end-1) );
        printPercentCounter(i, num_samples);
    end
    fclose(fid);
end