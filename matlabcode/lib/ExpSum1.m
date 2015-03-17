% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.

function [ r ] = ExpSum1( A, dim )
%[ r ] = ExpSum1( A, dim )
% normalize exp(A) so that each row/column sums to 1

if nargin < 2
    dim = 1;
end

r = exp(bsxfun(@plus, A, -max(A, [], dim)));
r = bsxfun(@times, r, 1./sum(r, dim));
