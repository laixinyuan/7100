addpath('NO')

clear

fftSize        = 2^10; 
secondsPerFrame = 0.05;
downsampleRate = 3; 
grain = zeros(fftSize, 1);
nValidSamples  = round(44100*secondsPerFrame/downsampleRate);%hard coding here
win            = hamming(nValidSamples); 
W              = zeros(fftSize/2, 88);

for n = 1:88
    if exist(['MAPS_ISOL_NO_M_S0_M' num2str(n+20) '_AkPnBcht.wav'], 'file')
        [in,fs]=wavread(['MAPS_ISOL_NO_M_S0_M' num2str(n+20) '_AkPnBcht.wav']);
    else
        [in,fs]=wavread(['MAPS_ISOL_NO_M_S1_M' num2str(n+20) '_AkPnBcht.wav']);
    end
    
    % stereo to mono, low pass, downsample
    in = mean(in, 2);
    in = antiAlias(in, downsampleRate);
    in = in(1:downsampleRate:end);
    
    startPoint = round(fs/downsampleRate);   %start from 1s
       
    grain(1:nValidSamples) = win.*in(startPoint:startPoint+nValidSamples-1);
    spectrum = abs(fft(grain));
    W(:,n)   = spectrum(1:fftSize/2)/max(spectrum); 
end

save dictionary W

WW = zeros(512*88,1);
for col = 1:88
    WW((col-1)*512+1:col*512,1) = W(:,col);
end
dlmwrite('dictionary.txt', WW)

rmpath('NO')