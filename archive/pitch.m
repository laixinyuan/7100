function [ notes ] = pitch( audio, fs, time )
%PITCH Summary of this function goes here
%   Detailed explanation goes here

beta      = 1.5;
threshold = 0.00001;
len       = 2^14;
audio     = mean(audio,2);
audio     = audio(round(time*fs):round(time*fs)+len-1).*hanningz(len);
spectrum  = abs(fft(audio));
v         = spectrum(1:len/2);
h         = ones(88, 1);
hp        = zeros(88, 1);
count     = 0;
load dictionary

while  sum(abs(h-hp)) > threshold && count<1000
    hp = h;
    h  = hp .* ( ( W'*( (W*hp).^(beta-2).*v) ) ./ ( W'*(W*hp).^(beta-1)) );
    count = count +1;
end

notes = h/max(h);

end

