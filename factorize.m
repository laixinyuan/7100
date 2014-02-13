function [ activeNotes ] = factorize( v, W, beta )
%FACTORIZE Summary of this function goes here
%   Detailed explanation goes here

threshold = 0.01;
maxCount  = 100;
h         = ones(88, 1);
count     = 0;

e = ones(88,1);
W_v_eT = W.*(v*e');

while dbeta(beta, v, W*h)>threshold && count<maxCount
%     h  = h .* ( ( W'*( (W*h).^(beta-2).*v) ) ./ ( W'*(W*h).^(beta-1)) );
    h = h.* ( ( W_v_eT'* (W*h).^(beta-2) ) ./ ( W'*(W*h).^(beta-1)) );
    count = count +1;
end

%whether this is legitimate
activeNotes = h;%/max(h);

end

