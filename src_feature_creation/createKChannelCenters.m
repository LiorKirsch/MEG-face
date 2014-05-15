function createKChannelCenters(number_of_clusters)

if ~exist('number_of_clusters','var')
    number_of_clusters = 500;
end

normalizeFeatures = false;
number_of_kmeans_repetitions = 1;

if normalizeFeatures
    normalizeString = 'normalized-';
else
    normalizeString = '';
end

file_name = sprintf('%schannel_center_%d.mat' , normalizeString, number_of_clusters);

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
    end

    % fprintf('reshaping and transposing\n');
    % % create a bag of features using kmeans
    % X_train = reshape(preStimulsDataTrain, size(preStimulsDataTrain,1)*size(preStimulsDataTrain,2) ,  size(preStimulsDataTrain,3) );
    % X_test = reshape(preStimulsDataTest, size(preStimulsDataTest,1)*size(preStimulsDataTest,2) ,  size(preStimulsDataTest,3) );

    X_all = cat(1, postStimulsDataTrain , postStimulsDataTest) ;
    clear('preStimulsDataTrain','preStimulsDataTest','train','test');
    % X2 = nan(size(testData.X_concat,1) , size(testData.X_concat,2) * size(testData.X_concat,3) ) ;
    % for i =1:size(testData.X_concat,1)
    %     temp = squeeze(testData.X_concat(i,:,:));
    %     X2(i,:) = temp(:);
    % end

    fprintf('doing k means with %d centers and %d repetitions\n  ',number_of_clusters, number_of_kmeans_repetitions);

if exist(file_name,'file')
    fprintf('found a file for cluster centers\n');
    load(file_name,'cluster_centers');
else
    featureVectorSize = size(X_all,3);
    number_of_channels = size(X_all,2);
    cluster_centers = nan(number_of_channels, number_of_clusters,featureVectorSize);
    %========= use VL_FEAT K Means ==========
    % X_all = X_all';
    % [cluster_centers, ~] = vl_kmeans(X_all, number_of_clusters, 'NumRepetitions', number_of_kmeans_repetitions);

    %========= use Matlab K Means ==========
    opts = statset('UseParallel',true,'MaxIter',1000);
    for i = 1: number_of_channels
        current_channel_data = squeeze( X_all(:,i,:) );
        [~, cluster_centers(i,:,:)] = kmeans(current_channel_data, number_of_clusters,'emptyaction', 'drop', 'replicates', number_of_kmeans_repetitions,'Options',opts);
        printPercentCounter(i, number_of_channels);
    end


    save(file_name,'cluster_centers');
    
end

% createFeatures(X_all, cluster_centers);

end

function dataFeatures = createFeatures(dataMatrix, cluster_centers, do_sparse)
    featureVectorSize = size(dataMatrix,3);
    number_of_channels = size(dataMatrix,2);
    number_of_samples = size(dataMatrix,1);
    
    if do_sparse
        dataFeatures = sparse(number_of_samples, number_of_channels, number_of_clusters);
    else
        dataFeatures = nan(number_of_samples, number_of_channels, number_of_clusters);
    end
     
    for i = 1: number_of_channels
        current_channel_data = squeeze( dataMatrix(:,i,:) ); % samples X time
        current_channel_cluster_center = squeeze( cluster_centers(i,:,:) ); % centers X time
        distanceToCenters = pdist2(current_channel_data, current_channel_cluster_center); % samples X centers
        dataFeatures(:,i,:) = distanceToCenters;
        printPercentCounter(i, number_of_channels);
    end


end