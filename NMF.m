clear

[in, fs] = wavread( 'MAPS_MUS-bach_846_AkPnBcht.wav' );
in = mean(in, 2);

beta           = 1.5;
fftSize        = 2^12;
downSampleRate = 2;
blockSize      = fftSize*downSampleRate;
hopSize        = blockSize/4;
nBlocks        = floor( (length(in) - blockSize) / hopSize ) + 1;
hamWin         = hamming(fftSize);
grain          = zeros(fftSize, 1);
blockRMS       = zeros(1, nBlocks);

score          = zeros(88, nBlocks);

load('dictionary.mat')

tic

for n = 0:nBlocks-1
    grain = hamWin .* in( 1+n*hopSize:downSampleRate:n*hopSize+blockSize);
    blockRMS(n+1) = sqrt(mean(grain.^2));
end

maxRMS = max(blockRMS);

for n = 0:nBlocks-1
    if blockRMS(n+1) < 0.1*maxRMS
        score(:,n+1) = zeros(88, 1);
    else
        grain = hamWin .* in( 1+n*hopSize:downSampleRate:n*hopSize+blockSize);
        spectrum = abs(fft(grain));
        score(:,n+1) = factorize(spectrum(1:fftSize/2), W, beta);
    end

end

toc