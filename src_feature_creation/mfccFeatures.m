function mfcc_features = mfccFeatures(dataMatrix, fs)
%  input: 
%       dataMatrix is samples x time
%       fs
%
%  output:
%       mfcc_features  samples x c_coeff x time_frames

    addpath('/home/lab/lior/Projects/MEG-faces/src_feature_creation/mfcc/');

    [num_samples, time] = size(dataMatrix);
   % Define variables
    Tw = 25;                % analysis frame duration (ms)
    Ts = 15;                % analysis frame shift (ms)
    alpha = 0.97;           % preemphasis coefficient
    M = 20;                 % number of filterbank channels 
    C = 12;                 % number of cepstral coefficients
    L = 22;                 % cepstral sine lifter parameter
    LF = 1;               % lower frequency limit (Hz)
    HF = 5000;              % upper frequency limit (Hz)
   
   

    % Feature extraction (feature vectors as columns)
%     [ MFCCs, FBEs, frames ] = mfcc( speech, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
    
    timeFramesLength = calcTimeFramesLength( time ,Tw,Ts, fs);
    num_c_coef = C+1;
    mfcc_features = nan(num_samples, num_c_coef, timeFramesLength , 'single');
%     dataScaled = (dataMatrix - repmat(min(dataMatrix,[],1),size(dataMatrix,1),1))*diag(1./(max(dataMatrix,[],1)-min(dataMatrix,[],1))');
    
    for i = 1: num_samples
        mfcc_features(i,:,:) = mfcc( dataMatrix(i,:) , fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
        printPercentCounter(i, num_samples);
    end
                
end


function M = calcTimeFramesLength( input_vector_length, Tw, Ts, fs)

   L = input_vector_length;
    
    Nw = round( 1E-3*Tw*fs );    % frame duration (samples)
    Ns = round( 1E-3*Ts*fs );    % frame shift (samples)
    M = floor((L-Nw)/Ns+1);             % number of frames 
end