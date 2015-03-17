% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.

function [ a ] = AccumRows( X, group_id, sz )
% [ a ] = AccumRows( x, group_id, sz )
%accumulate rows of X according to their group_id

[n, k] = size(X);
m = max(group_id);
if nargin < 3
    sz = [m, k];
end

row_idx = repmat(group_id(:), 1, k);
col_idx = repmat(1:k, n, 1);
a = accumarray([row_idx(:), col_idx(:)], X(:), sz);
