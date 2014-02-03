function [indx] = time2Indx(time, hopSecs)
    indx = round(time/hopSecs);
end