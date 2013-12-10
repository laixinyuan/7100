addpath('NO')

fftSize        = 2^12;
downSampleRate = 2;
win            = hamming(fftSize);
W              = zeros(fftSize/2, 88);

for n = 1:88
    if exist(['MAPS_ISOL_NO_M_S0_M' num2str(n+20) '_AkPnBcht.wav'], 'file')
        in=wavread(['MAPS_ISOL_NO_M_S0_M' num2str(n+20) '_AkPnBcht.wav']);
    else
        in=wavread(['MAPS_ISOL_NO_M_S1_M' num2str(n+20) '_AkPnBcht.wav']);
    end
    
    in = mean(in, 2);
    nonZeroIndex = 44100;   %find(in, 1, 'first');
    grain = win.*in(nonZeroIndex:downSampleRate:nonZeroIndex+downSampleRate*(fftSize-1));
    spectrum = abs(fft(grain));
    W(:,n)   = spectrum(1:fftSize/2)/max(spectrum); %normalize amp or spectrum???
end

save dictionary W

rmpath('NO')