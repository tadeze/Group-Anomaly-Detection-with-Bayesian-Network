% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.

function [ A, M, S ] = Normalize( A, method, dim )
%[ C, M, S ] = Normalize( A ) normalize columns/rows of A so that:
% method='01': range is [0, 1]
% method='+-1': range is [-1, 1]
% method='s1': sums to 1
% method='m0': zero mean
% method='v1': variance 1
% method='n1': L2 norm 1
% method='m0v1': 1 variance
% 
% C: result
% M: shift factors, should be applied first
% S: scaling factors

if nargin < 3
    dim = 1;
    if nargin < 2
        method = 'n1';
    end
end

if iscell(method)
    M = method{1};
    S = method{2};
else
    M = [];     S = [];
    switch lower(method)
        case '01'
            M = -full(min(A, [], dim));
            S = 1./(full(max(A, [], dim)) + M);
        case '+-1'
            mi = full(min(A, [], dim));
            ma = full(max(A, [], dim));
            M = -0.5*(mi + ma);
            S = 2./(ma - mi);
        case 's1'
            S = 1./full(sum(A, dim));
        case 'm0'
            M = -full(mean(A, dim));
        case'v1'
            S = 1./std(A, 0, dim);
        case 'n1'
            S = 1./sqrt(sum(A.^2, dim));
        case 'm0v1'
            M = -mean(A, dim);
            S = 1./std(A, 0, dim);
        otherwise
            disp('** nothing will be normalized');
    end
end

if ~isempty(M)
    A = shift(A, M, dim);
end

if ~isempty(S)
    ii = isinf(S);
    if any(ii)
       disp('** singular scalers');
       S(ii) = 1;
    end
    A = scale(A, S, dim);
end
