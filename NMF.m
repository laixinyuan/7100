clear
%addpath('NO')

[in, fs] = wavread( 'MAPS_MUS-bach_846_AkPnBcht.wav' );
in = mean(in, 2);

beta            = 0.5;

downsampleRate  = 4;
fftSize         = 2^10;

secondsPerFrame = 0.05;
samplesPerFrame = round (secondsPerFrame * fs / downsampleRate);

hopSizeInSecs   = 0.025;
hopSize         = round (hopSizeInSecs * fs / downsampleRate);

nBlocks         = floor( (length(in)/downsampleRate - samplesPerFrame) / hopSize ) + 1;
hamWin          = hamming(samplesPerFrame);
grain           = zeros(fftSize, 1);
blockRMS        = zeros(1, nBlocks);
rmsThreshold    = 0.1;
activeThreshold = 0.2;

audio           = in(1:downsampleRate:end);
score           = zeros(88, nBlocks);

load('dictionary.mat')

tic

for n = 0:nBlocks-1
    %grain = hamWin .* in( 1+n*hopSize:downsampleRate:n*hopSize+blockSize);
    grain = zeros(fftSize, 1);
    grain(1:samplesPerFrame) = hamWin .* audio(1+n*hopSize : samplesPerFrame+n*hopSize); 
    blockRMS(n+1) = sqrt(mean(grain.^2));
end

maxRMS = max(blockRMS);

for n = 0:nBlocks-1
    if blockRMS(n+1) < rmsThreshold*maxRMS
        score(:,n+1) = zeros(88, 1);
    else
        grain = zeros(fftSize, 1);
        grain(1:samplesPerFrame) = hamWin .* audio(1+n*hopSize : samplesPerFrame+n*hopSize); 
        spectrum = abs(fft(grain));
        score(:,n+1) = factorize(spectrum(1:fftSize/2), W, beta);
    end
end

toc

finalScore = postProcess(score);

save finalScore finalScore

%rmpath('NO')