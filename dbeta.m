function [ db ] = dbeta( beta, x, y )
%DBETA Summary of this function goes here
%   Detailed explanation goes here

if beta == 0
    db = sum (x./y - log(x./y) - 1);
else
    if beta ==1
        db = sum( x.*log(x./y) + y - x );
    else
        db = sum( 1/(beta*(beta-1)) * ( x.^beta + (beta-1)*y.^beta - beta.*x.*y.^(beta-1) ) );
    end
end

end

