function [hit, miss, fa] = evaluate(finalScore, midiScore, hopSizeInSecs, fs, downsampleRate)

hopSize         = round (hopSizeInSecs * fs / downsampleRate);
hopSecs   = hopSize/fs*downsampleRate;  %not seem to be accurate enough

len = size(finalScore, 2);

actualScoreInFrames   = zeros(88, len);

for n = 1:length(midiScore)
    startFrame = time2Indx(midiScore(n,1), hopSecs);
    endFrame   = time2Indx(midiScore(n,2), hopSecs);
    nthKey     = midiScore(n,3)-20;
    actualScoreInFrames( nthKey, startFrame:endFrame) = ones(1, endFrame-startFrame+1);
end

save actualScoreInFrames actualScoreInFrames

hit  = sum(sum( finalScore.*actualScoreInFrames )) / sum(sum(actualScoreInFrames));
miss = sum(sum( finalScore-actualScoreInFrames == -1)) / sum(sum(actualScoreInFrames));
fa   = sum(sum( finalScore-actualScoreInFrames ==  1)) / sum(sum(actualScoreInFrames));

load score
subplot(2,1,1)
imagesc(actualScoreInFrames)
set(gca, 'YDir', 'normal')
subplot(2,1,2)
imagesc(finalScore)
set(gca, 'YDir', 'normal')

end


function [indx] = time2Indx(time, hopSecs)
    indx = round(time/hopSecs);
end