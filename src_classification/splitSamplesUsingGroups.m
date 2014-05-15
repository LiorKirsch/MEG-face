function [sample_in_fold, train_group_division] = splitSamplesUsingGroups(sample_to_group_matrix, number_of_folds)
% sample_in_fold = splitSamplesUsingGroups(sample_group_id, number_of_folds)
% use this function when you want to split your samples into X folds.
% where your constrain is that all elements which belong to the same group
% need to be in the same fold
% sample_in_fold - return a boolean matrix (num_samples,num_folds)
% where in each column you will find the training set to be used in this fold
    
    [num_trails, num_groups] = size(sample_to_group_matrix);
    
    test_group_division = randomDivideToParts(num_groups, number_of_folds);
    train_group_division = ~test_group_division;
    
    sample_in_fold = false(num_trails, number_of_folds);
    for i = 1:number_of_folds
        current_fold_groups = train_group_division(:, i); % logical vector which holds which are the subjects in this fold
        current_fold_train_trails = sample_to_group_matrix(:, current_fold_groups) ; % logical vector which holds which are the trails in this fold
        sample_in_fold(:,i) = any(current_fold_train_trails,2); % if the trail belongs to any of the relevent subjects include it
    end
end