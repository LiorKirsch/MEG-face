function [classification, test_decision_values] = lib_svm_classification(train_data, train_labels, test_data, test_labels)
    addpath('/home/lab/lior/Projects/general use functions/libsvm-mat-3.0-1');

    C = 1;
    g = 1;
    
    %   ====== RBF ======
%     svmOptions = sprintf('-w1 1 -w0 %g -c %g -g %g', newPenelty, C ,g);
    
    %   ==== linear ====
    svmOptions = sprintf('-c %g -t 0 -q',  C); 

    train_data = double(train_data);   
    train_labels = double(train_labels);   
    test_data = double(test_data);   
    test_labels = double(test_labels);   

    train_data_with_bias = [ones(size(train_data,1),1) , train_data];
    test_data_with_bias = [ones(size(test_data,1),1) , test_data];
    model = svmtrain( train_labels , train_data ,svmOptions);

%     [~, ~, train_decision_values] = svmpredict( train_labels , train_data, model ) ;
    [classification, ~, test_decision_values] = svmpredict( test_labels, test_data, model ) ;
    
        
end