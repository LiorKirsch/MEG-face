function mainChannelClassification()
    addpath('/home/lab/lior/Projects/general use functions');
    addpath('./src_classification/');
    number_of_folds = 5;
    s = RandStream('mcg16807','Seed',1);
    RandStream.setGlobalStream(s);
    
    
    
% ============ load train data
    train = load('data/post_stimulus_0.5sec_train.mat');
%     train = load('train_bag_of_features_1000_5_pyra_16.mat');
%     train = load('train_normalized_bag_of_features_1000_5_pyra_16.mat');
    
   num_train_subjects = length(unique(train.trail_subject_id));
   num_train_trails = length(train.trail_subject_id); 
 
% ============ split trails to folds --keep all trails from the same subject in the same fold--
    trail_to_subject_matrix = logical(full(sparse(1:num_train_trails, train.trail_subject_id, ones(num_train_trails,1), num_train_trails, num_train_subjects) ));
    [trail_in_fold, group_in_fold] = splitSamplesUsingGroups(trail_to_subject_matrix, number_of_folds);
    
    num_channels = size(train.X_concat,2);

   train.X_concat = groupScaling(train.X_concat, train.trail_subject_id);
  
    all_data = train.X_concat;
    labels = train.y_concat;
    
    foldAcc = nan(num_channels,number_of_folds);

    C = exp(-1:4);
    G = exp(-8:-4);
    [C,G] = meshgrid(C,G);
    C = C(:); G = G(:);
    
    
    
   
    
    for j = 1:num_channels
        data = squeeze(all_data(:,j,:) );
        
        for i = 1:number_of_folds
            %=============== split to folds ================
            current_fold_train_trails = trail_in_fold(:,i);
            current_fold_train_trails_data = data(current_fold_train_trails,:);
            current_fold_train_trails_label = labels(current_fold_train_trails);
            current_fold_test_trails_data = data(~current_fold_train_trails,:);
            current_fold_test_trails_label = labels(~current_fold_train_trails);
            %===============================================
            

%             current_fold_trail_to_subject_matrix = trail_to_subject_matrix(:,group_in_fold(:,i) );
%             trail_in_fold2 = splitSamplesUsingGroups(current_fold_trail_to_subject_matrix, number_of_folds);
%             hyperParamSearch = zeros(length(C),number_of_folds);
%             for m = 1:length(C)
%                 for k=1:number_of_folds
%                     
%                     %=== split to hyper parameter selection folds ==
%                     current_fold2_train_trails = trail_in_fold2(:,i);
%                     current_fold2_train_trails_data = data(current_fold2_train_trails,:);
%                     current_fold2_train_trails_label = labels(current_fold2_train_trails);
%                     current_fold2_test_trails_data = data(~current_fold2_train_trails,:);
%                     current_fold2_test_trails_label = labels(~current_fold2_train_trails);
%                     %===============================================
%                     
%                     fprintf('Channel %d: ',j);
%                     predictions = lib_svm_rbf_classification(current_fold2_train_trails_data, current_fold2_train_trails_label, current_fold2_test_trails_data, current_fold2_test_trails_label,C(m),G(m) );
%                     accuracy = sum(predictions == current_fold2_test_trails_label) / length(predictions);
%                     hyperParamSearch(m,k) = accuracy;
%                 end
%             end
%             [~, maxInd] = max( mean(hyperParamSearch,2) );
%             bestC = C(maxInd);
%             bestG = G(maxInd);
%             
%             fprintf('Channel %d: ',j);
%             predictions = lib_svm_rbf_classification(current_fold_train_trails_data, current_fold_train_trails_label, current_fold_test_trails_data, current_fold_test_trails_label, bestC, bestG);
            predictions = do_online_classification(current_fold_train_trails_data, current_fold_train_trails_label, current_fold_test_trails_data, current_fold_test_trails_label);

            accuracy = sum(predictions == current_fold_test_trails_label) / length(predictions);
            foldAcc(j,i) = accuracy;
        end
%         printPercentCounter(j, num_channels);
    end
    save('channelAcc.mat', 'foldAcc');
end

