function createKCenters(number_of_clusters)

if ~exist('number_of_clusters','var')
    number_of_clusters = 500;
end

normalizeFeatures = true;
number_of_kmeans_repetitions = 5;


if normalizeFeatures
    normalizeString = 'normalized_';
else
    normalizeString = '';
end

file_name = sprintf('%scodebook_%d_KmeansRep_%d.mat' , normalizeString, number_of_clusters,number_of_kmeans_repetitions);

   run('~/Projects_code/vlfeat-0.9.14/toolbox/vl_setup');
    disp('init vlFeat');
    addpath('~/Projects/general use functions/');

    fprintf('loading data\n');
    train = load('data/alltrain_subject.mat'); 
    test = load('data/alltest_subject.mat');


    fprintf('deviding to pre and post stimuls\n');
    tmin = 0;
    tmax = 0.5;
    [preStimulsDataTrain, postStimulsDataTrain] = devideToPreAndPostStimulus(train.X_concat,tmin, tmax, train.sfreq,train.tmin_original);
    [preStimulsDataTest, postStimulsDataTest] = devideToPreAndPostStimulus(test.X_concat,tmin, tmax, test.sfreq,test.tmin_original);

    if normalizeFeatures
        postStimulsDataTrain = normalizeTrailPriorToStimulus(preStimulsDataTrain, postStimulsDataTrain);
        postStimulsDataTest = normalizeTrailPriorToStimulus(preStimulsDataTest, postStimulsDataTest);
        fprintf('=== features normalized ===\n');
    else
        fprintf('=== features not normalized ===\n');
    end
    
    
if exist(file_name,'file')
    load(file_name,'cluster_centers');
else
    cluster_centers = create_codebook(postStimulsDataTrain, postStimulsDataTest, number_of_clusters, number_of_kmeans_repetitions);
    fprintf('saving codebook\n');
    save(file_name,'cluster_centers');
end


k_nearest_neighbors = 5;
number_of_elm_in_lower_level_pyramid = 16;
bag_of_features_file = sprintf('%sbag_of_features_%d_%d_pyra_%d.mat' , normalizeString, number_of_clusters,k_nearest_neighbors, number_of_elm_in_lower_level_pyramid);

if ~exist(bag_of_features_file,'file')
    fprintf('---train data---\n');
    code_book_feature_train = respresentUsingBagOfWords(cluster_centers, postStimulsDataTrain,k_nearest_neighbors,number_of_elm_in_lower_level_pyramid);
    fprintf('---test data---\n');
    code_book_feature_test = respresentUsingBagOfWords(cluster_centers, postStimulsDataTest,k_nearest_neighbors,number_of_elm_in_lower_level_pyramid);
    train.X_concat = code_book_feature_train;
    test.X_concat = code_book_feature_test;
    save(['train_',bag_of_features_file],'-struct','train');
    save(['test_',bag_of_features_file],'-struct','test');
end

end

function cluster_centers = create_codebook(postStimulsDataTrain, postStimulsDataTest, number_of_clusters, number_of_kmeans_repetitions)
    fprintf('reshaping and transposing\n');
    % create a bag of features using kmeans
    X_train = reshape(postStimulsDataTrain, size(postStimulsDataTrain,1) * size(postStimulsDataTrain,2) ,  size(postStimulsDataTrain,3) );
    X_test = reshape(postStimulsDataTest, size(postStimulsDataTest,1) * size(postStimulsDataTest,2),  size(postStimulsDataTest,3) );

    X_all = [ X_train ; X_test] ;
    clear('X_train','X_test');
    % X2 = nan(size(testData.X_concat,1) , size(testData.X_concat,2) * size(testData.X_concat,3) ) ;
    % for i =1:size(testData.X_concat,1)
    %     temp = squeeze(testData.X_concat(i,:,:));
    %     X2(i,:) = temp(:);
    % end

    fprintf('doing k means with %d centers and %d repetitions\n',number_of_clusters, number_of_kmeans_repetitions);

    %========= use VL_FEAT K Means ==========
    X_all = X_all';
    [cluster_centers, ~] = vl_kmeans(X_all, number_of_clusters,'verbose', 'NumRepetitions', number_of_kmeans_repetitions);
    cluster_centers = cluster_centers';
    
    %========= use Matlab K Means ==========
%     opts = statset('UseParallel',true,'MaxIter',1000,'Display','iter');
% %     [~, cluster_centers] = kmeans(X_all, number_of_clusters,'emptyaction', 'drop', 'replicates', number_of_kmeans_repetitions,'Options',opts);
%     [~, cluster_centers] = kmeans(X_all, number_of_clusters,'emptyaction', 'drop', 'Options',opts);
end

function code_book_representraion = respresentUsingBagOfWords(cluster_centers, all_data, k_nearest_neighbors,number_of_elm_in_lower_level_pyramid)
    fprintf('representing each trail using the codebook and k=%d neighbors using a pyramid with a base of %d elements\n  ',k_nearest_neighbors, number_of_elm_in_lower_level_pyramid);

    number_of_centers = size(cluster_centers,1);
    number_of_trails = size(all_data,1);
    number_of_channels = size(all_data,2);
    [sensor_location, is_magnetometer, is_gradiometer] = getSensorsData();
    [~, groupedTogether] = createSpatialPyramid(sensor_location, number_of_elm_in_lower_level_pyramid);
    num_groups_in_pyramid = size(groupedTogether,2);
    
    all_trail_code_book = zeros(number_of_trails, num_groups_in_pyramid, number_of_centers,'int16');
    for i=1:number_of_trails
        current_trail = squeeze( all_data(i,:,:) );
        current_trail_code_book = zeros(num_groups_in_pyramid, number_of_centers,'int16');
        for j = 1:num_groups_in_pyramid
            current_trail_in_group = current_trail( groupedTogether(:,j) ,:);
            indices_of_selected_centers = knnsearch(cluster_centers,current_trail_in_group,'K',k_nearest_neighbors);
            current_trail_and_group_codebook_counter = histc(indices_of_selected_centers(:), 1:number_of_centers);
            current_trail_code_book(j,:) = current_trail_and_group_codebook_counter;
        end
        all_trail_code_book(i,:,:) = current_trail_code_book;
        printPercentCounter(i, number_of_trails);
    end
    
%     code_book_representraion = histc(trail_code_book, 1:number_of_centers, 3);
    code_book_representraion = reshape(all_trail_code_book, number_of_trails, num_groups_in_pyramid * number_of_centers );
end
