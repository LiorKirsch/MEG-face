function FFT_samples = fft_Features(dataMatrix, fs)
%  input: 
%       dataMatrix is samples x time
%       fs
%
%  output:
%       mfcc_features  samples x c_coeff x time_frames


[num_samples, time] = size(dataMatrix);
window    = 60;

current_FFT_features = spectrogram( double(dataMatrix(1,:))  ,window,[],[],fs);

features_size = length( current_FFT_features(:) );
FFT_samples = nan(num_samples, features_size,'single');
FFT_samples(1,:) = abs( current_FFT_features(:) ) ;

parfor i = 2:num_samples
    current_sample = double(dataMatrix(i,:));
    current_FFT_features = spectrogram(current_sample,window,[],[],fs);
    FFT_samples(i,:) = abs( current_FFT_features(:) );
    printPercentCounter(i, num_samples);
end

