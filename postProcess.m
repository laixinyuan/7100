function [ finalScore ] = postProcess( score )

activeThreshold = 0.15;

finalScore = score.* (score>activeThreshold);
finalScore = finalScore > 0;

end

