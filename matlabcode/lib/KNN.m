% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.

function [edges] = KNN( X, Y, K, dist_func, verbose )
%[ edges ] = KNN( X, Y, K, dist_func, verbose )
%   find the knn of X in Y. brutle force.
%	X/Y: each row is a sample. If only two inputs provided, then Y=X. Note that in this
%	case the self-edges are also added
%	K: K in knn
%
%   edges: result edges, (n*K)*3: (x, y, dist)

if nargin < 5
    verbose = false;
    if nargin < 4 || isempty(dist_func)
        dist_func = @L2Dist;
        if nargin < 3
            K = Y;
            Y = X;
        end
    end
end
if isempty(Y)
    Y = X;
end

[nx, dim] = size(X);
ny = size(Y, 2);

maxMem = 500;
batchSize = floor(maxMem*131072/ny);

edges = zeros(nx*K, 3);
tmp = repmat(1:nx, K, 1);
edges(:, 1) = tmp(:);

if verbose;fprintf('Finding %dNN in %d points for %d x %d data... ', K, ny, nx, dim);end

sI = 1;%start index
while sI <= nx
    eI = min(sI + batchSize, nx);

    dist = dist_func(Y, X(sI:eI, :));
    [dist minI] = sort(dist, 1, 'ascend');
    result = [minI(1:K, :), dist(1:K, :)];
    edges(((sI-1)*K + 1):(eI*K), 2:3) = reshape(result, (eI - sI + 1)*K, 2);

    sI = eI + 1;
    
    if verbose;fprintf('%d.',eI);end
end

if verbose; fprintf(' complete.\n'); end
