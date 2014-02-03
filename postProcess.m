function [ finalScore ] = postProcess( score )

score = medfilt1(score, 3, length(score), 2);

activeThreshold = 0.15;

finalScore = score.* (score>activeThreshold);
finalScore = finalScore > 0;

end