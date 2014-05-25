function resultsSummary(predictions, samples_in_fold, labels,sample_subject_id)

num_folds = length(predictions);
num_samples = size(samples_in_fold);
num_subject = size(sample_subject_id,2);

for i =1:num_folds
   current_samples = samples_in_fold(:,i);
   current_labels = labels(current_samples);
   current_sample_subject_id = sample_subject_id(current_samples);
   
   current_predictions = predictions{i};
   
   accuracy = sum(current_predictions == current_labels) / length(current_predictions);
   p = round(sum(current_predictions == 1) *100 / sum(current_samples) );
   n = round(sum(current_predictions == 0) *100 / sum(current_samples) );
     
   fprintf('====== fold %d   (%g)    +%d%% -%d%% ======\n',i,accuracy, p,n);
   subjects_id = unique(current_sample_subject_id);
   
   for j=1:length(subjects_id)
      subject_samples =   current_sample_subject_id == subjects_id(j) ;
      num_subject_samples = sum(subject_samples);
      tp = sum(current_predictions(subject_samples) == 1 & current_labels(subject_samples) ==1) /num_subject_samples;
      fp = sum(current_predictions(subject_samples) == 1 & current_labels(subject_samples) ==0) /num_subject_samples;
      tn = sum(current_predictions(subject_samples) == 0 & current_labels(subject_samples) ==0) /num_subject_samples;
      fn = sum(current_predictions(subject_samples) == 0 & current_labels(subject_samples) ==1) /num_subject_samples;
      
      p = round(sum(current_predictions(subject_samples) == 1) *100 / num_subject_samples );
      n = round(sum(current_predictions(subject_samples) == 0) *100 / num_subject_samples );
      subject_accuracy = sum(current_predictions(subject_samples) == current_labels(subject_samples)) / length(current_predictions(subject_samples));
      fprintf('subject %d (%g): +%d%% -%d%% (tp %g fp %g tn %g fn %g)\n', subjects_id(j),subject_accuracy, p,n,tp,fp,tn,fn);
   end
   

end

end