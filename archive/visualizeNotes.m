function [  ] = visualizeNotes( notes )
%VISUALIZENOTES Summary of this function goes here
%   Detailed explanation goes here

bar(1:88, notes)
set(gca, 'XTick',1:3:88, 'XTickLabel',num2note(1:3:88))

end

