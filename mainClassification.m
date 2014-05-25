function mainClassification()
    addpath('/home/lab/lior/Projects/general use functions');
    addpath('./src_infrastructure/');
    addpath('./src_classification/');
    number_of_folds = 5;
    s = RandStream('mcg16807','Seed',1);
    RandStream.setGlobalStream(s);
    
    
    
% ============ load train data
    train = load('data/post_stimulus_0.5sec_train.mat');
%     train = load('data/normalized_post_stimulus_0.5sec_train.mat');
%     train = load('train_bag_of_features_1000_5_pyra_16.mat');
%     train = load('train_normalized_bag_of_features_1000_5_pyra_16.mat');
    
%     train = load('features/wavelets_normalized_post_stimulus_0.5sec_train.mat');


% ============ load test data
    test = load('data/post_stimulus_0.5sec_test.mat');
%     test = load('data/normalized_post_stimulus_0.5sec_test.mat');
%     test = load('test_bag_of_features_1000_5_pyra_16.mat');
%     test = load('test_normalized_bag_of_features_1000_5_pyra_16.mat');

%     test = load('features/wavelets_normalized_post_stimulus_0.5sec_test.mat');
    
    
  num_train_subjects = length(unique(train.trail_subject_id));
  num_train_trails = length(train.trail_subject_id); 

  
% ============ split trails to folds --keep all trails from the same subject in the same fold--
    trail_to_subject_matrix = logical(full(sparse(1:num_train_trails, train.trail_subject_id, ones(num_train_trails,1), num_train_trails, num_train_subjects) ));
    [trail_in_fold, group_in_fold] = splitSamplesUsingGroups(trail_to_subject_matrix, number_of_folds);
    

    fprintf('======= joining time features with wavelets features =======\n');
    wavelets_train = load('features/wavelets_normalized_post_stimulus_0.5sec_train.mat','X_concat');
    wavelets_test = load('features/wavelets_normalized_post_stimulus_0.5sec_test.mat','X_concat');
    train.X_concat = cat(3,train.X_concat , wavelets_train.X_concat);
    test.X_concat = cat(3,test.X_concat , wavelets_test.X_concat);

    
    
%     channelWeights = load('channelAcc.mat');
%     [~,sortInd] = sort(mean(channelWeights.foldAcc,2), 'descend');
%     selectedChannels = sortInd(1:40) ;
%     train.X_concat = train.X_concat(:, selectedChannels ,:);
%     test.X_concat = test.X_concat(:, selectedChannels ,:);
    
    fprintf('=== doing per user normalization ===\n');
    train.X_concat = groupScaling(train.X_concat, train.trail_subject_id);
    test.X_concat = groupScaling(test.X_concat, test.trail_subject_id);
    fprintf('=== done normalizating ===\n');
    
    
    foldAcc = nan(5,1);
    predictions = cell(number_of_folds,1);
    for i = 1:number_of_folds
        fprintf('======= fold %d ======\n', i);
        %===============================================
        current_fold_train_trails = trail_in_fold(:,i);
        current_fold_train_trails_data = train.X_concat(current_fold_train_trails,:);
        current_fold_train_trails_label = train.y_concat(current_fold_train_trails);
        current_fold_test_trails_data = train.X_concat(~current_fold_train_trails,:);
        current_fold_test_trails_label = train.y_concat(~current_fold_train_trails);
        %===============================================
        
        
%         predictions = linear_svm_classification(current_fold_train_trails_data, current_fold_train_trails_label, current_fold_test_trails_data, current_fold_test_trails_label);
        predictions{i} = do_online_classification(current_fold_train_trails_data, current_fold_train_trails_label, current_fold_test_trails_data, current_fold_test_trails_label);
%         predictions = lib_svm_classification(current_fold_train_trails_data, current_fold_train_trails_label, current_fold_test_trails_data, current_fold_test_trails_label);
        
        accuracy = sum(predictions{i} == current_fold_test_trails_label) / length(predictions{i});
        foldAcc(i) = accuracy;
    end
    
    resultsSummary(predictions, ~trail_in_fold, train.y_concat,train.trail_subject_id);

%     fprintf('======= test set ======\n');
%     testPredictions = do_online_classification(train.X_concat, train.y_concat, test.X_concat, ones(size(test.X_concat,1),1) );
%     createSubmissionCsv(test.id_concat, testPredictions,'testSubmission.csv');
%     resultsSummary({testPredictions}, true(size(test.X_concat,1),1), ones(size(test.X_concat,1),1) ,test.trail_subject_id );
end