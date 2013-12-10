addpath('sample')

len        = 2^14;
win        = hanningz(len);
W          = zeros(len/2, 88);

for n = 1:88
    audio    = wavread([num2str(n+20) '.wav']);
    audio    = mean(audio, 2);
    audio    = audio(1:len).*win;
    spectrum = abs(fft(audio));
    W(:,n)   = spectrum(1:len/2);
end

save dictionary W

rmpath('sample')