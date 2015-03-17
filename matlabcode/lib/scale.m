% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.

function [C]=scale(A, s, dim)
% scale(A, s, for_cols)
% scale columns/rows by s

if nargin < 3
    dim = 1;
    if nargin < 2
        s = [];
    end
end

if isempty(s)
    s = 1./full(sum(A, dim));
else
    s = full(s);
end
s(isinf(s)) = 1;

switch dim
  case 1
    if issparse(A)
        C = A*spdiags(s, 0, size(A, 2), size(A, 2));
    else
        C = bsxfun(@times, A, s(:)');
    end    
  case 2
    if issparse(A)
        C = spdiags(s, 0, size(A, 1), size(A, 1))*A;
    else
        C = bsxfun(@times, A, s(:));
    end
  otherwise
    error('unsupported dim');
end
