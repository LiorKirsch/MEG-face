function predictions = do_online_classification(trainData, trainLabels, testData, testLabels)

    vwFolder = 'vwTemp';
    num_samples = size(trainData,1);
    randomPerm = randperm(num_samples);
    permTrainData = trainData(randomPerm,:);
    permTrainLabel = trainLabels(randomPerm);
    
    vwTrainFileName = fullfile(vwFolder,'input','face.train.vw');
    toVWformat(permTrainData, permTrainLabel, vwTrainFileName);    
    
    vwTestFileName = fullfile(vwFolder,'input','face.test.vw');
    toVWformat(testData, testLabels , vwTestFileName);     % ones(size(test.X_concat,1),1)

    ! vw vwTemp/input/face.train.vw -c -k --passes 2 --loss_function hinge --binary -f vwTemp/models/face.model.vw
    ! vw vwTemp/input/face.test.vw -t -i vwTemp/models/face.model.vw -p vwTemp/predictions/face.predictions
    
    % ! vw -d vwTemp/input/face.train.vw -c -k --loss_function hinge --binary   --passes 5 --l1 0.0001 -f vwTemp/models/features.model
    % ! vw -d vwTemp/input/face.train.vw  -c -k --loss_function hinge --binary   --passes 5 -i vwTemp/models/features.model --feature_mask   vwTemp/models/features.model -f vwTemp/models/face.sparse.model.vw
    % ! vw vwTemp/input/face.test.vw -t -i face.sparse.model.vw -p vwTemp/predictions/face.sprase.predictions
    
    predictions = load('vwTemp/predictions/face.predictions');
    %createSubmissionCsv( test.id_concat, predictions, 'submit.csv');
    predictions = (predictions + 1)/2;
end