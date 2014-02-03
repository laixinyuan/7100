addpath('MUS')

clear

beta            = 0.5;

downsampleRate  = 3;
fftSize         = 2^10;

secondsPerFrame = 0.1;
samplesPerFrame = round (secondsPerFrame * 44100 / downsampleRate);

hopSizeInSecs   = 0.025;
hopSize         = floor (hopSizeInSecs * 44100 / downsampleRate);

load MAPS_MUS-chpn-p4_AkPnBcht.txt
midiScore = MAPS_MUS_chpn_p4_AkPnBcht;
[in, fs] = wavread( 'MAPS_MUS-chpn-p4_AkPnBcht.wav' );
in = mean(in, 2);
in = antiAlias(in, downsampleRate);
in = in(1:downsampleRate:end);

nBlocks         = floor( (length(in) - samplesPerFrame) / hopSize ) + 1;
hamWin          = hamming(samplesPerFrame);
grain           = zeros(fftSize, 1);
blockRMS        = zeros(1, nBlocks);
rmsThreshold    = 0.08;

score           = zeros(88, nBlocks);

load('dictionary.mat')

tic

for n = 0:nBlocks-1
    %grain = hamWin .* in( 1+n*hopSize:downsampleRate:n*hopSize+blockSize);
    grain = zeros(fftSize, 1);
    grain(1:samplesPerFrame) = hamWin .* in(1+n*hopSize : samplesPerFrame+n*hopSize); 
    blockRMS(n+1) = sqrt(mean(grain.^2));
end

maxRMS = max(blockRMS);

for n = 0:nBlocks-1
    if blockRMS(n+1) < rmsThreshold*maxRMS
        score(:,n+1) = zeros(88, 1);
    else
        grain = zeros(fftSize, 1);
        grain(1:samplesPerFrame) = hamWin .* in(1+n*hopSize : samplesPerFrame+n*hopSize); 
        spectrum = abs(fft(grain));
        score(:,n+1) = factorize(spectrum(1:fftSize/2), W, beta);
    end
end

toc

finalScore = postProcess(score);

save score score
save finalScore finalScore

[hit, miss, fa] = evaluate(finalScore, midiScore, hopSizeInSecs, fs, downsampleRate)

rmpath('MUS')