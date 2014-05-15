function test_decision_values = linear_svm_classification(train_data, train_labels, test_data, test_labels)
    
    addpath('/home/lab/lior/Projects/general use functions/liblinear-weights-1.8/matlab/');
    
    
    C = 1;
    
    
    newPenelty = length(train_labels)/sum(train_labels);
   
    %   ==== linear ====
    svmOptions = sprintf('col -c %g',  C); 

    train_data = double(train_data);   
    train_labels = double(train_labels);   
    test_data = double(test_data);   
    test_labels = double(test_labels);   

    weight_vector = ones(size(train_labels));
    model = train(weight_vector, train_labels, train_data, 'liblinear_options', svmOptions);

    [~, ~, train_decision_values] = predict( train_labels , train_data, model ) ;
    [~, ~, test_decision_values] = predict( test_labels, test_data, model ) ;
    
        
end