% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.

function [mgm, L] = Train(X, group_id, T, K, options)
% [mgm, L] = Train(X, group_id, T, K, options)
% train the MGM model
% X: design matrix of points. n x dim
% group_id: the group membership of each points. n x1
% T: number of genres
% K: number of topics
% options: ntry: number of random trials
%          para: use parallel processing

if nargin < 5
    options = [];
end

[n_try, para] = GetOptions(options, 'n_try', 5, 'para', false);

[n, dim] = size(X);
M = max(group_id);
fprintf('MGM for %d x %d data. M = %d, T = %d, K = %d\n',...
        n, dim, M, T, K);

R = cell(1, n_try);
L = zeros(1, n_try);
if para
    parfor tnd = 1:n_try
        [R{tnd} L(tnd)] = MGM.Train1(X, group_id, T, K, options);
    end
else
    for tnd = 1:n_try
        [R{tnd} L(tnd)] = MGM.Train1(X, group_id, T, K, options);
    end
end

ii = argmax(L);
L = L(ii);
mgm = R{ii};
