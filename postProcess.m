function [ finalScore ] = postProcess( score )

finalScore = score.* (score>activeThreshold);
finalScore = finalScore > 0;

end

