% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.

function [L] = Likelihood(self, X, lnpdf, group_id)
% [L] = Likelihood(self, X, lnpdf, group_id)
% the true likelihood of X under this model

chi = self.chi;
[K, T] = size(chi);
M = double(max(group_id));

if isempty(lnpdf)
    lnpdf = GMM([], self.mus, self.sigmas).GetProb(X, true);
end

gchiN = zeros(M, T);
for t = 1:T
    gchiN(:,t) = accumarray(group_id, ...
        logmulexp(lnpdf, log(chi(:,t))), [M, 1]);
end

L = logmulexp(gchiN, log(self.pi + eps(0.0)));
