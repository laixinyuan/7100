function [ y ] = antiAlias( x, downsampleRate )
%ANTIALIAS Summary of this function goes here
%   Detailed explanation goes here

x = [zeros(2,1); x];
xh = zeros(length(x), 1);
y = zeros(length(x), 1);

Q = 2;
K = tan(pi/downsampleRate);

b0 = K^2*Q/(K^2*Q+K+Q);
b1 = 2*K^2*Q/(K^2*Q+K+Q);
b2 = K^2*Q/(K^2*Q+K+Q);
a1 = 2*Q*(K^2-1)/(K^2*Q+K+Q);
a2 = (K^2*Q-K+Q)/(K^2*Q+K+Q);

for n = 3:length(x)
    xh(n) = x(n) - a1*xh(n-1) - a2*xh(n-2);
    y(n) = b0*xh(n) + b1*xh(n-1) + b2*xh(n-2);
end

y = y(3:end);

end

