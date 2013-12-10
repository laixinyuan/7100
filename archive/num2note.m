function [ noteName ] = num2note( pitch )
%NUM2NOTE Summary of this function goes here
%   Detailed explanation goes here

register = floor( (pitch+8)/12 );
noteName = cell(1, length(pitch) );

for n = 1:length(pitch)
    switch mod(pitch(n), 12)
        case 1
            pitchClass = 'A';
        case 2
            pitchClass = '#A';
        case 3
            pitchClass = 'B';
        case 4
            pitchClass = 'C';
        case 5
            pitchClass = '#C';
        case 6
            pitchClass = 'D';
        case 7
            pitchClass = '#D';
        case 8
            pitchClass = 'E';
        case 9
            pitchClass = 'F';
        case 10
            pitchClass = '#F';
        case 11
            pitchClass = 'G';
        case 0
            pitchClass = '#G';
        %otherwise
        %    error('Not a pitch on the piano');
    end
    
    noteName(n) = cellstr( strcat(pitchClass, num2str(register(n))));
end


end

