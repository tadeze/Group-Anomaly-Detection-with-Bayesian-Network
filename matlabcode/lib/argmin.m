% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.

function [i] = argmin(a, dim)
% [i] = argmin(a, dim)

if nargin < 2
    [dummy i] = min(a);
else
    [dummy i] = min(a, [], dim);
end
