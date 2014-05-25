  addpath('/home/lab/lior/Projects/general use functions');
    addpath('./src_infrastructure/');
    addpath('./src_feature_creation/');
    
    % ============ load train data
%     train = load('data/post_stimulus_0.5sec_train.mat');
    train = load('data/normalized_post_stimulus_0.5sec_train.mat');
%     train = load('train_bag_of_features_1000_5_pyra_16.mat');
%     train = load('train_normalized_bag_of_features_1000_5_pyra_16.mat');
    
% ============ load test data
%     test = load('data/post_stimulus_0.5sec_test.mat');
    test = load('data/normalized_post_stimulus_0.5sec_test.mat');
%     test = load('test_bag_of_features_1000_5_pyra_16.mat');
%     test = load('test_normalized_bag_of_features_1000_5_pyra_16.mat');

  
  

  [num_trails, num_channels, time] = size(test.X_concat);
  testFeatures = getWaveletsFeatures( reshape(test.X_concat, num_trails*num_channels, time) );
%   testFeatures = fft_Features( reshape(test.X_concat, num_trails*num_channels, time) , test.sfreq);
%   testFeatures = mfccFeatures( reshape(test.X_concat, num_trails*num_channels, time) , test.sfreq);
  testFeatures = reshape(testFeatures, num_trails,num_channels, []);
  


  [num_trails, num_channels, time] = size(train.X_concat);
  trainFeatures = getWaveletsFeatures( reshape(train.X_concat, num_trails*num_channels, time) );
%   trainFeatures = fft_Features(reshape(train.X_concat, num_trails*num_channels, time) , train.sfreq);
%   trainFeatures = mfccFeatures(reshape(train.X_concat, num_trails*num_channels, time) , train.sfreq);
  trainFeatures = reshape(trainFeatures, num_trails,num_channels, []);
  
  train.X_concat = trainFeatures;
  test.X_concat = testFeatures;
  fprintf('================ saving features ================\n');
  save('features/wavelets_normalized_post_stimulus_0.5sec_train.mat','-struct','train','-v7.3');
  save('features/wavelets_normalized_post_stimulus_0.5sec_test.mat','-struct','test','-v7.3');
  
 
  
  

  