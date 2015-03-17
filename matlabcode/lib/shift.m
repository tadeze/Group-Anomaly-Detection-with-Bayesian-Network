% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.

function [C]=shift(A, m, dim)
% [C]=shift(A, m, for_cols)
% shift rows or columns of A by m

if nargin < 3
    dim = 1;
    if nargin < 2
        m = [];
    end
end

if isempty(m)
    m = -mean(A, dim);
end

switch dim
  case 1
    C = bsxfun(@plus, A, m(:)');
  case 2
    C = bsxfun(@plus, A, m(:));
  otherwise
    error('unsupported dim')
end
