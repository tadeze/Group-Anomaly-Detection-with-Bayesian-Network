% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.

function [m c] = MeanCov(X, weights)
% [m c] = MeanCov(X, weights)
% get the weighted mean and covariance of X.
% each row for one sample

if nargin < 2
    weights = [];
end

[n, dim] = size(X);
if isempty(weights)
    m = mean(X, 1);
    cX = bsxfun(@plus, X, -m);
    c = cX'*cX./n;
else
    weights = weights(:);
    sw = sum(weights);
    
    m = (weights'*X)./sw;
    cX = bsxfun(@plus, X, -m);
    c = cX'*bsxfun(@times, cX, weights)./sw;
end

c = 0.5*(c + c');
