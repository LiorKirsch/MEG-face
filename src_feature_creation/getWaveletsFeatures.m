function wavelets_samples = getWaveletsFeatures(dataMatrix )

%  input: 
%       dataMatrix is samples x time
%
%  output:
%       mfcc_features  samples x c_coeff x time_frames


[num_samples, time] = size(dataMatrix);
spliting_level   = 4;
wavelet_name = 'sym2';

current_sample = double(dataMatrix(1,:));
current_wavelets_features = wavedec( current_sample  , spliting_level , wavelet_name );

features_size = length( current_wavelets_features(:) );
wavelets_samples = nan(num_samples, features_size,'single');
wavelets_samples(1,:) =  current_wavelets_features(:)  ;
% wavelets_samples(1,:) =  abs( current_wavelets_features(:)  );

parfor i = 2:num_samples
    current_sample = double(dataMatrix(i,:));
    current_wavelets_features = wavedec( current_sample  , spliting_level , wavelet_name );
    wavelets_samples(i,:) =  current_wavelets_features(:) ;
%     wavelets_samples(i,:) =  abs( current_wavelets_features(:) );
    printPercentCounter(i, num_samples);
end

