% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.

function [ r ] = randm(p, n)
% [ r ] = randm( p, n)
% sample from a multinomial. return a column vector
% p: probability vector, each row should sum to 1. a scalar p means the number of bins
% n: number of samples to draw

if nargin < 2
    n = size(p, 1);
    cum_p = cumsum(p, 2);
    assert(all(abs(cum_p(:,end) - 1) < 1e-5), 'wrong distribution');
    d = bsxfun(@minus, cum_p, rand(n, 1));
    r = argmin((d <= 0)*2 + d, 2);
else
    if isscalar(p) %this is for uniform, p is the # of classes
        r = floor(rand(n,1)*p) + 1;
    else
        cum_p = cumsum(p(:));
        assert(abs(cum_p(end) - 1) < 1e-10, 'wrong distribution');
        
        try
            r = randmc(cum_p, rand(n,1));
        catch
            d = bsxfun(@minus, cum_p, rand(1, n));
            [dummy, r] = min((d <= 0)*2 + d, [], 1);
        end
    end
end
