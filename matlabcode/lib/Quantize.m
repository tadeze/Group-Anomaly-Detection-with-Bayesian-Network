% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.

function [codebook, code] = Quantize(X, codebook, kmeans_iter)
%[codebook, code] = Quantize(X, codebook)
% quantize X (n x dim) using the codebook (or K). 
% if codebook is provided, then only returns the code
% if codebook is actually K, then the codebook is estimated using kmeans 
% and both the codebook and the code are returned

if nargin < 3
    kmeans_iter = 100;
end

if isscalar(codebook)
    K = codebook;
    try
        codebook = double(kml(single(X)', K, 3, kmeans_iter, false)');
        if nargout > 1
            code = NNClassify(X, codebook);
        end
    catch
        [code codebook] = kmeans(X, K);
    end
else
    codebook = NNClassify(X, codebook);
end
