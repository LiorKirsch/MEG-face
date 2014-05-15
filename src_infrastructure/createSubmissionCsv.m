function createSubmissionCsv(trail_num, predictions, submission_file_name)

    fid = fopen(submission_file_name,'w');
    num_samples = size(predictions,1);

    fprintf('writing submission file %s\n', submission_file_name);
    fprintf(fid, 'Id,Prediction\n');
    fclose(fid);
    tmpMatrix = [double(trail_num),predictions];
    dlmwrite(submission_file_name, tmpMatrix, '-append');

end


